@allowed([ 'centralus', 'eastus2', 'eastasia', 'westeurope', 'westus2' ])
param location string = 'centralus'

@description('Name of Static Web App')
param staticWebAppName string = 'peopledemo97'

@allowed([ 'Free', 'Standard' ])
param sku string = 'Free'

resource staticWebApp 'Microsoft.Web/staticSites@2022-09-01' = {
  name: staticWebAppName
  location: location
  sku: {
      name: sku
      size: sku
  }
  properties: {}
}

output defaultHostname string = staticWebApp.properties.defaultHostname
