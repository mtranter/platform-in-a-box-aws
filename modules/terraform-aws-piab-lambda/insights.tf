locals {

  insights_layers = ["arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:us-east-2:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:us-west-1:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:us-west-2:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:af-south-1:012438385374:layer:LambdaInsightsExtension:9",
    "arn:aws:lambda:ap-east-1:519774774795:layer:LambdaInsightsExtension:9",
    "arn:aws:lambda:ap-south-1:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:ap-northeast-2:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:ap-southeast-1:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:ap-southeast-2:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:ap-northeast-1:580247275435:layer:LambdaInsightsExtension:23",
    "arn:aws:lambda:ca-central-1:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws-cn:lambda:cn-north-1:488211338238:layer:LambdaInsightsExtension:9",
    "arn:aws-cn:lambda:cn-northwest-1:488211338238:layer:LambdaInsightsExtension:9",
    "arn:aws:lambda:eu-central-1:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:eu-west-1:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:eu-west-2:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:eu-south-1:339249233099:layer:LambdaInsightsExtension:9",
    "arn:aws:lambda:eu-west-3:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:eu-north-1:580247275435:layer:LambdaInsightsExtension:16",
    "arn:aws:lambda:me-south-1:285320876703:layer:LambdaInsightsExtension:9",
  "arn:aws:lambda:sa-east-1:580247275435:layer:LambdaInsightsExtension:16"]
  insights_layers_region_map = { for v in local.insights_layers : split(":", v)[3] => v }
}
