@description('Name of Static Web App')
param staticWebAppName string = 'gsorservicebusdemo'

resource staticWebApp 'Microsoft.Web/staticSites@2022-09-01' existing = {
  name: staticWebAppName
}

resource staticWebAppDNS 'Microsoft.Web/staticSites/customDomains@2022-09-01' = {
  name: 'www.orsclab.com'
  parent: staticWebApp
  properties: {
    validationMethod: 'cname-delegation'
  }
}
