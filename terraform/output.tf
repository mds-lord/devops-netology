output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "user_id" {
  value = data.aws_caller_identity.current.user_id
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "ec2_private_ip" {
  value = join("", aws_instance.netology_test[*].private_ip)
}

output "ec2_subnet_id" {
  value = join("", aws_instance.netology_test[*].subnet_id)
}
