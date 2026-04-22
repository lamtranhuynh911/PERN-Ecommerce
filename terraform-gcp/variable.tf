# Define the project ID variable
variable "project_id" {
  description = "The ID of your Google Cloud Project"
  type        = string
}

# Define the region variable
variable "region" {
  description = "The default compute region"
  type        = string
  default     = "asia-southeast1" 
}