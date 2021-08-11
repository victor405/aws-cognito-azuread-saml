data "aws_region" "current" {}

resource "aws_cognito_user_pool" "pool" {
  name                     = "${var.app_name}-user-pool"
  auto_verified_attributes = ["email"]
  username_attributes      = ["email"]

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = false
    required            = true
  }

  schema {
    name                = "name"
    attribute_data_type = "String"
    mutable             = false
    required            = true
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }
}

resource "aws_cognito_user_pool_client" "client" {
  depends_on = [
    aws_cognito_identity_provider.azure_ad
  ]
  
  name          = "${var.app_name}-cognito-client"
  user_pool_id  = aws_cognito_user_pool.pool.id
  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_flows = [
    "code",
  ]

  allowed_oauth_scopes = [
    "aws.cognito.signin.user.admin",
    "email",
    "openid",
    "phone",
    "profile",
  ]

  supported_identity_providers = [
    "COGNITO",
    var.provider_name
  ]
}

resource "aws_cognito_user_pool_domain" "prefix_domain" {
  domain       = var.cognito_prefixdomain
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_identity_provider" "azure_ad" {
  user_pool_id    = aws_cognito_user_pool.pool.id
  provider_name   = var.provider_name
  provider_type   = "SAML"
  idp_identifiers = var.azure_custom_domain

  provider_details = {
    MetadataURL = local.metadata_doc
    IDPSignout  = true
  }

  attribute_mapping = {
    email = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
    name  = "http://schemas.microsoft.com/identity/claims/displayname"
  }

  lifecycle {
    ignore_changes = [
      provider_details
    ]
  }
}
