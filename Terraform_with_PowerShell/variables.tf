variable "windows-server-ami" {
  description = "AMI for Windows Server 2022"
  type        = string
  default     = "ami-0fc682b2a42e57ca2"
}

variable "instance-type" {
  description = "1 vCPU, 1 GiB memory, 0.0162 cents per hour"
  type        = string
  default     = "t2.small"
}

variable "availability_zone" {
  description = "Location of server"
  type        = string
  default     = "us-east-1a"
}
