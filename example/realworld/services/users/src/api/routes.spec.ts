import {
  APIGatewayProxyEvent,
  APIGatewayProxyResult,
  Context,
} from "aws-lambda";
import { buildApi } from "./routes";
import { buildUserService } from "../domain";
import { buildJwt, Jwt } from "./jwt";
import jwt from "jsonwebtoken";
import { RegisterRequest } from "../requests";

describe("Pricing API", () => {
  const putUser = jest.fn();
  const getUser = jest.fn();
  const getUserByEmail = jest.fn();
  const getUserByUsername = jest.fn();
  const mockRepo = {
    putUser,
    getUser,
    getUserByEmail,
    getUserByUsername,
  };
  const svc = buildUserService(mockRepo);

  const sut = buildApi(svc, buildJwt("secret"));
  const callApi = (
    r: Partial<APIGatewayProxyEvent>
  ): Promise<APIGatewayProxyResult> => {
    const req = { ...r, headers: { "content-type": "application/json" } };
    return sut(
      req as APIGatewayProxyEvent,
      {} as unknown as Context,
      undefined as any
    ) as Promise<APIGatewayProxyResult>;
  };
  afterEach(() => {
    jest.clearAllMocks();
    jest.resetAllMocks();
  });
  describe("Register User", () => {
    const doRegister = (req: RegisterRequest) =>
      callApi({
        path: `/register`,
        httpMethod: "POST",
        body: JSON.stringify(req),
      });
    describe("When no user with the same details exists", () => {
      beforeEach(() => {
        getUserByEmail.mockResolvedValue(undefined);
        getUserByUsername.mockResolvedValue(undefined);
      });
      const act = () =>
        doRegister({
          username: "jsmith",
          email: "jsmith@jsmith.com",
          password: "p@55w0rd",
        });
      it("Should return 201", async () => {
        const result = await act();
        expect(result.statusCode).toEqual(201);
      });
      it("Should return a user", async () => {
        const result = await act();
        const response = JSON.parse(result.body);
        expect(response).toMatchObject({
          username: "jsmith",
          email: "jsmith@jsmith.com",
          token: expect.any(String),
          bio: "",
          image: "",
        });
      });
    });
  });
});
