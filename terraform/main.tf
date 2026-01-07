resource "azurerm_resource_group" "rg" {
	name = "rg-terraform-lab"
	location = var.location
}


resource "azurerm_virtual_network" "vnet" {
name = "vnet-terraform-lab" 
address_space = ["10.0.0.0/16"]  
location = var.location 
resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_subnet" "subnet" {

name = "subnet-terraform-lab"
resource_group_name = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.vnet.name
address_prefixes =["10.0.1.0/24"]

}

resource "azurerm_network_security_group" "nsg" {
name = "nsg-terraform-lab"
location = var.location
resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}



resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


