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

resource policyApi 'Microsoft.ApiManagement/service/apis/policies@2020-06-01-preview' = {
  name: '${apimName}/logicappb/policy'
  dependsOn: [
    logicBApi
    postOperation
  ]
  properties: {
    value: '<policies>\r\n  <inbound>\r\n    <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">\r\n      <openid-config url="https://login.microsoftonline.com/${tenantId}/v2.0/.well-known/openid-configuration" />\r\n      <audiences>\r\n        <audience>${audience}</audience>\r\n      </audiences>\r\n    </validate-jwt>\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
    format: 'xml'
  }
}

output apiPath string = logicBApi.properties.path