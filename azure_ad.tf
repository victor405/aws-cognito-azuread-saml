data "azuread_client_config" "current" {}

resource "azuread_application" "aws_cognito_sso" {
  display_name     = "AWS Cognito SSO ${var.app_name}"
  identifier_uris  = local.identifierUris
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }

  web {
    homepage_url  = local.signInUrl
    logout_url    = local.logoutURL
    redirect_uris = local.redirectUris

    implicit_grant {
      access_token_issuance_enabled = true
    }
  }
}