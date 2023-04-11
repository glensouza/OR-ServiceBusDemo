@description('Location for all resources.')
param location string = resourceGroup().location

param serviceBusNamespaceName string = 'gsorservicebusdemo'

@minLength(3)
param storageAccountName string = 'gsorservicebusdemo'

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
