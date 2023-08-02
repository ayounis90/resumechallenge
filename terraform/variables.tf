variable "domainName" {
  default = "aneilyounisresume.com"
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "bucketName" {
  default = "aneilresumechallenge"
  type    = string
}

variable "sharedProfile" {
  default = "shared"
  type    = string
}

variable "devProfile" {
  default = "dev"
  type    = string
}

variable "prodProfile" {
  default = "prod"
  type    = string
}

# Controls which environment will be deployed to
variable "provider_env" {
  default = "dev"
  type    = string
}
