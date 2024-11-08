generate_hcl "_terraform_data.tf" {
    inherit = false

    content {
        resource "terraform_data" "example" {
            input = "example"
        }
    }
}
