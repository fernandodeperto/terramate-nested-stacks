globals {
    bar_variable = "bar"
}

generate_hcl "_bar.tf" {
    inherit = false

    content {
        module "bar" {
            source = "${terramate.stack.path.to_root}/modules/bar"

            bar_variable = global.bar_variable
        }

        output "terraform_data" {
            value = module.bar.terraform_data
        }
    }
}
