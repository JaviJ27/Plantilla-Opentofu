##############################################
# escenario.tf — Definición del escenario
##############################################

locals {

##############################################
# Redes a crear
##############################################

  networks = {
#    nat-dhcp = {
#      name      = "nat-dhcp"
#      mode      = "nat"
#      domain    = "example.com"
#      addresses = ["192.168.100.0/24"]
#      bridge    = "virbr10"
#      dhcp      = true
#      dns       = true
#      autostart = true
#    }
#
#    muy-aislada = {
#      name      = "muy-aislada"
#      mode      = "none"          # totalmente aislada
#      bridge    = "virbr20"
#      autostart = true
#    }
  }

##############################################
# Máquinas virtuales a crear
##############################################

#Configuración de maquinas

#Maquina1
  servers = {
    Deb13plantilla = {
      name       = "Deb13plantilla"
      memory     = 1024
      vcpu       = 2
      base_image = "debian13-base.qcow2"

	#Configuración de red

    networks = [
      # Red creada por libvirt, en este caso default (Se especifica el id de la red) 
      { network_id  = "6fe3e1c6-c042-49ad-9a68-6ef51f7a283d", wait_for_lease = true },
      # Red creada por opentofu
      #{ network_key = "nat-dhcp", wait_for_lease = true },      
      #{ network_key = "muy-aislada" },      
      # Red puente externa, crea una red puente, pero no le asocia el puente indicado, hay que modificarlo tras la instalación
      #{ bridge      = "br0" },
    ]

	#Disco extra

      #disks = [
      #  { name = "data", size = 5 * 1024 * 1024 * 1024 }
      #]

	#Directorio del cloud init

      user_data      = "${path.module}/cloud-init/Deb13plantilla/user-data.yaml"
      network_config = "${path.module}/cloud-init/Deb13plantilla/network-config.yaml"
    }

#Maquina 2
#    Deb13plantilla = {
#      name       = "Deb13plantilla"
#      memory     = 1024
#      vcpu       = 2
#      base_image = "debian13-base.qcow2"

	#Configuración de red

#    networks = [
      # Red creada por libvirt, en este caso default (Se especifica el id de la red) 
#      { network_id  = "6fe3e1c6-c042-49ad-9a68-6ef51f7a283d", wait_for_lease = true },
      # Red creada por opentofu
      #{ network_key = "nat-dhcp", wait_for_lease = true },      
      #{ network_key = "muy-aislada" },      
      # Red puente externa, crea una red puente, pero no le asocia el puente indicado, hay que modificarlo tras la instalación
      #{ bridge      = "br0" },
#    ]

	#Disco extra

      #disks = [
      #  { name = "data", size = 5 * 1024 * 1024 * 1024 }
      #]

	#Directorio del cloud init

#      user_data      = "${path.module}/cloud-init/Deb13plantilla/user-data.yaml"
#      network_config = "${path.module}/cloud-init/Deb13plantilla/network-config.yaml"
#    }
  }
}
