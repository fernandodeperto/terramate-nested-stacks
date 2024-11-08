# Terramate Nested Stacks

This repository is an exercise on how to manage Terraform resources with Terramate in a way that makes sense, following the notion that nested stacks should be used for managing different parts of the overall infrastructure, while at the same time separating the remote states, which is one of the main Terramate advantages.

![Nested Stacks](https://terramate.io/docs/assets/nested-stacks.BpZcLktx.png)
Figure 1: Nested stacks showing a hierarchical structure

This is in opposition to what seems to be the default result, which is that nested stacks are merely specializations of their parents. This is a natural consequence of the way code generation works in Terramate. Consider for example the following snippet, added to the parent stack, here called `level_one`:

```hcl
generate_hcl "_bar.tf" {
    content {
        resource "terraform_data" "example" {
            input = "example"
        }
    }
}
```

After generating the code with the command `terramate generate`, the following output is shown:

```
Code generation report

Successes:

- /stacks/level_one
        [+] _terraform_data.tf

- /stacks/level_one/level_two
        [+] _terraform_data.tf

Hint: '+', '~' and '-' mean the file was created, changed and deleted, respectively.
```

As can be seen in the output, the `_terraform_data.tf` file is generated both on the parent and child stacks. This is fine if it is the indented result, for example if the stacks are used to manage an EC2 instance, with the difference that the child stack also includes an extra volume. On the other hand, if the stacks are meant to be hierarchical, this is an annoyance.

Currently, according to the documentation, there are a few different ways to work around this limitation. For more details, see [Best Practices](https://terramate.io/docs/cli/code-generation/#best-practices).

## Ad-hoc HCL Code Generation

Ad-hoc code generation is an experimental features that can be used to write Terraform code (not Terramate) but also access some of the Terramate contextual information, such as `globals`. Because by default Terraform code written on a stack level is not inherited by children stacks, this method can be used to create the hierarchical structure.

First, the Terramate config file needs to contain the following snippet:

```hcl
terramate {
  config {
    # Enables the simplified adhoc HCL code generation
    # https://terramate.io/docs/cli/code-generation/tmgen
    experiments = [
      "tmgen"
    ]
  }
}
```

Then, it is simple to create a Terraform file that uses Terramate variables. For example:

```hcl
resource "terraform_data" "example" {
    input = global.input_value
}
```

The file will not used directly. When `terramate generate` is executed, another file will be created. Still, this is done only on the current stack.

## Disable Code Generation Inheritance

Another way to achieve the same result, and perhaps in a more Terramate-native way, is to disable inheritance. The downside to this approach is that it seems to go against some of the basic design of Terramate, or its intended use. Why then the nested Stacks is explained the way it is, your guess is as good as mine.

When writing a code generation block, simply set `inherit` to `false`, like the example below.

```hcl
generate_hcl "_bar.tf" {
    content {
        resource "terraform_data" "example" {
            input = "example"
        }
    }
}
```

After executing `terramate generate`, the following output is shown:

```
Code generation report

Successes:

- /stacks/level_one
        [+] _terraform_data.tf

Hint: '+', '~' and '-' mean the file was created, changed and deleted, respectively.
```

Which is exactly the intended result.

## Links

- [Best Practices](https://terramate.io/docs/cli/code-generation/#best-practices)
- [What are nested Stacks?](https://terramate.io/docs/cli/stacks/nesting#what-are-nested-stacks)
- [Ad-hoc HCL Code Generation](https://terramate.io/docs/cli/code-generation/tmgen)
