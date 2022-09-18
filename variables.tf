
variable "rg_name" {
  description = "name of resource group"
  type        = string
  default = "my-RG"
}

variable "rg_location" {
  description = "location of resource group"
  type        = string
  default = "Central India"
}

variable "rg_tag" {
  description = "tag of Resource group"
  type        = map(any)
  default = { "key" = "value" }
}

variable "pub_ip_allc_method" {
  description = "allocation method of public IP"
  type        = string
  default = "Dynamic"
}

variable "nsg_rules" {
  description = "values for each nsg rule"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [{

  name                       = "ssh"
  priority                   = "110"
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  },
  {
    name                       = "http"
    priority                   = "120"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "https"
    priority                   = "130"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

}]
}

variable "vnet_addr" {
  description = "address space of virtual network"
  type        = list(any)
  default = ["10.0.0.0/16"]
}

variable "sunbnet_addr" {
  description = "address prefix of subnet"
  type        = list(any)
  default = ["10.0.2.0/24"]
}

variable "nic_pri_ip_addr_alloc" {
  description = "private ip address allocation configuration of network interface"
  type        = string
  default = "Dynamic"
}

variable "vm_count" {
  description = "count of virtual machine"
  type        = number
  default = 2
}

variable "vm_size" {
  description = "size of virtual machine"
  type        = string
  default = "Standard_B1s"
}

variable "os_disk_deletion_on_termination" {
  description = "should the os disk be deleted when vm is terminated?"
  type        = bool
  default = true
}

variable "data_disks_deletion_on_termination" {
  description = "should the data be deleted when vm is terminated?"
  type        = bool
  default = true
}

variable "vm_img_publisher" {
  description = "publisher of the image used to create the virtual machine"
  type        = string
  default = "Canonical"
}

variable "vm_img_offer" {
  description = "offer of the image used to create the virtual machine"
  type        = string
  default = "UbuntuServer"
}

variable "vm_img_sku" {
  description = "sku of the image used to create the virtual machine"
  type        = string
  default = "16.04-LTS"
}

variable "vm_img_version" {
  description = "version of the image used to create the virtual machine"
  type        = string
  default = "latest"
}

variable "vm_storage_os_disk_caching" {
  description = "caching requirements for the os disk"
  type        = string
  default = "ReadWrite"
}

variable "vm_create_option" {
  description = "specifies how the os disk should be created"
  type        = string
  default = "FromImage"
}

variable "vm_managed_disk_type" {
  description = "specifies the type of managed disk to create"
  type        = string
  default = "Standard_LRS"
}

variable "vm_os_profile_admin_username" {
  description = "specifies the name of the local administrator account."
  type        = string
  sensitive   = true
  default = "don"
}

variable "vm_os_profile_admin_pass" {
  description = "specifies the password associated with the local administrator account"
  type        = string
  sensitive   = true
  default = "Don@08071999"
}

variable "vm_disable_pass_auth" {
  description = "specifies whether password authentication should be disabled"
  type        = string
  default = false
}

variable "vm_connnection_type" {
  description = "connectioln type for vm configuration"
  type        = string
  default = "ssh"
}

variable "vm_remote_exec_inline" {
  description = "specifies commands for vm configuration"
  type        = list(any)
  default = ["echo 'Tom is a good boy' > /tmp/file.txt", "sed -i 's/Tom/Don/gi' /tmp/file.txt"]
}
