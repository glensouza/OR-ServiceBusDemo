@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the Service Bus namespace.')
param serviceBusNamespaceName string = 'gsorservicebusdemo'

@minLength(3)
@description('Name of the Storage Account')
param storageAccountName string = 'gsorservicebusdemo'

module serviceBus './servicebus.bicep' = {
  name: 'ServiceBus'
  params: {
    location: location
    serviceBusName: serviceBusNamespaceName
  }
}

module storageAcccount './storage.bicep' = {
  name: 'StorageAccount'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

module web './web.bicep' = {
  name: 'Web'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}
