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

# Deploy in CircleCI workflow
module "github_actions" {
  source = "github.com/ottagit/modules//ci-cd/global/iam/github-actions?ref=v0.4.2"

  allowed_repos_branches = [{
    org    = "ottagit"
    repo   = "terraone"
    branch = "main"
    }
  ]

  name                    = "github-actions-role"
  dynamo_db_table         = "terraone-locks"
  s3_bucket_name          = "batoto-bitange"
  path_to_web_cluster_key = "stage/services/webserver-cluster/terraform.tfstate"
  path_to_data_store_key  = "stage/data-stores/mysql/terraform.tfstate"
}

terraform {
  backend "s3" {
    key = "global/iam/github-actions/terraform.tfstate"

    bucket = "batoto-bitange"
    region = "us-east-1"

    dynamodb_table = "terraone-locks"
    encrypt        = true
  }
}