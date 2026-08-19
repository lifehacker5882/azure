param location string
param subnedId string
param vmName string = 'vm-rbac-test'

param adminUsername string = 'azureuser'

resource nic 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnedId
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2026-03-01' = {
  name: vmName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2als_v7'
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: 'P@assword${uniqueString(resourceGroup().id)}'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

resource entraIdExtension 'Microsoft.Compute/virtualMachines/extensions@2026-03-01' = {
  parent: vm
  name: 'AADSSHLoginForLinux'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: 'AADSSHLoginForLinux'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}

@description('Principal id for vmen sin managed identity')
output systemIdentityPrincipalId string = vm.identity.principalId

@description('Resource id for vmen')
output vmId string = vm.id
