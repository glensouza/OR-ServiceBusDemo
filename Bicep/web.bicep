@description('Location for resource.')
param location string = resourceGroup().location

@description('The name of the storage account')
param storageAccountName string

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

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
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

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
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
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
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

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: webLinuxFxVersion
      ftpsState: 'FtpsOnly'
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}
