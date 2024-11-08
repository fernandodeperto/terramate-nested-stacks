generate_hcl "backend.tf" {
  inherit = true

  content {
    terraform {
      backend "local" {}
    }
  }
}
