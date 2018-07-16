---
layout: post
title: "Developing Mobile Apps with Xamarin Forms and Azure Functions"
description: "Learn how to use Xamarin Forms and Microsoft Azure Functions to develop mobile apps that are supported by serverless functions."
date: 2018-07-19 08:30
category: Technical Guide, Mobile, Xamarin Forms
author:
  name: "Daniel Krzyczkowski"
  url: "https://twitter.com/dkrzyczkowski"
  mail: "daniel.krzyczkowski@hotmail.com"
  avatar: "https://cdn.auth0.com/blog/guest-authors/daniel-krzyczkowski.png"
design:
  bg_color: "#333333"
  image: https://cdn.auth0.com/blog/xamarin/xamarin.png
tags:
- xamarin-forms
- azure-functions
- serverless
- mobile
- azure
- auth0
- hybrid
related:
- 2017-03-10-using-serverless-azure-functions-with-auth0-and-google-apis
- 2016-03-28-xamarin-authentication-and-cross-platform-app-development
- 2018-07-12-building-an-audio-player-app-with-ionic-angular-rxjs-and-ngrx
---

**TL;DR:** The Microsoft Azure Functions is a solution which enables developers running small serverless pieces of code (functions in the cloud) without worrying about a whole application or the infrastructure to run it. They can be used as a backend for web or mobile applications. In this article, we will present how to access an Azure Function secured by Auth0 from a Xamarin Forms application.

---

## Introducing Microsoft Azure Cloud Platform

Microsoft Azure is a platform which provides components to quickly create, implement, and manage cloud solutions. It offers wide range of application, computing, warehouse, network services, and supports all three models of cloud services: 

* [Infrastructure as a Service (IaaS)](https://azure.microsoft.com/en-us/overview/what-is-iaas);
* [Platform as a Service (PaaS)](https://azure.microsoft.com/en-us/overview/what-is-paas);
* and [Software as a Service (SaaS)](https://azure.microsoft.com/en-us/overview/what-is-saas).

Microsoft Azure is available through a [web portal](https://portal.azure.com/) where all mentioned components can be created and configured. In this article, we will use Azure Functions: a PaaS solution that enables developers running small pieces of code without bothering about whole application or the infrastructure to run it.

Creating an Azure account is free of charge but you have to provide some credit card information. There will be no charge, except for a temporary authorisation hold. Microsoft offers $200 credit for start to explore services for 30 days.

If you decide not to upgrade at the end of 30 days or once you've used up your $200 credit, any products you’ve deployed will be decommissioned and you won’t be able to access them. You will not be charged and you can always upgrade your subscription.

## Using Azure Functions as a Serverless Backend
There are many cases where Azure Functions can be used like systems integration, data processing or building simple APIs and microservices. The Microsoft Azure cloud platform provides different initial templates for Azure Functions. Below there are some examples of them:
* [HTTPTrigger](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook) - Triggers the execution of Function code by using an HTTP request
* [TimerTrigger](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-timer) - Executes cleanup or other batch tasks on a predefined schedule
* [QueueTrigger](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-storage-queue) - Respond to messages as they arrive in an Azure Storage queue

In this article we will use HTTPTrigger template to create Azure Function. It will be secured by Auth0 so before accessing it authentication will be required. Users will authenticate in Xamarin Forms application conntected to this Function.

## Creating Azure Functions
You can create the Azure Function in the [Azure portal](https://portal.azure.com/). Follow below steps to create new Azure Function with HTTPTrigger template:

1. Click "Create a resource" button in the left top corner
2. Type "Function app" in the search window
3. Select "Function app" from the list
4. Click "Create" button

In this step, you have to provide few details:

* App name - name of the function app, can be "auth0functionapp" (in my case it was "auth0securedfunction") - name has to be unique.
* Subscription - your active Microsfot Azure subscription selcted
* Resource group - group where function app will be located, here select "Create new" and type "function-app-rg"
* OS - host operating system where function code will be executed, here select "Windows"
* Hosting plan - should be set as "Consumption Plan" so you pay only for the number of executions
* Location - it is good to create app in your region so find your region on the list
* Storage - some functionality connected with function apps requires storage, select "Create new" and leave the name as it is

Once you fill all required, information click "Create" button.

After short time the Function App should be created and notification shows up. Select "Function App" from the left bar. Blade with created function app should appear. Expand it and move mouse cursor on the "Functions" header and click "+" button. 

![Add new function app](https://github.com/Daniel-Krzyczkowski/guest-writer/blob/master/articles/images/auth0_4.png)

New blade with templates will be displayed. Choose "HTTPTrigger C#" template, fill name field with "Auth0FunctionApp" value and change authorization level to "Anonymous". After few seconds HTTPTrigger function is ready for the further implementation.

### Scaffolding the Project
Default template needs some adjustments. Nuget packages are supported by the Function Apps. For an authentication process we will use **Microsoft.IdentityModel.Protocols.OpenIdConnect** NuGet package. Open "View files" tab on the right and click "Add" button. You have to create new json file which will contain information about required NuGet packages. Type "project.json" as the file name and click "Enter". Once file is created you have to define its structure so paste below code and click "Save" button:


```C#
{
  "frameworks": {
    "net46":{
      "dependencies": {
        "Microsoft.IdentityModel.Protocols.OpenIdConnect": "5.2.2"
      }
    }
   }
}
```
Once NuGet package is installed proper information is displayed in the Logs console.

### Signing Up to Auth0
An Auth0 account is available for free. To sign up go to [Auth0 website](https://auth0.com/) and click "Sing Up" button on the top. You can either sign up with standard way using e-mail and password or with identity provider like Microsoft or Github. Once you sign in dashboard is available.

### Creating an Auth0 API
An Authentication API exposes Auth0 identity functionality, as well as those of supported identity protocols (such as OpenID Connect, OAuth, and SAML). The Auth0 API application can be created in the dashboard. Open "APIs" tab from the left and click "CREATE API" button. In the dialog you have to provide name of the new API, identifier and select signing alghoritm (in this case RS256) should be selected. Click "Create" button and after few seconds you should see your API in the dashboard:

![Created API in the dashboard](https://github.com/Daniel-Krzyczkowski/guest-writer/blob/master/articles/images/auth0_5.PNG)

Click its name and open "Quick Start" tab and copy "audience" and "issuer" from the sample source code presented. You will use these values in the Azure Function source code to validate tokens.

### Developing the Azure Function
Access to the Function App will be secured with the Auth0. User has to authenticate in the Xamarin Forms application and then send request with authorization token to the function. Here OpenID Connect is used to verify user identity and once its confirmed response with greeting is returned.
Open "run.csx" file from the "View files" tab. This is the place where function source code should be placed. Lets discuss it.

Below AuthenticationService class source code is presented which instance is used to get access token from Auth0:

```C#
public static class AuthenticationService
{
        private static readonly IConfigurationManager<OpenIdConnectConfiguration> _configurationManager;

        private static readonly string ISSUER = ""; //From Auth0 portal, ex: https://devisland.eu.auth0.com/
        private static readonly string AUDIENCE = ""; // From Auth0 portal, ex: devisland

        static AuthenticationService()
        {
            var documentRetriever = new HttpDocumentRetriever { RequireHttps = ISSUER.StartsWith("https://") };

            _configurationManager = new ConfigurationManager<OpenIdConnectConfiguration>(
                $"{ISSUER}.well-known/openid-configuration",
                new OpenIdConnectConfigurationRetriever(),
                documentRetriever
            );
        }

        public static async Task<ClaimsPrincipal> ValidateTokenAsync(string bearerToken, TraceWriter log)
        {
            ClaimsPrincipal validationResult = null;
            short retry = 0;
            while(retry <=0 && validationResult == null)
            {
                try
                {
                var openIdConfig = await _configurationManager.GetConfigurationAsync(CancellationToken.None);

                    TokenValidationParameters validationParameters =
                        new TokenValidationParameters
                        {
                            ValidIssuer = ISSUER,
                            ValidAudiences = new[] { AUDIENCE },
                            IssuerSigningKeys = openIdConfig.SigningKeys
                        };

                    SecurityToken validatedToken;
                    JwtSecurityTokenHandler handler = new JwtSecurityTokenHandler();
                    validationResult = handler.ValidateToken(bearerToken, validationParameters, out validatedToken);
                    
                    
                    log.Info($"Token is validated. User Id {validationResult.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value}");

                    return validationResult;
                }
                catch (SecurityTokenSignatureKeyNotFoundException)
                {
                    log.Info("SecurityTokenSignatureKeyNotFoundException exception thrown. Refreshing configuration...");
                    _configurationManager.RequestRefresh();
                    retry ++;
                }
                catch (SecurityTokenException)
                {
                    log.Info("SecurityTokenException exception throwns. One more attempt...");
                     return null;    
                }
            }
            return validationResult;
        }  
}
```
Lets describe above code functionality. First of all Issuer and audience values have to be filled. You can obtain them in the Auth0 dashboard:

```C#
private static readonly string ISSUER = ""; //From Auth0 portal, ex: https://devisland.eu.auth0.com/
private static readonly string AUDIENCE = ""; // From Auth0 portal, ex: devisland
```
To verify token send to the function you have to use the ConfigurationManager class which uses OpenId configuration retrieved from the Auth0. ConfigurationManager instance is created in the constructor:


```C#
static AuthenticationService()
        {
            var documentRetriever = new HttpDocumentRetriever { RequireHttps = ISSUER.StartsWith("https://") };

            _configurationManager = new ConfigurationManager<OpenIdConnectConfiguration>(
                $"{ISSUER}.well-known/openid-configuration",
                new OpenIdConnectConfigurationRetriever(),
                documentRetriever
            );
        }
```
ValidateTokenAsync method is responsible for token verification. Validation is done through the "JwtSecurityTokenHandler" instance using OpenId configuration retrieved from the Auth0. Please note that catch clausule is used to handle the "SecurityTokenSignatureKeyNotFoundException" exception. It is required to refresh token when the issuer changed its signing keys:


```C#
        public static async Task<ClaimsPrincipal> ValidateTokenAsync(string bearerToken, TraceWriter log)
        {
            ClaimsPrincipal validationResult = null;
            short retry = 0;
            while(retry <=0 && validationResult == null)
            {
                try
                {
                var openIdConfig = await _configurationManager.GetConfigurationAsync(CancellationToken.None);

                    TokenValidationParameters validationParameters =
                        new TokenValidationParameters
                        {
                            ValidIssuer = ISSUER,
                            ValidAudiences = new[] { AUDIENCE },
                            IssuerSigningKeys = openIdConfig.SigningKeys
                        };

                    SecurityToken validatedToken;
                    JwtSecurityTokenHandler handler = new JwtSecurityTokenHandler();
                    validationResult = handler.ValidateToken(bearerToken, validationParameters, out validatedToken);
                    
                    
                    log.Info($"Token is validated. User Id {validationResult.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value}");

                    return validationResult;
                }
                catch (SecurityTokenSignatureKeyNotFoundException)
                {
                    log.Info("SecurityTokenSignatureKeyNotFoundException exception occurred. Refreshing configuration...");
                    _configurationManager.RequestRefresh();
                    retry ++;
                }
                catch (SecurityTokenException)
                {
                    log.Info("SecurityTokenException exception occurred. One more attepmt...");
                     return null;    
                }
            }
            return validationResult;
        } 
```
Every Function App has the "Run" method which is exectued once function is called - in our case this is the HTTP request:

```C#
public static async Task<HttpResponseMessage> Run(HttpRequestMessage req, TraceWriter log)
{
    log.Info("C# HTTP trigger function processed a request.");

     var authorizationHeader  =  req.Headers.GetValues("Authorization").FirstOrDefault();
     log.Info("Validating token: " + authorizationHeader);

     if (authorizationHeader != null && authorizationHeader.StartsWith("Bearer"))
    {
        string bearerToken = authorizationHeader.Substring("Bearer ".Length).Trim();
        log.Info("Got token: " + bearerToken);
            ClaimsPrincipal principal;
            if ((principal = await AuthenticationService.ValidateTokenAsync(bearerToken, log)) == null)
            {
                log.Info("The authorization token is not valid.");
                return req.CreateResponse(HttpStatusCode.Unauthorized, "The authorization token is not valid.");
            }
    }
    else 
    {
        return req.CreateResponse(HttpStatusCode.Unauthorized, "The authorization header is either empty or isn't Bearer.");
    }


    string name = req.GetQueryNameValuePairs()
        .FirstOrDefault(q => string.Compare(q.Key, "name", true) == 0)
        .Value;

    if (name == null)
    {
        dynamic data = await req.Content.ReadAsAsync<object>();
        name = data?.name;
    }

    return name == null
        ? req.CreateResponse(HttpStatusCode.BadRequest, "Please pass a name on the query string or in the request body")
        : req.CreateResponse(HttpStatusCode.OK, "Hello " + name + "!" +" Greetings from Azure Function secured with Auth0");
}
```
Lets describe above code functionality. Firstly bearer token is retrieved from the HTTP request header. If its empty function returns 401 unauthorized HTTP status. When token is attached to the request the AuthenticationService instance verifies if token is valid:

```C#
 var authorizationHeader  =  req.Headers.GetValues("Authorization").FirstOrDefault();
     log.Info("Validating token: " + authorizationHeader);

     if (authorizationHeader != null && authorizationHeader.StartsWith("Bearer"))
    {
        string bearerToken = authorizationHeader.Substring("Bearer ".Length).Trim();
        log.Info("Got token: " + bearerToken);
            ClaimsPrincipal principal;
            if ((principal = await AuthenticationService.ValidateTokenAsync(bearerToken, log)) == null)
            {
                log.Info("The authorization token is not valid.");
                return req.CreateResponse(HttpStatusCode.Unauthorized, "The authorization token is not valid.");
            }
    }
    else 
    {
        return req.CreateResponse(HttpStatusCode.Unauthorized, "The authorization header is either empty or isn't Bearer.");
    }
```
Please note that we are using logger here to display information in the Logs console.
Once token is verified and valid function code retrieves name parameter from the query string. If its not empty greeting text string is created and returned with HTTP status 200:


```C#
string name = req.GetQueryNameValuePairs()
        .FirstOrDefault(q => string.Compare(q.Key, "name", true) == 0)
        .Value;

    if (name == null)
    {
        dynamic data = await req.Content.ReadAsAsync<object>();
        name = data?.name;
    }

    return name == null
        ? req.CreateResponse(HttpStatusCode.BadRequest, "Please pass a name on the query string or in the request body")
        : req.CreateResponse(HttpStatusCode.OK, "Hello " + name + "!" +" Greetings from Azure Function secured with Auth0");
```
The Function app is available under specific URL address. You can find it once cliced "Get function URL" button on the top. It should look like the one presented below:

[https://auth0securedfunction.azurewebsites.net/api/Auth0FunctionApp](https://auth0securedfunction.azurewebsites.net/api/Auth0FunctionApp)

You will use this URL in the Xamarin Forms application so copy it for the further usage.

## Creating Xamarin Forms
Xamarin platform provides possibility to create cross-platform mobile applications with .NET C#. In this case we decided to use [Xamarin Forms](https://docs.microsoft.com/en-us/xamarin/xamarin-forms) approach to create iOS, Android and Universal Windows Platform applications. Open Visual Studio 2017 and create new Xamarin Forms application project:

> Remember to select Mobile development with .NET during Visual Studio 2017 installation so you can access Xamarin cross-platform project templates.

![Xamarin Forms project template](https://github.com/Daniel-Krzyczkowski/guest-writer/blob/master/articles/images/auth0_8.png)

After a while Xamarin Forms application solution is ready. Please note that there are four projects:
* iOS application project
* Android application project
* UWP application project
* Core project

First three project contains specific platform code and Core project where common logic should be placed to share.

### Bootstrapping the Xamarin Forms Project
Once Xamarin Forms application project is ready you need to install below NuGet packages:

* [**Auth0.OidcClient.Android**](https://www.nuget.org/packages/Auth0.OidcClient.Android/) NuGet package in Android application project
* [**Auth0.OidcClient.iOS**](https://www.nuget.org/packages/Auth0.OidcClient.ios/) NuGet package in iOS application project
* [**Auth0.OidcClient.UWP**](https://www.nuget.org/packages/Auth0.OidcClient.UWP) NuGet package in UWP application project
* [**RestSharp**](https://www.nuget.org/packages/RestSharp/) NuGet package in Core project

**Auth0.OidcClient** package provides authentication functionality so users can sign in or sign up in the Xamarin Forms application.

**RestSharp** package is used to provide functionality connected with sending HTTP requests and handling responses from the Azure Function application.

Project structure is ready.

### Creating an Auth0 Application
An Auth0 Application represents your application in Auth0. You first need to define the Application in Auth0 to then be able to add authentication in Xamarin Forms application. You can do it in the Auth0 dashboard. Open "Applications" tab from the left and click "CREATE APPLICATION" button. In the dialog you have to provide name of the new application, and choose application type - in this case "Native". Click "Create" button and after few seconds you should see created application in the dashboard:

![Created Native application in the dashboard](https://github.com/Daniel-Krzyczkowski/guest-writer/blob/master/articles/images/auth0_7.PNG)

Open the "Settings" tab and copy the "Domain" and "Client ID" values. You will use them in the Xamarin Forms application project.

### Developing the Xamarin Forms App
Lets start from adding new falder called "Config" in the Core project. Inside it you will place two static classes:
* AuthenticationConfig - class which contains Auth0 configuration (audience, client ID and domain retrieved from the Auth0 dashboard)
* AzureConfig - class which contains Azure Function App URL

```C#
    public static class AuthenticationConfig
    {
        public const string Domain = ""; // Domain from Auth0 portal
        public const string ClientId = ""; // ClientId from Auth0 portal
        public const string Audience = ""; // Audience from Auth0 portal
    }
```

```C#
    public static class AzureConfig
    {
        public const string AzureFunctionUrl = ""; // Azure Function URL from Azure Portal. ex: https://auth0securedfunctionapp.azurewebsites.net/api/Auth0AzureFunction
    }
```
Now lets add "Model" folder and create the "AuthenticationResult" class inside it. Instance of this class will contain information about authentication result including Id Token, Access Token and Claims:

```C#
    public class AuthenticationResult
    {
        public string IdToken { get; set; }

        public string AccessToken { get; set; }

        public IEnumerable<Claim> UserClaims { get; set; }

        public bool IsError { get; }

        public string Error { get; }


        public AuthenticationResult() { }

        public AuthenticationResult(bool isError, string error)
        {
            IsError = isError;
            Error = error;
        }
    }
```
In the next step, add folder called "Services" and folder "Interfaces" inside it. Inside this folder there will be two interfaces:
* IAuthenticationService - interface with the "Authenticate" method and the "AuthenticationResult" property - this interface will be implemented in each platform project: Android, iOS and UWP
* IAzureFunctionDataService - interface with the "GetGreeting" method which will be implemented to obtain greeting from Azure Function App once user is authenticated

```C#
    public interface IAuthenticationService
    {
        Task<AuthenticationResult> Authenticate();
        AuthenticationResult AuthenticationResult { get; }
    }
```

```C#
    public interface IAzureFunctionDataService
    {
        Task<string> GetGreeting(AuthenticationResult authenticationResult);
    }
```
Now its time to implement simple user interface of the application. Create "Pages" folder in the Core project and then add two content pages: "LoginPage" and "MainPage". To achieve this right click on the folder, select "Add" then "New item" and select "Content Page".

Here is the source code for the "LoginPage.xaml" file. There is image on the top, label below with text "Welcome to Xamarin.Forms with Auth0!" and login button below:

```C#
<?xml version="1.0" encoding="utf-8" ?>
<ContentPage xmlns="http://xamarin.com/schemas/2014/forms"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             x:Class="Auth0XamarinForms.Core.Pages.LoginPage">
    <ContentPage.Content>
        <StackLayout HorizontalOptions="Center">
            <Image x:Name="LogoImage" Margin="0,20,0,0"/>
            <Label x:Name="MainPageLabel" Text="Welcome to Xamarin.Forms with Auth0!" HorizontalOptions="Center" VerticalOptions="Center" Margin="0,10,0,0" />
            <Button Text="Login" Clicked="Login_Clicked" Margin="0,10,0,0"/>
        </StackLayout>
    </ContentPage.Content>
</ContentPage>
```
Here is the source code for the "MainPage.xaml" file. Once user authenticate profile picture and greetings from Azure Function App is displayed:

```C#
<?xml version="1.0" encoding="utf-8" ?>
<ContentPage xmlns="http://xamarin.com/schemas/2014/forms"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             xmlns:local="clr-namespace:Auth0XamarinForms"
             x:Class="Auth0XamarinForms.Pages.MainPage">

    <StackLayout HorizontalOptions="Center">
        <Image x:Name="UserImage" Margin="0,20,0,0" HeightRequest="240" WidthRequest="240"/>
        <Label x:Name="GreetingLabel" HorizontalOptions="Center" VerticalOptions="CenterAndExpand" FontAttributes="Bold" />
    </StackLayout>

</ContentPage>
```
Now as mentioned earlier in the article "IAuthenticationService" interface has to be implemented in each platfrom project - iOS, Android and Universal Windows Platform.

**Android application project**

Inside "Services" folder create new class called "AuthenticationService". This class will be responsible for handling authentication on Android platform. Please note that dependency injection is used to regiseter "IAuthenticationService" implementation.

Dedicated class provided by Auth0 called "Auth0Client" handles authentication so you are using its instance here in the "Authenticate" method. If authentication reult is success you have Id Token, Access Token and User Claims:

```C#
[assembly: Dependency(typeof(AuthenticationService))]
namespace Auth0XamarinForms.Droid.Services
{
    public class AuthenticationService : IAuthenticationService
    {
        private Auth0Client _auth0Client;

        public AuthenticationService()
        {
            _auth0Client = new Auth0Client(new Auth0ClientOptions
            {
                Domain = AuthenticationConfig.Domain,
                ClientId = AuthenticationConfig.ClientId
            });
        }

        public AuthenticationResult AuthenticationResult { get; private set; }

        public async Task<AuthenticationResult> Authenticate()
        {
            var auth0LoginResult = await _auth0Client.LoginAsync(new { audience = AuthenticationConfig.Audience });
            AuthenticationResult authenticationResult;

            if (!auth0LoginResult.IsError)
            {
                authenticationResult = new AuthenticationResult()
                {
                    AccessToken = auth0LoginResult.AccessToken,
                    IdToken = auth0LoginResult.IdentityToken,
                    UserClaims = auth0LoginResult.User.Claims
                };
            }
            else
                authenticationResult = new AuthenticationResult(auth0LoginResult.IsError, auth0LoginResult.Error);

            AuthenticationResult = authenticationResult;
            return authenticationResult;
        }
    }
```

Now in "MainActivity" class you have to add IntentFilter so the application nows when Auth0 authentication dialog is closed once user authenticated:

```C#
    [Activity(Label = "Auth0XamarinForms", Icon = "@mipmap/icon", Theme = "@style/MainTheme", MainLauncher = true, ConfigurationChanges = ConfigChanges.ScreenSize | ConfigChanges.Orientation)]
    [IntentFilter(
    new[] { Intent.ActionView },
    Categories = new[] { Intent.CategoryDefault, Intent.CategoryBrowsable },
    DataScheme = "", // App package name, ex: com.devisland.Auth0XamarinForms
    DataHost = "", // Auth0 domain, ex: devisland.eu.auth0.com
    DataPathPrefix = "/android/YOUR_ANDROID_PACKAGE_NAME/callback")]
    public class MainActivity : global::Xamarin.Forms.Platform.Android.FormsAppCompatActivity
    {
        protected override void OnCreate(Bundle bundle)
        {
            TabLayoutResource = Resource.Layout.Tabbar;
            ToolbarResource = Resource.Layout.Toolbar;

            base.OnCreate(bundle);

            global::Xamarin.Forms.Forms.Init(this, bundle);
            LoadApplication(new App());
        }

        protected override void OnNewIntent(Intent intent)
        {
            base.OnNewIntent(intent);

            Auth0.OidcClient.ActivityMediator.Instance.Send(intent.DataString);
        }
    }
```

Android application project is ready.

**iOS application project**

Inside "Services" folder create new class called "AuthenticationService". This class will be responsible for handling authentication on Android platform. Please note that dependency injection is used to regiseter "IAuthenticationService" implementation.
This class looks exactly the same as in Android project but different NuGet package is used - "Auth0.OidcClient.iOS":

```C#
[assembly: Dependency(typeof(AuthenticationService))]
namespace Auth0XamarinForms.iOS.Services
{
    public class AuthenticationService : IAuthenticationService
    {
        private Auth0Client _auth0Client;

        public AuthenticationService()
        {
            _auth0Client = new Auth0Client(new Auth0ClientOptions
            {
                Domain = AuthenticationConfig.Domain,
                ClientId = AuthenticationConfig.ClientId
            });
        }

        public AuthenticationResult AuthenticationResult { get; private set; }

        public async Task<AuthenticationResult> Authenticate()
        {
            var auth0LoginResult = await _auth0Client.LoginAsync(new { audience = AuthenticationConfig.Audience });
            AuthenticationResult authenticationResult;

            if (!auth0LoginResult.IsError)
            {
                authenticationResult = new AuthenticationResult()
                {
                    AccessToken = auth0LoginResult.AccessToken,
                    IdToken = auth0LoginResult.IdentityToken,
                    UserClaims = auth0LoginResult.User.Claims
                };
            }
            else
                authenticationResult = new AuthenticationResult(auth0LoginResult.IsError, auth0LoginResult.Error);

            AuthenticationResult = authenticationResult;
            return authenticationResult;
        }
    }
```
Now in "AppDelegate" class you have to override "OpenUrl" method to handle Auth0 dialog opened in the SFSafariViewController:

```C#
        public override bool OpenUrl(UIApplication application, NSUrl url, string sourceApplication, NSObject annotation)
        {
            ActivityMediator.Instance.Send(url.AbsoluteString);

            return true;
        }
```
One more thing - you have to add "CFBundleURLTypes" key in the "info.plist" file so applciation to enable Auth0 login in SFSafariViewController:

```C#
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>None</string>
        <key>CFBundleURLName</key>
        <string>Auth0</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_APPLICATION_PACKAGE_IDENTIFIER</string>
        </array>
    </dict>
</array>
```

**UWP application project**

The last project is UWP application. Again inside "Services" folder create "AuthenticationService" class:

```C#
[assembly: Dependency(typeof(AuthenticationService))]
namespace Auth0XamarinForms.UWP.Services
{
    public class AuthenticationService : IAuthenticationService
    {
        private Auth0Client _auth0Client;

        public AuthenticationService()
        {
            _auth0Client = new Auth0Client(new Auth0ClientOptions
            {
                Domain = AuthenticationConfig.Domain,
                ClientId = AuthenticationConfig.ClientId
            });
        }

        public AuthenticationResult AuthenticationResult { get; private set; }

        public async Task<AuthenticationResult> Authenticate()
        {
            var auth0LoginResult = await _auth0Client.LoginAsync(new { audience = AuthenticationConfig.Audience });
            AuthenticationResult authenticationResult;

            if (!auth0LoginResult.IsError)
            {
                authenticationResult = new AuthenticationResult()
                {
                    AccessToken = auth0LoginResult.AccessToken,
                    IdToken = auth0LoginResult.IdentityToken,
                    UserClaims = auth0LoginResult.User.Claims
                };
            }
            else
                authenticationResult = new AuthenticationResult(auth0LoginResult.IsError, auth0LoginResult.Error);

            AuthenticationResult = authenticationResult;
            return authenticationResult;
        }
    }
```

Done. Now you have implementation for user authentication in the Xamarin Forms application.

## Integrating Xamarin Forms and Azure Functions
Once application user interface is ready we have to integrate it to the Azure Function App.

Open the Core project (where pages for the application are located) and inside the "Services" folder add new class called "AzureFunctionDataService" - this class implements the "IAuthenticationService" interface - please note that you are using Dependency Injection to register it. In the "GetGreeting" method "AuthenticationResult" parameter should be passed. RestSharp library is used to make HTTP request to the Azure Function App. When token is valid greetings from the Function App is returned:

```C#
[assembly: Dependency(typeof(AzureFunctionDataService))]
namespace Auth0XamarinForms.Core.Services
{
    public class AzureFunctionDataService : IAzureFunctionDataService
    {
        private RestClient _restClient;


        public AzureFunctionDataService()
        {
            _restClient = new RestClient(AzureConfig.AzureFunctionUrl);
        }

        public async Task<string> GetGreeting(AuthenticationResult authenticationResult)
        {
            var responseContent = string.Empty;
            var request = new RestRequest(Method.POST);
            request.AddHeader("Authorization", "Bearer " + authenticationResult.AccessToken);
            request.AddParameter("application/json", "{\"name\":\"Daniel\"}", ParameterType.RequestBody);
            var response = await _restClient.ExecuteTaskAsync<string>(request, default(CancellationToken));

            if (response.StatusCode == System.Net.HttpStatusCode.OK)
            {
                responseContent = response.Data;
            }

            return responseContent;
        }
    }
```

Finally you have to connect logic with user interface. Open "LoginPage.xaml.cs". In the "Login_Clicked" method IAuthenticationService implementation is called to handle authentication. If suceeded IAzureFunctionDataService instance is invoked to send request with access token to the Azure Function App. If token is valid Function returns greetings and user avatar.

```C#
        private async void Login_Clicked(object sender, EventArgs e)
        {
            var authenticationService = DependencyService.Get<IAuthenticationService>();
            var authenticationResult = await authenticationService.Authenticate();

            if (!authenticationResult.IsError)
            {
                var azureFunctionDataService = DependencyService.Get<IAzureFunctionDataService>();
                var dataFromAzureFunction = await azureFunctionDataService.GetGreeting(authenticationResult);
                if (!string.IsNullOrEmpty(dataFromAzureFunction))
                    Navigation.PushAsync(new MainPage(dataFromAzureFunction, authenticationResult));
                else
                    MainPageLabel.Text = "Cannot retrieve data from Azure Function. Please check configuration";
            }
        }
```
Avatar and greetings are displayed on the Main Page:

```C#
public MainPage(string greetingFromAzureFunction, AuthenticationResult authenticationResult)
  {
	InitializeComponent();
        GreetingLabel.Text = greetingFromAzureFunction;
        UserImage.Source = authenticationResult.UserClaims.FirstOrDefault(c => c.Type == "picture")?.Value;
   }
```

Final application should look like below:

![Xamarin Forms project template](https://github.com/Daniel-Krzyczkowski/guest-writer/blob/master/articles/images/auth0_9.png)

![Xamarin Forms project template](https://github.com/Daniel-Krzyczkowski/guest-writer/blob/master/articles/images/auth0_10.png)

![Xamarin Forms project template](https://github.com/Daniel-Krzyczkowski/guest-writer/blob/master/articles/images/auth0_11.png)

## Summary
This application tutorial was created to get you started with the Auth0 authentication in the Azure Function Application and Xamarin Forms cross-platform application. You should know now what the Microsoft Azure cloud platform is and how to use it to create servless Function App. You can find the source code with step by step description in my [GitHub repository](https://github.com/Daniel-Krzyczkowski/MicrosoftAzure/tree/master/Auth0AzureFunction). I encourage you to explore the Azure platform so you can find many interesting and helpful services.
