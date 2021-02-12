- [About this sample](#about-this-sample)
- [How to install the application](#how-to-install-this-sample)
  - [Step 1: Fork this repository](#fork-this-repository)
  - [Step 2: Register applications in Azure AD](#register-application-in-azure-ad)
    - [1 - Create application in Azure AD](#create-app-ad)
    - [2 - Create application role](#create-app-role)
    - [3 - Expose application](#expose-application)
    - [4 - Update Manifest file](#update-manifest-file)
    - [5 - Create application Logic App A](#create-logic-app-a)
   - [Step 3: Create Github Secrets](#create-github-secrets)
   - [Step 4: Run the Github Action](#run-the-github-action)
   - [Step 5: Add APIM Policy](#add-apim-policy)

# About this sample

This sample show a way to secure your Logic App with Azure Active Directory and exposed using Azure Api Management.  Another logic app will call the protected logic retrieving a JWT token from Azure AD.

An Azure policy will validate the JWT token inside APIM to be sure the audience is valid.

The protected logic app have an IP restriction that accept HTTP call only from the public IP of Api Management.

To have more security you could host APIM inside a Virtual Network.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/diagram/whatItDoes.png?raw=true' />

# How to install this sample

## Fork this repository

The first step is to fork this repository in your github account

## Register application in Azure AD

You will need to registers three applications in Azure Active Directory that represent the 3 logics app in this sample.

### Create App Ad
Go to your Azure Active Directory and in **App Registrations blade**.  From there click the button **+ New registration** and enter the information below.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/createApp.png?raw=true' />

### Create App Role
Once the application is created click the **App role | Preview** button.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/createrole.png?raw=true' />

Enter the information below for the role

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/allowTrigger.png?raw=true' />

### Expose Application

Now you need to expose the Application so other Apps can call it using app roles.  We use **client credentials flow** in this example, for more information about this flow click [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-authentication-flows#client-credentials).

Now click in the left menu the Expose an API button.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/expose.png?raw=true' />

Click at the top the **Set** hyperlink.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/setapp.png?raw=true' />

### Update Manifest file
Last step is to update the manifest file of the application to use the v2 of the Azure AD endpoint.  Click on the manifest button to the left menu and change the value to 2.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/manifest.png?raw=true' />

If you want to learn more about Azure Active Directory from a developer perspective Microsoft have good documentation [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/).

Now you need to create one more application in Azure AD 

### Create logic app a

You need to create the application **Logic-App-Workflow-A**, repeat the step **Create App Ad** with the name **Logic-App-Workflow-A**.

Once is done you need to click in the menu Api Permission.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/API Permission.png?raw=true' />

Click the button Add a permission

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/add permission.png?raw=true' />

Select **My APIS** and select Logic-App-Workflow-B

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/myapis.png?raw=true' />

Select the app role created before

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/addApp.png?raw=true' />

The last step is to grant admin consent for the added permission by clicking the grant admin consent.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/grant.png?raw=true' />

Now you need to create a client secret, just click the **Certificates & secrets** in the left menu.

Click the **New client secret** button and copy the value, you will need it later.

Last step is to update the **manifest** file like you did before for this application too.

## Create Github Secrets

Now to be able to run the github action that will create all the Azure Resources you will need to create [Github Secrets](https://docs.github.com/en/actions/reference/encrypted-secrets).

|Secret|Value|
|--|--|
|AUDIENCE| ClientID of the Logic-App-Workflow-B in Azure AD
|CLIENT_ID| ClientID of the Logic-App-Workflow-A in Azure AD
|PUBLISHER_EMAIL| Your email to receive notification when APIM will be created
|PUBLISHER_NAME| Your name
|SECRET| Client Secret created from application Logic-App-Workflow-A
|SP_AZURE_CREDENTIALS| Follow this link https://github.com/Azure/login to know which value to enter
|SUBSCRIPTION_ID| The subscription Id where you want to deploy the resources
|TENANT_ID| The Azure TenantId where you want to deploy the resources.

## Run the Github Action

Now click the Github action button at the top

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/action.png?raw=true' />

Click the deploy infra button

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/deploy.png?raw=true' />

Finally click on the run workflow button, this will take ~45 minutes.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/runWorkflow.png?raw=true' />

## Add APIM Policy

Now you will need to add this APIM Policy on the Logic-App API created in APIM.

The policy need to go to the only operation present there.  Replace the value with your tenantId and appId of the logic app b registered in Azure AD.

To understand more about Azure APIM Policy click (here)[https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-policies].

```xml
<policies>
    <inbound>
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
            <openid-config url="https://login.microsoftonline.com/{{tenantId}}/v2.0/.well-known/openid-configuration" />
            <audiences>
                <audience>{{appId logic app B Azure AD}}</audience>
            </audiences>
        </validate-jwt>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
```