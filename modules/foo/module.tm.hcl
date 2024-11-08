globals {
    foo_variable = "foo"
}

generate_hcl "_foo.tf" {
    inherit = false

    content {
        module "foo" {
            source = "${terramate.stack.path.to_root}/modules/foo"

            foo_variable = global.foo_variable
        }

        output "terraform_data" {
            value = module.foo.terraform_data
        }
    }
}
