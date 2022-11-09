variable "token" {
 type = string
}
variable "key" {
  type = list
  default = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNm4pL78YE6j9FTD6lGPzGIXl94q2118orskmYoSfr5qzZspXhhLlMu2Y9R20/8KVns1T8j9Q/fb9X33MtjuPRoNmz5LPIqoIYblbujdFqt+5vpz2YbfHPEBC5GrN2XHw4wFzyXCki5DaYC6Ktj2brJGUJomrIc2hwzK+wV2ncGLZv73E1+sDUdGuuLFeU60lvrK6fp03KN3Dyouc61RDPmG81omA5obcf4jBdA6FjoOpVq64XYqR0kzUhM2DXKsnagfkV9oFBfDdz3U+JZRz7ubR4iPtojq5LyQE8Ah3q2CDPxrEBKkJbglRoPBRQ0NGtyNH83HfIPZctkLMx8ja3"]
}
variable "tag" {
  type = string
}
variable "myKey" {
  type = string
}
variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
variable "module" {
  type = string
}
variable "mail" {
  type = string
}
variable "keyfile" {
  type = string
}
variable "devs" {
  type = map
}
