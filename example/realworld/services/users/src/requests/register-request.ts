import { Static, Type } from '@sinclair/typebox';

export const RegisterRequestSchema = Type.Object({
  username: Type.String({ minLength: 4, maxLength: 64 }),
  email: Type.String({
    pattern: '^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$'
  }),
  password: Type.String({ minLength: 8 })
});

export type RegisterRequest = Static<typeof RegisterRequestSchema>;
