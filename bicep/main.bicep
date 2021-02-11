param location string = 'eastus'
param audience string {
  secure: true
}
param tenantId string {
  secure: true
}
param publisherName string
param publisherEmail string
param clientId string {
  secure: true
}
param secret string {
  secure: true
}

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

module logicappA './modules/logicApp/logicappA.bicep' = {
  name: 'logicappA'
  params: {
    location: location
    tenantId: tenantId
    audience: audience
    clientId: clientId
    secret: secret
    uri: '${apim.outputs.url}/${apis.outputs.apiPath}'
  }
}

module logicappC './modules/logicApp/logicappC.bicep' = {
  name: 'logicappC'
  params: {
    location: location
    uri: '${apim.outputs.url}/${apis.outputs.apiPath}'
  }
}