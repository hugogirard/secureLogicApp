param publisherName string
param publisherEmail string

var suffix = uniqueString(resourceGroup().id)
var apimName = concat('apim-',suffix)
var location = resourceGroup().location

resource apim 'Microsoft.ApiManagement/service@2019-12-01' = {
    name: apimName
    location: location
    properties: {
        publisherEmail: publisherEmail
        publisherName: publisherName
    }
    sku: {
        name: 'Developer'
        capacity: 1
    }
}


output publicIp string = apim.properties.publicIPAddresses[0]
output apiName string = apim.name
output url string = apim.properties.gatewayUrl