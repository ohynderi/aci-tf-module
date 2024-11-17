#
# Variables
#
variable "node_policy_cfg" {
    type = any
}

#
# Locals
#
locals {
    vpc_domain = { for group in try(var.node_policy_cfg.vpc_groups, []) : group.id => group }
}






#
# Outputs
#