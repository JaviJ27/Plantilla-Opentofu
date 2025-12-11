########################################
# No crear redes (módulo comentado)
########################################

 module "network" {
   source = "../../terraform/modules/network"
   for_each = local.networks

   name      = each.value.name
   mode      = each.value.mode
   domain    = lookup(each.value, "domain", null)
   addresses = lookup(each.value, "addresses", [])
   bridge    = lookup(each.value, "bridge", null)
   dhcp      = lookup(each.value, "dhcp", false)
   dns       = lookup(each.value, "dns", false)
   autostart = lookup(each.value, "autostart", false)
 }

########################################
# Crear VMs a partir del escenario
########################################

module "server" {
  source   = "../../terraform/modules/vm"
  for_each = local.servers

  name           = each.value.name
  memory         = each.value.memory
  vcpu           = each.value.vcpu
  pool_name      = var.libvirt_pool_name
  pool_path      = var.libvirt_pool_path
  base_image     = each.value.base_image
  disks          = lookup(each.value, "disks", [])
  user_data      = each.value.user_data
  network_config = each.value.network_config

  networks = [
    for idx, net in each.value.networks : {
      network_id = (
        lookup(net, "network_key", null) != null
        ? module.network[net.network_key].id
        : lookup(net, "bridge", null) != null
          ? null                                      # ← si es bridge externo
          : net.network_id                            # ← UUID o nombre de red libvirt
      )

      # Nuevo campo que tu módulo vm debe entender
#      bridge_name    = lookup(net, "bridge", null)
      wait_for_lease = lookup(net, "wait_for_lease", false)
    }
  ]
}
