# Group "developers"
resource "aws_iam_group" "developers" {
  name = "developers"
}

# Policy attached to a group "developers"
resource "aws_iam_group_policy" "my_developer_policy" {
  name  = "my_developer_policy"
  group = aws_iam_group.developers.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"AllowRDSDescribe",
         "Effect":"Allow",
         "Action":"rds:Describe*",
         "Resource":"*"
      }
   ]
})
}

# User "developer"
resource "aws_iam_user" "developer" {
  name = "developer"

  tags = {
    tag-key = "tag-value"
  }
}

# User attached to group "developers"
resource "aws_iam_user_group_membership" "developer_to_group" {
  user = aws_iam_user.developer.name

  groups = [
    aws_iam_group.developers.name,
    aws_iam_group.developers.name,
  ]
}