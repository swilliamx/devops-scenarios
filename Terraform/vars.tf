variable in_node_count {
  description = "The number of nodes that this fixed size ec2 instance cluster should bring up."
  default     = 1
}

variable "default_ec2_tags" {
  description = "Default set of tags to apply to EC2 instances"
  type        = map
  default = {
    Environment = "Development"
    SupportTeam = "Engineering"
    Contact     = "xpaceform@gmail.com"
  }
}

