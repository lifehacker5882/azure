@description('IDen som skal tildeles rollen')
param principalId string

@description('Rolledefinisjon i Azure')
param roleDefinitionId string

@description('Type princial (User, Group, ServicePrincipal)')
param principalType string = 'User'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, roleDefinitionId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principalId
    principalType: principalType
  }
}
