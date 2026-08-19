param location string
param vnetName string = 'vnet-vm-test'

resource nsg 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: 'nsg-vm-subnet'
  location: location
  properties: {
    securityRules: [
      // Ingen åpen porter, krever innlogging via bastion og entra id
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2025-07-01' = {
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
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

@description('Subnet id for å knytte til NIC')
output vmSubnetId string = vnet.properties.subnets[0].id
