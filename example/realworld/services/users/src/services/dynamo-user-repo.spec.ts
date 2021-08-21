import { DynamoDB } from "aws-sdk";
import { User } from "../domain/user-service";
import { buildDynamoUserRepo } from "./dynamo-user-repo";

describe("DynamoDB Repo", () => {
  const dynamoDbClient = new DynamoDB({
    endpoint: "localhost:8000",
    sslEnabled: false,
    region: "local-env",
    credentials: {
      accessKeyId: "fakeMyKeyId",
      secretAccessKey: "fakeSecretAccessKey",
    },
  });
  const sut = buildDynamoUserRepo("UserService", dynamoDbClient);
  describe("User CRUD", () => {
    it("should put and get RRP", async () => {
      const user: User = {
        id: "1",
        username: "JSmith",
        email: "j.smith@smithtown.com",
        passwordHash: "#",
      };
      await sut.putUser(user);
      const userById = await sut.getUser(user.id);
      const userByEmail = await sut.getUserByEmail(user.email);
      const userByUsername = await sut.getUserByUsername(user.username);
      expect(userById).toEqual(user);
      expect(userByEmail).toEqual(user);
      expect(userByUsername).toEqual(user);
    });
  });
});
