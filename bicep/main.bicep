param location string = 'eastus'
param audience string {
  secure: true
}
param tenantId string {
  secure: true
}
param publisherName string
param publisherEmail string


module apim './modules/apim/apim.bicep' = {
  name: 'apim'
  params: {
    publisherName: publisherName
    publisherEmail: publisherEmail
  }
}

module logicappB './modules/logicApp/logicappB.bicep' = {
  name: 'logicappB'
  params: {
    location: location
    addressRange: apim.outputs.publicIp
    audience: audience
    tenantId: tenantId
  }
}

module apis './modules/apis/apis.bicep' = {
  name: 'apis'
  params: {
    apimName: apim.outputs.apiName
    apiUrl: logicappB.outputs.endpoint
  }
}