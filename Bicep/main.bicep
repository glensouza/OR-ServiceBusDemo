@description('Location for all resources.')
param location string = resourceGroup().location

param serviceBusNamespaceName string = 'gsorservicebusdemo${uniqueString(resourceGroup().id)}'

module serviceBus './servicebus.bicep'= {
  name: 'ServiceBus'
  params: {
    serviceBusName: serviceBusNamespaceName
    location: location
  }
}
