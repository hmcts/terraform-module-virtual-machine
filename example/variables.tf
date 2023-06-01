variable "env" {
  type    = string
  default = "test"
}

variable "common_tags" {
  type    = map(string)
  default = null
}
