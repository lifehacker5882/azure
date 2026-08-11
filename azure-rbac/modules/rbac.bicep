@description('Principal ID til brukeren, gruppen eller Managed Identity som skal få rollen')
param principalId string

@description('ID for rolledefinisjonen i Azure (f.eks. Key Vault Secrets User eller VM Admin Login)')
param roleDefinitionId string

@description('Type principal (User, Group, ServicePrincipal, Identity)')
param principalType string = 'User'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, roleDefinitionId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalId
    principalType: principalType
  }
}
