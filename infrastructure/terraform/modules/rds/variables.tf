variable "db_identifier" {
  type        = string
  description = "Identifier for the RDS DB instance"
}

variable "db_name" {
  type        = string
  description = "Name of the Postgres database"
}

variable "db_username" {
  type        = string
  description = "DB username"
}

variable "db_password" {
  type        = string
  description = "DB password"
  sensitive   = true
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for DB"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID to attach to RDS"
}
