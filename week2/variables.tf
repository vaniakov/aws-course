variable "ami" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  default     = "ami-02b92c281a4d3dc79"
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type to use for the server."
  default     = "t1.micro"
}

variable "key_name" {
  type        = string
  description = "SSH key name (region specific)."
  default     = "lohikaMBP-west"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name."
  default     = "ikova-aws-course-3"
}

variable "file_name" {
  type        = string
  description = "File name in the bucket."
  default     = "small.txt"
}
