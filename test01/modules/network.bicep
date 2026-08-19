@description('Plassering for ressursene')
param location string

@description('Navn på Virtual Network')
param vnetName string = 'vnet-portfolio-dev'

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-vm-subnet'
  location: location
  properties: {
    securityRules: [
      // Ingen åpne porter mot internett er påkrevd siden vi bruker Bastion og Entra ID
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-workload'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
      {
        // Påkrevd navn for Azure Bastion Subnet
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

@description('Resource ID for arbeidsbelastnings-subnettet')
output vmSubnetId string = vnet.properties.subnets[0].id
