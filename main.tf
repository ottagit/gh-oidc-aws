# Tell Terraform which service to use for resource setup
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Owner     = "Chris Otta"
    }
  }
}

module "github_actions" {
  source = "github.com/ottagit/modules//ci-cd/global/iam/github-actions?ref=v0.2.1"

  allowed_repos_branches = [{
    org    = "ottagit"
    repo   = "gh-actions-test"
    branch = "main"
    }
  ]

  name            = "github-actions-role"
  dynamo_db_table = "terraone-locks"
  s3_bucket_name  = "batoto-bitange"
  path_to_key     = "global/iam/github-actions/githuboidc.tfstate"
}

terraform {
  backend "s3" {
    key = "global/iam/github-actions/githuboidc.tfstate"

    bucket = "batoto-bitange"
    region = "us-east-1"

    dynamodb_table = "terraone-locks"
    encrypt        = true
  }
}