provider "aws" {
  profile = var.sharedProfile
  region  = var.region
  alias   = "shared"
}

provider "aws" {
  profile = var.devProfile
  region  = var.region
  alias   = "dev"
}

provider "aws" {
  profile = var.prodProfile
  region  = var.region
  alias   = "prod"
}