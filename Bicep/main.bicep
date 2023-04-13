@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the Service Bus namespace.')
param serviceBusNamespaceName string = 'gsorservicebusdemo'

@description('Name of SKU for Service Bus.')
param serviceBusSkuName string = 'Basic'

@description('Name of Queues.')
param serviceBusQueueNames array = [
  'FromFunction'
  'FromConsole'
]

var deadLetterFirehoseQueueName = 'deadletterfirehose'

@minLength(3)
@description('Name of the Storage Account')
param storageAccountName string = 'gsorservicebusdemo'

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'

@description('The name of App Service Plan')
param appServicePlanName string = 'gsorservicebusdemo'

@description('The SKU of App Service Plan')
param sku string = 'B1'

@description('The name of function app')
param functionAppName string = 'gsorservicebusfunctions'

@description('Required runtime stack of function app in the format of \'runtime|runtimeVersion\'')
param functionLinuxFxVersion string = 'DOTNET|6.0'

@minLength(2)
@description('The name of web app')
param webAppName string = 'gsorservicebusdemo'

@description('Required runtime stack of web app in the format of \'runtime|runtimeVersion\'')
param webLinuxFxVersion string = 'DOTNETCORE|7.0'

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: serviceBusSkuName
  }
}

resource deadLetterFirehoseQueue 'Microsoft.ServiceBus/namespaces/queues@2018-01-01-preview' = {
  name: deadLetterFirehoseQueueName
  parent: serviceBusNamespace
  properties: {
    requiresDuplicateDetection: false
    requiresSession: false
    enablePartitioning: false
  }
}

resource queues 'Microsoft.ServiceBus/namespaces/queues@2018-01-01-preview' = [for queueName in serviceBusQueueNames: {
  parent: serviceBusNamespace
  name: queueName
  dependsOn: [
    deadLetterFirehoseQueue
  ]
  properties: {
    forwardDeadLetteredMessagesTo: deadLetterFirehoseQueueName
    lockDuration: 'PT1M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P10D'
    deadLetteringOnMessageExpiration: true
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    enablePartitioning: false
    enableExpress: false
    enableBatchedOperations: true
    status: 'Active'
  }
}]

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
var serviceBusConnectionString = listKeys('${serviceBusNamespace.id}/AuthorizationRules/RootManageSharedAccessKey', serviceBusNamespace.apiVersion).primaryConnectionString

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    reserved: true
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: functionLinuxFxVersion
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: storageAccountConnectionString
        }
        {
          name: 'ServiceBusConnection'
          value: serviceBusConnectionString
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: webLinuxFxVersion
      ftpsState: 'FtpsOnly'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: storageAccountConnectionString
        }
        {
          name: 'ServiceBusConnection'
          value: serviceBusConnectionString
        }
      ]
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}
