terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = ">= 0.45.0"
    }
  }
  required_version = ">= 1.3"
}
