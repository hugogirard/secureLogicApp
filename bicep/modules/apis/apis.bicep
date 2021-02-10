param apimName string
param apiUrl string

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

output apiPath string = logicBApi.properties.path