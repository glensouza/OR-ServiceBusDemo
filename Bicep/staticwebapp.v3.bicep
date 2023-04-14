@allowed([ 'centralus', 'eastus2', 'eastasia', 'westeurope', 'westus2' ])
param location string = 'centralus'

@description('Name of Static Web App')
param staticWebAppName string = 'peopledemo99'

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

resource resManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: 'peopledemo-script-cloudflaredns-managed-identity'
  location: location
}

output defaultHostname string = staticWebApp.properties.defaultHostname
