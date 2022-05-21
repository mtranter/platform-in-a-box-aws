import { DynamoDB } from 'aws-sdk';
import XRay from 'aws-xray-sdk-core';

import { buildDynamoUserRepo } from './services/dynamo-user-repo';
import { buildUserService } from './domain/user-service';
import { buildApi } from './api/routes';
import { buildJwt } from './api/jwt';

const envOrThrow = (env: string): string => {
  const envVar = process.env[env];
  if (!envVar) {
    throw new Error(`Expected env var not found: ${env}`);
  } else {
    return envVar;
  }
};

export const handler = buildApi(
  buildUserService(buildDynamoUserRepo(envOrThrow('DYNAMODB_TABLE_NAME'), XRay.captureAWSClient(new DynamoDB()))),
  buildJwt(envOrThrow('JWT_SECRET'))
);
