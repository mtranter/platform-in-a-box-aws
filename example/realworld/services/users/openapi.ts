import { writeFileSync } from "fs";
import { buildApi } from "./src/api";

export const OpenApiSpec = buildApi(null as any).toOpenApi(
  {
    title: "Platform In A Box ECommerce Pricing API",
    version: "1.0.0",
  },
  "${FUNCTION_ARN}"
);

const fileLocation = process.argv[2] || "./openapi.json";
writeFileSync(fileLocation, JSON.stringify(OpenApiSpec, null, 2));
