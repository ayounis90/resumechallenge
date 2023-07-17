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
