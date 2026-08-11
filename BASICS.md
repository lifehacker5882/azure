az login --tenant 9f655f1b-8125-4d2e-8cc1-689714d7321e

# see your current/default subscription

az account show

# find the list of subscriptions available to you

az account list --output table

# change your current/default subscription

az account set --subscription <mySubscriptionName>

# you can also set your subscription using a subscription ID

az account set --subscription <00000000-0000-0000-0000-000000000000>

# check if rg is available

az group exists --name <myUniqueRGname>

# Retrieve a list of supported regions for your subscription

az account list-locations --query "[].{Region:name}" --output table

# create resource group

az group create --location <myLocation> --name <myUniqueRGname>

# Create a resource group containing a random ID

let "randomIdentifier=$RANDOM*$RANDOM"
location="eastus"
resourceGroup="msdocs-tutorial-rg-$randomIdentifier"
az group create --name $resourceGroup --location $location --output json

# reuse common parameter values

az config set defaults.group=<msdocs-tutorial-rg-0000000>

# multiple parameters seprated by space

az config set defaults.location=westus2 defaults.group=<msdocs-tutorial-rg-0000000>

# Output determines what appears on your console and what's written to your log file. None when returning keys, passwords and secrets

az config set core.output=none

az config set core.output=json
