
locals {
  humber_id = "5126"
  location  = "Canada Central"
  vm_names = {
    vm1 = "vm1"
    vm2 = "vm2"
    vm3 = "vm3"
  }
  public_key         = ""
  private_key        = ""
  admin_username     = "n01685126"
  win_admin_username = "adminuser"
  win_password       = ""
  tags = {
    Assignment     = "CCGC 5502 Automation Assignment"
    Name           = "tania.jose"
    ExpirationDate = "2024-12-31"
    Environment    = "Learning"
  }
}

module "rgroup" {
  source    = "./modules/rgroup-n01685126"
  humber_id = local.humber_id
  location  = local.location
  tags      = local.tags
}

module "network" {
  source              = "./modules/network-n01685126"
  humber_id           = local.humber_id
  location            = local.location
  resource_group_name = module.rgroup.resource_group_name
  tags                = local.tags
}

module "common" {
  source              = "./modules/common-n01685126"
  humber_id           = local.humber_id
  location            = local.location
  resource_group_name = module.rgroup.resource_group_name
  tags                = local.tags
}

module "vmlinux" {
  source              = "./modules/vmlinux-n01685126"
  humber_id           = local.humber_id
  location            = local.location
  resource_group_name = module.rgroup.resource_group_name
  subnet_id           = module.network.subnet_id
  storage_account_uri = module.common.storage_account_uri
  vm_names            = local.vm_names
  admin_username      = local.admin_username
  public_key          = local.public_key
  private_key         = local.private_key
  tags                = local.tags
}

module "vmwindows" {
  source              = "./modules/vmwindows-n01685126"
  humber_id           = local.humber_id
  location            = local.location
  resource_group_name = module.rgroup.resource_group_name
  subnet_id           = module.network.subnet_id
  storage_account_uri = module.common.storage_account_uri
  admin_username      = local.win_admin_username
  admin_password      = local.win_password
  tags                = local.tags
  windows_vm_count    = 1
}

module "datadisk" {
  source              = "./modules/datadisk-n01685126"
  humber_id           = local.humber_id
  location            = local.location
  resource_group_name = module.rgroup.resource_group_name
  linux_vm_ids        = module.vmlinux.linux_vm_ids
  windows_vm_ids      = module.vmwindows.windows_vm_id
  windows_vm_count    = 1
  tags                = local.tags
}

module "loadbalancer" {
  source              = "./modules/loadbalancer-n01685126"
  humber_id           = local.humber_id
  location            = local.location
  resource_group_name = module.rgroup.resource_group_name
  linux_vm_nic_ids    = module.vmlinux.linux_vm_nic_ids
  tags                = local.tags
}

module "database" {
  source              = "./modules/database-n01685126"
  humber_id           = local.humber_id
  location            = local.location
  resource_group_name = module.rgroup.resource_group_name
  admin_username      = "adminuser"
  admin_password      = ""
  tags                = local.tags
}
