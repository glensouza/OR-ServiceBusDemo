@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the Service Bus namespace.')
param serviceBusNamespaceName string = 'gsorservicebusdemo'

@minLength(3)
@description('Name of the Storage Account')
param storageAccountName string = 'gsorservicebusdemo'

@description('The name of App Service Plan')
param appServicePlanName string = 'gsorservicebusdemo'

@description('The name of function app')
param functionAppName string = 'gsorservicebusfunctions'

@minLength(2)
@description('The name of web app')
param webAppName string = 'gsorservicebusdemo'

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
    appServicePlanName: appServicePlanName
    functionAppName: functionAppName
    webAppName: webAppName
  }
}
