resource "azurerm_resource_group" "resource_group" {
  name     = var.rg_name
  location = var.rg_location
  tags     = var.rg_tag
}

resource "azurerm_public_ip" "public_ip" {
  count               = var.vm_count
  name                = "public-ip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  allocation_method   = var.pub_ip_allc_method
  tags                = azurerm_resource_group.resource_group.tags

}

resource "azurerm_network_security_group" "security_group" {

  name                = "${azurerm_resource_group.resource_group.name}-SecurityGroup"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value["name"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      priority                   = security_rule.value["priority"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix      = security_rule.value["source_address_prefix"]
      destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
  }
  tags = azurerm_resource_group.resource_group.tags
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${azurerm_resource_group.resource_group.name}-VirtualNetwork"
  address_space       = var.vnet_addr
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${azurerm_resource_group.resource_group.name}-Subnet1"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.sunbnet_addr
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}

resource "azurerm_network_interface" "network_interface" {
  count               = var.vm_count
  name                = "${azurerm_resource_group.resource_group.name}-NIC${count.index + 1}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "nic-ip-config1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.nic_pri_ip_addr_alloc
    public_ip_address_id          = element(azurerm_public_ip.public_ip.*.id, count.index)
  }
}

resource "azurerm_virtual_machine" "my_vm" {
  count                            = var.vm_count
  name                             = "vm-${count.index + 1}"
  location                         = azurerm_resource_group.resource_group.location
  resource_group_name              = azurerm_resource_group.resource_group.name
  vm_size                          = var.vm_size
  network_interface_ids            = ["${element(azurerm_network_interface.network_interface.*.id, count.index)}"]
  delete_os_disk_on_termination    = var.os_disk_deletion_on_termination
  delete_data_disks_on_termination = var.data_disks_deletion_on_termination

  storage_image_reference {
    publisher = var.vm_img_publisher
    offer     = var.vm_img_offer
    sku       = var.vm_img_sku
    version   = var.vm_img_version
  }
  storage_os_disk {
    name              = "vm-${count.index + 1}-OS-Disk"
    caching           = var.vm_storage_os_disk_caching
    create_option     = var.vm_create_option
    managed_disk_type = var.vm_managed_disk_type
  }
  os_profile {
    computer_name  = "host${count.index + 1}"
    admin_username = var.vm_os_profile_admin_username
    admin_password = var.vm_os_profile_admin_pass
  }
  os_profile_linux_config {
    disable_password_authentication = var.vm_disable_pass_auth
  }
  tags = azurerm_resource_group.resource_group.tags
}

data "azurerm_public_ip" "public_ip" {
  depends_on          = [azurerm_virtual_machine.my_vm]
  count               = var.vm_count
  name                = element(azurerm_public_ip.public_ip.*.name, count.index)
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "null_resource" "configuration" {
  count = var.vm_count
  connection {
    type     = var.vm_connnection_type
    host     = element(data.azurerm_public_ip.public_ip.*.ip_address, count.index)
    user     = var.vm_os_profile_admin_username
    password = var.vm_os_profile_admin_pass
  }
  provisioner "remote-exec" {
    inline = var.vm_remote_exec_inline
  }
}


