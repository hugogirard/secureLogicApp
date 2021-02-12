- [About this sample](#about-this-sample)
- [How to install the application](#how-to-install-this-sample)
  - [Step 1: Fork this repository](#fork-this-repository)
  - [Step 2: Register applications in Azure AD](#register-apps-ad)
    - [Create application in Azure AD](#create-app-ad)

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

Once the application is created click the **App role | Preview** button.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/createrole.png?raw=true' />

Enter the information below for the role

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/allowTrigger.png?raw=true' />

Now you need to expose the Application so other Apps can call it using app roles.  We use **client credentials flow** in this example, for more information about this flow click [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/msal-authentication-flows#client-credentials).

Now click in the left menu the Expose an API button.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/expose.png?raw=true' />

Click at the top the **Set** hyperlink.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/setapp.png?raw=true' />

Last step is to update the manifest file of the application to use the v2 of the Azure AD endpoint.  Click on the manifest button to the left menu and change the value to 2.

<img src='https://github.com/hugogirard/secureLogicApp/blob/main/images/manifest.png?raw=true' />

If you want to learn more about Azure Active Directory from a developer perspective Microsoft have good documentation [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/).

Now you need to create two more applications in Azure AD 


```xml
<policies>
    <inbound>
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
            <openid-config url="https://login.microsoftonline.com/{{tenantId}}/v2.0/.well-known/openid-configuration" />
            <audiences>
                <audience>{{appId logic app Azure AD}}</audience>
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