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

module "jenkins_server" {
  source = "github.com/ottagit/modules//ci-cd/global/github-actions?ref=v0.1.4"

  allowed_repos_branches = [ {
        org    = "ottagit"
        repo   = "gh-actions-test"
        branch = "main" 
      }
  ]
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