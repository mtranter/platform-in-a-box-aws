import { APIGatewayProxyEvent, APIGatewayProxyEventV2 } from "aws-lambda";
import { User } from "../domain/user-service";
import jwt from "jsonwebtoken";

export type JwtUser = Pick<User, "id">;
export type Jwt = ReturnType<typeof buildJwt>;
export const buildJwt = (secret: string, _jwt: typeof jwt = jwt) => ({
  getUserFromHeader: async (orig: {
    originalEvent: APIGatewayProxyEvent | APIGatewayProxyEventV2;
  }): Promise<JwtUser | undefined> => {
    const authHeader = orig.originalEvent.headers["authorization"];
    const token = authHeader?.substring("Token ".length);
    if (!token) {
      return undefined;
    }
    try {
      return _jwt.verify(token, secret) as JwtUser;
    } catch {
      return undefined;
    }
  },
  sign: (o: object) => _jwt.sign(o, secret),
});
