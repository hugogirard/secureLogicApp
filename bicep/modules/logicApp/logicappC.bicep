param location string
param uri string

resource workflowb 'Microsoft.Logic/workflows@2017-07-01' = {
   name: 'logicApp-workflow-c'
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
        HTTP: {
          runAfter: {}
          type: 'Http'          
          inputs: {
            method: 'POST'
            uri: uri
          }
        }
       }       
       outputs: {}
     }
   }
}