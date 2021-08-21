import { Static, Type } from "@sinclair/typebox";

export const LoginRequestSchema = Type.Object({
  email: Type.String(),
  password: Type.String(),
});

export type LoginRequest = Static<typeof LoginRequestSchema>;
