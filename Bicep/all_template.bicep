param sites_gsorservicebus_name string = 'gsorservicebus'
param sites_gsorservicebusdemo_name string = 'gsorservicebusdemo'
param serverfarms_gsorservicebus_name string = 'gsorservicebus'
param namespaces_gsorservicebusdemo_name string = 'gsorservicebusdemo'
param storageAccounts_gsorservicebusdemo_name string = 'gsorservicebusdemo'

resource namespaces_gsorservicebusdemo_name_resource 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: namespaces_gsorservicebusdemo_name
  location: 'Central US'
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    premiumMessagingPartitions: 0
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    zoneRedundant: false
  }
}

resource storageAccounts_gsorservicebusdemo_name_resource 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccounts_gsorservicebusdemo_name
  location: 'centralus'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource serverfarms_gsorservicebus_name_resource 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: serverfarms_gsorservicebus_name
  location: 'Central US'
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    freeOfferExpirationTime: '2023-05-12T16:32:18.15'
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource namespaces_gsorservicebusdemo_name_RootManageSharedAccessKey 'Microsoft.ServiceBus/namespaces/authorizationrules@2022-10-01-preview' = {
  parent: namespaces_gsorservicebusdemo_name_resource
  name: 'RootManageSharedAccessKey'
  location: 'centralus'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
}

resource namespaces_gsorservicebusdemo_name_default 'Microsoft.ServiceBus/namespaces/networkRuleSets@2022-10-01-preview' = {
  parent: namespaces_gsorservicebusdemo_name_resource
  name: 'default'
  location: 'Central US'
  properties: {
    publicNetworkAccess: 'Enabled'
    defaultAction: 'Allow'
    virtualNetworkRules: []
    ipRules: []
  }
}

resource namespaces_gsorservicebusdemo_name_deadletterfirehose 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
  parent: namespaces_gsorservicebusdemo_name_resource
  name: 'deadletterfirehose'
  location: 'centralus'
  properties: {
    maxMessageSizeInKilobytes: 256
    lockDuration: 'PT1M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P14D'
    deadLetteringOnMessageExpiration: false
    enableBatchedOperations: true
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    status: 'Active'
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
  }
}

resource namespaces_gsorservicebusdemo_name_fromconsole 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
  parent: namespaces_gsorservicebusdemo_name_resource
  name: 'fromconsole'
  location: 'centralus'
  properties: {
    maxMessageSizeInKilobytes: 256
    lockDuration: 'PT1M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P10D'
    deadLetteringOnMessageExpiration: true
    enableBatchedOperations: true
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    status: 'Active'
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
    forwardDeadLetteredMessagesTo: 'deadletterfirehose'
  }
}

resource namespaces_gsorservicebusdemo_name_fromfunction 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
  parent: namespaces_gsorservicebusdemo_name_resource
  name: 'fromfunction'
  location: 'centralus'
  properties: {
    maxMessageSizeInKilobytes: 256
    lockDuration: 'PT1M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P10D'
    deadLetteringOnMessageExpiration: true
    enableBatchedOperations: true
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    status: 'Active'
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
    forwardDeadLetteredMessagesTo: 'deadletterfirehose'
  }
}

resource storageAccounts_gsorservicebusdemo_name_default 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  parent: storageAccounts_gsorservicebusdemo_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_gsorservicebusdemo_name_default 'Microsoft.Storage/storageAccounts/fileServices@2022-09-01' = {
  parent: storageAccounts_gsorservicebusdemo_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_gsorservicebusdemo_name_default 'Microsoft.Storage/storageAccounts/queueServices@2022-09-01' = {
  parent: storageAccounts_gsorservicebusdemo_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_gsorservicebusdemo_name_default 'Microsoft.Storage/storageAccounts/tableServices@2022-09-01' = {
  parent: storageAccounts_gsorservicebusdemo_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource sites_gsorservicebus_name_resource 'Microsoft.Web/sites@2022-09-01' = {
  name: sites_gsorservicebus_name
  location: 'Central US'
  kind: 'functionapp,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_gsorservicebus_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_gsorservicebus_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_gsorservicebus_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'DOTNET|6.0'
      acrUseManagedIdentityCreds: false
      alwaysOn: true
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '7D3D825747C79DF9C9261AAD7870C2254CD5B49B2DA3EFAD6C98BE36B69873C1'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_gsorservicebusdemo_name_resource 'Microsoft.Web/sites@2022-09-01' = {
  name: sites_gsorservicebusdemo_name
  location: 'Central US'
  kind: 'app,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_gsorservicebusdemo_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_gsorservicebusdemo_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_gsorservicebus_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'DOTNETCORE|7.0'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '7D3D825747C79DF9C9261AAD7870C2254CD5B49B2DA3EFAD6C98BE36B69873C1'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_gsorservicebus_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: sites_gsorservicebus_name_resource
  name: 'ftp'
  location: 'Central US'
  properties: {
    allow: true
  }
}

resource sites_gsorservicebusdemo_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: sites_gsorservicebusdemo_name_resource
  name: 'ftp'
  location: 'Central US'
  properties: {
    allow: true
  }
}

resource sites_gsorservicebus_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: sites_gsorservicebus_name_resource
  name: 'scm'
  location: 'Central US'
  properties: {
    allow: true
  }
}

resource sites_gsorservicebusdemo_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: sites_gsorservicebusdemo_name_resource
  name: 'scm'
  location: 'Central US'
  properties: {
    allow: true
  }
}

resource sites_gsorservicebus_name_web 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: sites_gsorservicebus_name_resource
  name: 'web'
  location: 'Central US'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'DOTNET|6.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$gsorservicebus'
    scmType: 'GitHubAction'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: true
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: true
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    publicNetworkAccess: 'Enabled'
    cors: {
      allowedOrigins: [
        'https://portal.azure.com'
      ]
      supportCredentials: false
    }
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_gsorservicebusdemo_name_web 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: sites_gsorservicebusdemo_name_resource
  name: 'web'
  location: 'Central US'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'DOTNETCORE|7.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$gsorservicebusdemo'
    scmType: 'GitHubAction'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    publicNetworkAccess: 'Enabled'
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_gsorservicebus_name_sites_gsorservicebus_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = {
  parent: sites_gsorservicebus_name_resource
  name: '${sites_gsorservicebus_name}.azurewebsites.net'
  location: 'Central US'
  properties: {
    siteName: 'gsorservicebus'
    hostNameType: 'Verified'
  }
}

resource sites_gsorservicebusdemo_name_sites_gsorservicebusdemo_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = {
  parent: sites_gsorservicebusdemo_name_resource
  name: '${sites_gsorservicebusdemo_name}.azurewebsites.net'
  location: 'Central US'
  properties: {
    siteName: 'gsorservicebusdemo'
    hostNameType: 'Verified'
  }
}

resource storageAccounts_gsorservicebusdemo_name_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: storageAccounts_gsorservicebusdemo_name_default
  name: 'azure-webjobs-hosts'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_gsorservicebusdemo_name_resource
  ]
}

resource storageAccounts_gsorservicebusdemo_name_default_azure_webjobs_secrets 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: storageAccounts_gsorservicebusdemo_name_default
  name: 'azure-webjobs-secrets'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_gsorservicebusdemo_name_resource
  ]
}