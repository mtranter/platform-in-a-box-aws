import { DynamoDB } from "aws-sdk";
import { tableBuilder } from "funamots";
import { OR } from "funamots/dist/lib/conditions";
import { User, UserRepo } from "../domain/user-service";

type RRPDto = {
  rrp: number;
};

type Dto = {
  hash: string;
  range: string;
  gsi1Hash: string;
  gsi2Hash: string;
  data: User;
};

export const buildDynamoUserRepo = (
  tableName: string,
  client: DynamoDB
): UserRepo => {
  const table = tableBuilder<Dto>(tableName)
    .withKey("hash", "range")
    .withGlobalIndex("gsi1", "gsi1Hash", "range")
    .withGlobalIndex("gsi2", "gsi2Hash", "range")
    .build({ client });
  const userHashKey = (id: string) => `USER#${id}`;
  const userRangeKey = () => `#USER#`;
  const userKey = (userId: string): Pick<Dto, "hash" | "range"> => ({
    hash: userHashKey(userId),
    range: userRangeKey(),
  });
  const userDto = (user: User): Dto => ({
    ...userKey(user.id),
    gsi1Hash: user.email,
    gsi2Hash: user.username,
    data: user,
  });
  return {
    putUser: (user) => table.put(userDto(user)),
    getUser: (id) => table.get(userKey(id)).then((r) => r?.data),
    getUserByEmail: (email) =>
      table.indexes.gsi1
        .query(email)
        .then((r) => (r.records.length > 0 ? r.records[0].data : undefined)),
    getUserByUsername: (username) =>
      table.indexes.gsi2
        .query(username)
        .then((r) => (r.records.length > 0 ? r.records[0].data : undefined)),
  };
};
