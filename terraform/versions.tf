variable "concourse_version" {
  type        = string
  default     = "16.1.21"
}

variable "kong_version" {
  type        = string
  default     = "2.7.0"
}

variable "gitea_version" {
  type        = string
  default     = "5.0.4"
}

variable "coredns_version" {
  type        = string
  default     = "1.19.0"
}

variable "ingress_nginx_version" {
  type        = string
  default     = "4.0.18"
}

variable "kratos_version" {
  type        = string
  default     = "0.23.1"
}

variable "oauth2_proxy_version" {
  type        = string
  default     = "7.2.1"
}

variable "dex_version" {
  type  = string
  default = "0.8.2"
}
