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

# finn object id til signed in user

az ad signed-in-user show --query id -o tsv

# delpoy template

az deployment group create \
 --resource-group rg-portfolio-dev \
 --template-file main.bicep \
 --parameters main.bicepparam

# set subscrition for å sette riktig scope

az account set --subscription "Azure subscription 1"

##########################################################################################

# Hindrer at Git Bash omskriver Azure resource paths som starter med /subscriptions/... (kan ellers gi "MissingSubscription"-feil)

export MSYS_NO_PATHCONV=1

# Subscription-IDen du vil jobbe mot. Dette er feks VM Iden

SUB_ID="33324481-a6a0-4945-b6a8-42040d9cb923"

# Setter aktiv subscription for alle neste az-kommandoer

az account set --subscription "$SUB_ID"

# Henter Object ID (Entra ID) for brukeren som er logget inn i az cli

# tr -d '\r' fjerner Windows carriage return for å unngå "skjulte" tegn i variabelen

USER_ID=$(az ad signed-in-user show --query id -o tsv | tr -d '\r')

# Henter full resource ID for VM-en (scope vi vil sjekke RBAC på)

VM_ID=$(az vm show -g rbac-test -n vm-portfolio-linux --query id -o tsv | tr -d '\r')

# Skriver ut verdiene så du ser hva scriptet faktisk bruker

echo "USER_ID=$USER_ID"
echo "VM_ID=$VM_ID"

# Lister rolle-tildelinger for brukeren på VM-scope

# Tips: legg til --include-inherited for å se roller arvet fra resource group/subscription

az role assignment list --assignee "$USER_ID" --scope "$VM_ID" --output table

# OUTPUT eksempel

USER_ID=db1d2756-ca8f-4832-bc14-7640888ce847
VM_ID=/subscriptions/33324481-a6a0-4945-b6a8-42040d9cb923/resourceGroups/rbac-test/providers/Microsoft.Compute/virtualMachines/vm-portfolio-linux

# kjør denne for å sjekke role assignment inkludert inherited.

az role assignment list \
 --assignee "$USER_ID" \
 --scope "$VM_ID" \
 --include-inherited \
 --output table
