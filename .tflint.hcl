config {
  module = true
  force = false
  disabled_by_default = true
}

plugin "azurerm" {
    enabled = true
    version = "0.25.1"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = false
}

rule "terraform_documented_variables" {
  enabled = false
}

# rule "terraform_module_version" {
#   enabled = false
#   exact = false # default
# }

# rule "terraform_required_providers" {
#   enabled = false
# }

# rule "terraform_required_version" {
#   enabled = false
# }

# Ensure that a module complies with the Terraform Standard Module Structure
rule "terraform_standard_module_structure" {
  enabled = true
}

# Disallow variable declarations without type.
rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

# # terraform.workspace should not be used with a "remote" backend with remote execution.
# rule "terraform_workspace_remote" {
#   enabled = true
# }

# Enforces naming conventions
# rule "terraform_naming_convention" {
#   enabled = true

#   #Require specific naming structure
#   # variable {
#   # format = "snake_case"
#   # }

#   # locals {
#   # format = "snake_case"
#   # }

#   # output {
#   # format = "snake_case"
#   # }

#   #Allow any format
#   resource {
#   format = "none"
#   }

#   module {
#   format = "none"
#   }

#   data {
#   format = "none"
#   }
# }



