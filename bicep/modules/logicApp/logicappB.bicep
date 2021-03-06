param location string
param addressRange string
param tenantId string {
  secure: true
}
param audience string {
  secure: true
}

resource workflowb 'Microsoft.Logic/workflows@2017-07-01' = {
   name: 'logicApp-workflow-b'
   location: location
   properties: {
     state: 'Enabled'
     definition: {     
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
       contentVersion: '1.0.0.0'  
       parameters: {}
       triggers: {
         manual: {
            type: 'Request'
            kind: 'Http'
            inputs: {
              schema: {}
            }
         }
       }
       actions: {
        Response: {
          runAfter: {}
          type: 'Response'
          kind: 'Http'
          inputs: {
            body: {
              message: 'Hello from Logic App B'
            }
            statusCode: 200
          }
        }
       }       
       outputs: {}
     }
     accessControl: {
       triggers: {
         allowedCallerIpAddresses:[
           {
            addressRange: '${addressRange}/32'           
           }           
         ]
         openAuthenticationPolicies: {
           policies: {
             Default: {        
               type: 'AAD'       
               claims: [
                 {
                   name: 'iss'
                   value: 'https://login.microsoftonline.com/${tenantId}/v2.0'
                 }
                 {
                   name: 'aud'
                   value: audience
                 }
               ]
             }
           }
         }         
       }
       actions: {
         allowedCallerIpAddresses: [
           {
             addressRange: '${addressRange}/32'
           }
         ]
       }
     }
   }
}

output endpoint string = '${workflowb.properties.accessEndpoint}/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0'