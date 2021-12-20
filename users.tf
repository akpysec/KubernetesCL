# Users
resource "aws_iam_user" "mysql_users" {
  count = length(var.user_list)
  name  = element(var.user_list, count.index)
}

resource "aws_iam_user_policy_attachment" "mysql_users_policy" {
  count      = length(var.user_list)
  user       = element(aws_iam_user.mysql_users.*.name, count.index)
  policy_arn = aws_iam_policy.policy_mysql_users.arn
}

resource "aws_iam_policy" "policy_mysql_users" {
  name   = "ec2-read-only"
  policy = data.aws_iam_policy_document.policy_json.json
}

data "aws_iam_policy_document" "policy_json" {
  statement {
    actions = [
    "rds:Describe*"]
    resources = [
    "*"]
  }
}