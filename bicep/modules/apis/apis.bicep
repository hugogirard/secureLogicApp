param apimName string
param apiUrl string
param tenantId string
param audience string

var policy = '<policies><inbound><validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validationerrormessage="Unauthorized. Access token is missing or invalid."><openid-config url="https://login.microsoftonline.com/${tenantId}/v2.0/.well-known/openid-configuration" /><audiences><audience>${audience}</audience></audiences></validate-jwt></inbound><backend><base /></backend><outbound><base /></outbound><on-error><base /></on-error></policies>'

resource logicBApi 'Microsoft.ApiManagement/service/apis@2019-12-01' = {
  name: '${apimName}/logicappb'
  properties: {
    displayName: 'Workflow for logic app B'
    description: 'Workflow for logic app B'
    subscriptionRequired: false
    serviceUrl: apiUrl
    path: 'logicapp'
    protocols: [
      'https'
    ]
  }
}

resource postOperation 'Microsoft.ApiManagement/service/apis/operations@2017-03-01' = {
  name: '${logicBApi.name}/callLogicApp'
  properties: {
    displayName: 'Calling logic app'
    method: 'POST'
    urlTemplate: '/'
    description: 'Call the logic app'
  }
}

resource policyApi 'Microsoft.ApiManagement/service/apis/policies@2020-06-01-preview' = {
  name: '${apimName}/logicappb/policy'
  dependsOn: [
    logicBApi
    postOperation
  ]
  properties: {
    value: policy
    format: 'xml'
  }
}

output apiPath string = logicBApi.properties.path