param location string
@description('Navn på Key vault id (brukes for rbac)')
param keyVaultName string = 'kv-${uniqueString(resourceGroup().id)}'

resource keyVault 'Microsoft.KeyVault/vaults@2026-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'B'
      name: 'standard'
    }
    enableRbacAuthorization: true
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
  }
}

@description('Resource ID for key vault')
output keyVaultId string = keyVault.id

@description('Navn på keyvault')
output keyVaultName string = keyVault.name
