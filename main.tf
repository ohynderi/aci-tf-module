#
# Variable
#
variable "aci_model" {
    type = any
}


#
# Local
#
locals {
    tenants = try(var.aci_model.tenants, [])
    fabric = try(var.aci_model.fabric, [])
}

#
# Main
#
module "fabric" {
    count = length(local.fabric) > 0 ? 1 : 0
    source = "./fabric"
    fabric_cfg = local.fabric
}



#
# Outputs
#
output "tenants" {
    value = local.tenants
}

output "fabric" {
    value = local.fabric
}