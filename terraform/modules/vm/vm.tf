resource "azurerm_network_interface" "test" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                            = "${var.prefix}-vm"
  location                        = var.location
  resource_group_name             = var.resource_group
  size                            = "Standard_B1s"
  admin_username                  = "adminAzure"
  network_interface_ids = [azurerm_network_interface.test.id]
  admin_ssh_key {
    username   = "adminAzure"
    public_key = "file(ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCneknhBK2Ts61bnVGok3POTPDhaGqrgVsnPJWe4wx5ChfwsgM7zHVyXDmX1oilcXzZVsGlShpTCX/RJ2bDDC6dqvSVAwMx9skmKN4dDReJAMiO/kEJHO1XmJyZou4G4ok5cfh5f44Ie+lmwZO/Cl5ZjwIrEIQLlL+TlpCeAmk9s9oYwrf/RtJ1Y1+NXcVbkmiggfVkB4ZiH4/OuIPhTtDIJxQCLfJNYHfUmRT0QklHye/RYndOfSLJrnYcecZPgAVnar1AOCOcGF/iif3WAEXns2ArF4cQ1dIBf4tqIjxKKBN1UAGrrAhBLsZMxOYZP0wI9b/upTqO3F7GLkZOUtBH vera@cc-b6dea5c2-9957f6b66-td58k)"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}