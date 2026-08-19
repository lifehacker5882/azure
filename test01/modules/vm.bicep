@description('Plassering for ressursene')
param location string

@description('Subnet ID hvor VM skal plasseres')
param subnetId string

@description('Navn på den virtuelle maskinen')
param vmName string = 'vm-portfolio-linux'

@description('Admin brukernavn for lokal beredskapskonto')
param adminUsername string = 'azureuser'

resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vmName
  location: location
  // Aktiverer System-Assigned Managed Identity
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
      // Genererer et tilfeldig passord for lokal konto (Entra ID brukes til daglig innlogging)
      adminPassword: 'P@ssw0rd${uniqueString(resourceGroup().id)}!'
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

// VM-utvidelse som muliggjør Entra ID (Azure AD) SSH-innlogging
resource entraIdExtension 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = {
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

@description('Principal ID for VM sin Managed Identity')
output systemIdentityPrincipalId string = vm.identity.principalId

@description('Resource ID for selve VM-en')
output vmId string = vm.id
