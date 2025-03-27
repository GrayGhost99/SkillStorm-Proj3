# variables.tf

# subscription
variable "sub" {
  description = "Subscription Info"
  type        = string
  default     = ""
}

# RG info
variable "rg_loc" {
  description = "Resource Group Location"
  type        = string
  default     = "eastus"
}
variable "rg_name" {
  description = "Resource Group Name"
  type        = string
  default     = "michael-moore-upskill"
}
