@description('Plassering for ressursene')
param location string

@description('Navn på Key Vault (må være unikt i hele Azure)')
param keyVaultName string = 'kv-${uniqueString(resourceGroup().id)}'

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    // Aktiverer ren RBAC-basert tilgangsstyring
    enableRbacAuthorization: true
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
  }
}

@description('Resource ID for Key Vault')
output keyVaultId string = keyVault.id

@description('Navn på Key Vault')
output keyVaultName string = keyVault.name
