@description('Plassering for alle ressursene')
param location string = resourceGroup().location

@description('Object ID (Entra ID) for brukeren som skal få tilgang til å logge inn på VM')
param adminUserObjectId string

// 1. Nettverk
module network 'modules/network.bicep' = {
  name: 'deploy-network'
  params: {
    location: location
  }
}

// 2. Virtual Machine (venter på Subnet ID fra nettverket)
module vm 'modules/vm.bicep' = {
  name: 'deploy-vm'
  params: {
    location: location
    subnetId: network.outputs.vmSubnetId
  }
}

// 3. Key Vault
module keyVault 'modules/keyvault.bicep' = {
  name: 'deploy-keyvault'
  params: {
    location: location
  }
}

// 4. RBAC: Gi VM sin Managed Identity lese-tilgang til Key Vault Secrets
// Rollenavn: Key Vault Secrets User
module vmToKvRbac 'modules/rbac.bicep' = {
  name: 'rbac-vm-to-keyvault'
  params: {
    principalId: vm.outputs.systemIdentityPrincipalId
    roleDefinitionId: '4633458b-17de-408a-b874-0445c86b69e6'
    principalType: 'ServicePrincipal'
  }
}

// 5. RBAC: Gi din Entra ID-bruker rettighet til å logge inn på VM via SSH
// Rollenavn: Virtual Machine Administrator Login
module userToVmRbac 'modules/rbac.bicep' = {
  name: 'rbac-user-to-vm'
  params: {
    principalId: adminUserObjectId
    roleDefinitionId: '1c0163c0-47e6-4577-8991-ea5c82e286e4'
    principalType: 'User'
  }
}
