param apimName string
param apiUrl string
param tenantId string
param audience string

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

// resource policyApi 'Microsoft.ApiManagement/service/apis/policies@2020-06-01-preview' = {
//   name: '${apimName}/logicappb/policy'
//   dependsOn: [
//     logicBApi
//     postOperation
//   ]
//   properties: {
//     value: policy
//     format: 'xml'
//   }
// }

output apiPath string = logicBApi.properties.path