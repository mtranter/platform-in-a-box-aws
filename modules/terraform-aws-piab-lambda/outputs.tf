output "function" {
  value = aws_lambda_function.lambda
}

output "execution_role" {
  value = aws_iam_role.iam_for_lambda
}

output "log_group" {
  value = module.log_group.log_group
}

output "alias" {
  value = local.publish ? aws_lambda_alias.lambda_alias : null
}

output "invoke_arn" {
  value = local.publish ? aws_lambda_alias.lambda_alias[0].invoke_arn : aws_lambda_function.lambda.invoke_arn
}
output "qualifier" {
  value = local.publish ? aws_lambda_alias.lambda_alias[0].name : null
}