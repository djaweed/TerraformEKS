
variable "cidr_block" {}
variable "public_subnets" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "name" {}

variable "tags" {
  type    = map(string)
  default = {}
}
