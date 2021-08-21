import { LoginRequest, RegisterRequest } from "../requests";
import { uuid } from "uuidv4";
import bcrypt, { hash } from "bcrypt";

export type User = {
  id: string;
  email: string;
  username: string;
  bio?: string;
  image?: string;
  passwordHash: string;
};

export type UserRepo = {
  getUserByUsername: (username: string) => Promise<User | undefined>;
  getUserByEmail: (email: string) => Promise<User | undefined>;
  getUser: (id: string) => Promise<User | undefined>;
  putUser: (user: User, notIfExists?: boolean) => Promise<void>;
};

const hashPassword = (password: string): Promise<string> =>
  new Promise((res, rej) =>
    bcrypt.hash(password, 10, (e, p) => (e ? rej(e) : res(p)))
  );

const validatePassword = (attempt: string, hash: string): Promise<boolean> =>
  new Promise((res, rej) =>
    bcrypt.compare(attempt, hash, (err, ok) => (err ? rej(err) : res(ok)))
  );
export type UserService = {
  getUser: (userId: string) => Promise<User | undefined>;
  loginUser: (req: LoginRequest) => Promise<User | undefined>;
  registerUser: (req: RegisterRequest) => Promise<User | "UserExists">;
};

export const buildUserService = (repo: UserRepo): UserService => ({
  getUser: (id) => repo.getUser(id),
  loginUser: async (req) => {
    const user = await repo.getUserByEmail(req.email);
    if (!user) {
      return undefined;
    }
    const isValid = await validatePassword(req.password, user.passwordHash);
    return isValid ? user : undefined;
  },
  registerUser: async (req) => {
    const userByEmailP = repo.getUserByEmail(req.email);
    const userByUsernameP = repo.getUserByEmail(req.username);
    const [userByEmail, userByUsername] = await Promise.all([
      userByEmailP,
      userByUsernameP,
    ]);
    if (userByEmail || userByUsername) {
      return "UserExists";
    }
    const id = uuid();
    const { password, ...userParams } = { id, ...req };
    const passwordHash = await hashPassword(password);
    const user = { passwordHash, ...userParams };
    await repo.putUser(user);
    return user;
  },
});
