import { DynamoDB } from "aws-sdk";
import XRay from "aws-xray-sdk-core";

import { buildDynamoUserRepo } from "./services/dynamo-user-repo";
import { buildUserService } from "./domain/user-service";
import { buildApi } from "./api/routes";
import { buildJwt } from "./api/jwt";

export const handler = buildApi(
  buildUserService(
    buildDynamoUserRepo(
      process.env.DYNAMODB_TABLE_NAME!,
      XRay.captureAWSClient(new DynamoDB())
    )
  ),
  buildJwt(process.env.JWT_SECRET!)
);
