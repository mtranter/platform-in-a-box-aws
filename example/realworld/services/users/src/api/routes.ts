import { LambdaRouter } from 'ts-lambda-router';

import { RegisterRequestSchema } from './../requests/register-request';
import { LoginRequestSchema } from './../requests/login-request';
import { User, UserService } from './../domain/user-service';
import { Jwt } from './jwt';

type UserResponse = {
  email: string;
  token: string;
  username: string;
  bio: string;
  image: string;
};

export const buildApi = (svc: UserService, jwt: Jwt) => {
  const buildUserResponse = (u: User): UserResponse => {
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { passwordHash, ...safeUser } = u;
    const token = jwt.sign(safeUser);
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { id, ...user } = u;
    return { bio: '', image: '', ...user, token };
  };
  return LambdaRouter.build((r) =>
    r
      .post(
        '/register',
        RegisterRequestSchema,
        {}
      )(async (req) => {
        const response = await svc.registerUser(req.body);
        return response === 'UserExists'
          ? req.response(409, 'User Exists')
          : req.response(201, buildUserResponse(response));
      })
      .post(
        '/login',
        LoginRequestSchema
      )(async (req) => {
        const user = await svc.loginUser(req.body);
        if (!user) {
          return req.response(401, 'Unauthorized');
        }
        return req.response(200, buildUserResponse(user));
      })
      .get('/me')(async (req, orig) => {
      const jwtUser = await jwt.getUserFromHeader(orig);
      if (!jwtUser) {
        return req.response(401, 'Unauthorized');
      } else {
        const user = await svc.getUser(jwtUser.id);
        return user ? req.response(200, user) : req.response(401, 'Unauthorized');
      }
    })
  );
};
