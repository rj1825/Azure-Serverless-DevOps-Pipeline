resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'store${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}

resource hostingPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'func-plan'
  location: resourceGroup().location
  sku: { name: 'Y1', tier: 'Dynamic' }
}

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: 'fn-app-${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  kind: 'functionapp'
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      appSettings: [
        { name: 'AzureWebJobsStorage', value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}' }
        { name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING', value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}' }
      ]
    }
  }
}
