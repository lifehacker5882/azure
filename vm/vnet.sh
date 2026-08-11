# create Bash shell variables
vnetName=myVnet
subnetName=mySubnet
vnetAddressPrefix=10.0.0.0/16
subnetAddressPrefix=10.0.0.0/24

# Use the existing resource group (i.e demo)
resourceGroup=demo

az network vnet create --name $vnetName --resource-group $resourceGroup --address-prefixes $vnetAddressPrefix --subnet-name $subnetName --subnet-prefixes $subnetAddressPrefix

# verify connection by ssh
ssh <PUBLIC_IP_ADDRESS>

# retrieve vm information with queries
az vm show --name $vmName --resource-group $resourceGroup

# get the object id (the query)
az vm show --name $vmName --resource-group $resourceGroup --query 'networkProfile.networkInterfaces[].id' --output tsv

# assign the nic object id to a shell variable
nicId=$(az vm show \
    -n $vmName \
    -g $resourceGroup \
    --query 'networkProfile.networkInterfaces[].id' \
    -o tsv)

# get the nics info
az network nic show --ids $nicId
az network nic show --ids $nicId --query '{IP:ipConfigurations[].publicIPAddress.id, Subnet:ipConfigurations[].subnet.id}' -o json

# hvis bash problemer
MSYS_NO_PATHCONV=1 
# eller
export MSYS_NO_PATHCONV=1

az network nic show --ids "$nicId"