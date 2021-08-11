locals {
  depends_on = [
    aws_cognito_user_pool.pool,
    aws_cognito_user_pool_client.client,
    azuread_application.aws_cognito_sso
  ]
  
  signInUrl       = "https://${var.cognito_prefixdomain}.auth.${data.aws_region.current.name}.amazoncognito.com/login?response_type=code&client_id=${aws_cognito_user_pool_client.client.id}&redirect_uri=${var.app_domain}"
  identifierUris  = ["urn:amazon:cognito:sp:${aws_cognito_user_pool.pool.id}"]
  logoutURL       = "https://${var.cognito_prefixdomain}.auth.${data.aws_region.current.name}.amazoncognito.com/logout?response_type=code&client_id=${aws_cognito_user_pool_client.client.id}&redirect_uri=${var.app_domain}"
  redirectUris    = ["https://${var.cognito_prefixdomain}.auth.${data.aws_region.current.name}.amazoncognito.com/saml2/idpresponse"]
  metadata_doc    = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/federationmetadata/2007-06/federationmetadata.xml"
}

locals {
  common_tags = {
    Environment = var.environment
  }
}

variable "app_domain" {
  type        = string
  default     = "http://localhost:4200"
  description = "The app domain that the user is directed to after AAD Authentication."
}

variable "app_name" {
  type        = string
  default     = "thread"
  description = "App name used for identification."
}

variable "azure_custom_domain" {
  type        = list(string)
  default     = ["*.onmicrosoft.com"]
  description = "Azure Custom Domain (i.e. user@*.onmicrosoft.com)."
}

variable "azure_location" {
  type        = string
  default     = "eastus2"
  description = "Default Azure Location."
}

variable "callback_urls" {
  type        = list(string)
  default     = ["http://localhost:4200"]
  description = "Cognito App Client call back Urls."
}

variable "cognito_prefixdomain" {
  type        = string
  default     = "thread-domain-test2"
  description = "prefixdomain added to cognito's full Url."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment (i.e. dev, stag, uat, prod)."
}

variable "logout_urls" {
  type        = list(string)
  default     = ["http://localhost:4200"]
  description = "Cognito App Client Logout Urls."
}

variable "provider_name" {
  type        = string
  default     = "Azure"
  description = "Cognito Identity Provider Azure Name."
}