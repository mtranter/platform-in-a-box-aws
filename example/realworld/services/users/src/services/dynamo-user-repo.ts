import { DynamoDB } from 'aws-sdk';
import { tableBuilder } from 'funamots';
import { Event, User, UserRepo } from '../domain/user-service';

type Dto = {
  hash: string;
  range: string;
  gsi1Hash?: string;
  gsi2Hash?: string;
  data: User | Event;
};

const userHashKey = (id: string) => `USER#${id}`;
const userRangeKey = () => `#USER#`;
const userKey = (userId: string): Pick<Dto, 'hash' | 'range'> => ({
  hash: userHashKey(userId),
  range: userRangeKey()
});
const userDto = (user: User): Dto => ({
  ...userKey(user.id),
  gsi1Hash: user.email,
  gsi2Hash: user.username,
  data: user
});

const eventDto = (e: Event): Dto => ({
  hash: `EVENT#${e.eventId}`,
  range: 'EVENT',
  data: e
});

export const buildDynamoUserRepo = (tableName: string, client: DynamoDB): UserRepo => {
  const table = tableBuilder<Dto>(tableName)
    .withKey('hash', 'range')
    .withGlobalIndex('gsi1', 'gsi1Hash', 'range')
    .withGlobalIndex('gsi2', 'gsi2Hash', 'range')
    .build({ client });
  return {
    transactionally: async (handler) => {
      const dtos: Dto[] = [];
      await handler({
        putEvent: (e) => dtos.push(eventDto(e)),
        putUser: (u) => dtos.push(userDto(u))
      });
      await table.transactPut(
        dtos.map((d) => ({
          item: d
        }))
      );
    },
    getUser: (id) => table.get(userKey(id)).then((r) => r?.data as User),
    getUserByEmail: (email) =>
      table.indexes.gsi1.query(email).then((r) => (r.records.length > 0 ? (r.records[0].data as User) : undefined)),
    getUserByUsername: (username) =>
      table.indexes.gsi2.query(username).then((r) => (r.records.length > 0 ? (r.records[0].data as User) : undefined))
  };
};
