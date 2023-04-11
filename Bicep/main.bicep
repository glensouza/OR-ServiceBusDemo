@description('Location for all resources.')
param location string = resourceGroup().location

param serviceBusNamespaceName string = 'gsorservicebusdemo${uniqueString(resourceGroup().id)}'

@minLength(3)
param storageAccountName string = 'gsorstorage${uniqueString(resourceGroup().id)}'

module serviceBus './servicebus.bicep' = {
  name: 'ServiceBus'
  params: {
    serviceBusName: serviceBusNamespaceName
    location: location
  }
}

module storageAcccount './storage.bicep' = {
  name: 'StorageAccount'
  params: {
    storageAccountName: storageAccountName
    location: location
  }
}
