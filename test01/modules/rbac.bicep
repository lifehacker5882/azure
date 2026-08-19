@description('Principal ID til brukeren eller Managed Identity som skal tildeles rollen')
param principalId string

@description('Rolledefinisjonens GUID i Azure')
param roleDefinitionId string

@description('Type principal (User, Group, ServicePrincipal)')
param principalType string = 'User'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  // Genererer et unikt GUID basert på ressursscope, principal og rolle
  name: guid(resourceGroup().id, principalId, roleDefinitionId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalId
    principalType: principalType
  }
}
