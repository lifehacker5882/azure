vmName=vm01
vmSize=Standard_D2als_v7

az vm create \
  --resource-group $resourceGroup \
  --name $vmName \
  --image Ubuntu2204 \
  --size $vmSize \
  --vnet-name $vnetName \
  --subnet $subnetName \
  --generate-ssh-keys \
  --output json \
  --verbose 