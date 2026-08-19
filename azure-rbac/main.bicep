@description('Plassering for alle ressursers i en resource group')
param location string = resourceGroup().location

@description('Object ID(Entra ID) for brukeren som skal logge inn på VM')
param adminUserObjectId string

// Vnet
module network 'modules/network.bicep' = {
  name: 'deploy-network'
  params: {
    location: location
  }
}

module vm 'modules/vm.bicep' = {
  name: 'deploy-vm'
  params: {
    location: location
    subnedId: network.outputs.vmSubnetId
  }
}

module keyVault 'modules/keyvault.bicep' = {
  name: 'deploy-keyvault'
  params: {
    location: location
  }
}

@description('Gir managed identiy lese-tilgang til keyvalt secrets som Key Vault Secret user')
module vmToKvRbac 'modules/rbac.bicep' = {
  name: 'rbac-vm-to-keyvault'
  params: {
    principalId: vm.outputs.systemIdentityPrincipalId
    roleDefinitionId: '4633458b-17de-408a-b874-0445c86b69e6'
    principalType: 'ServicePrincipal'
  }
}

@description('Gir entra id-bruker rettighet til å logge inn på vm via ssh som Virtual Machine Administrator')
module userToVmRbac 'modules/rbac.bicep' = {
  name: 'rbac-user-to-vm'
  params: {
    principalId: adminUserObjectId
    roleDefinitionId: '1c0163c0-47e6-4577-8991-ea5c82e286e4'
    principalType: 'User'
  }
}
