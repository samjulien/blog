---
layout: post
title: "Create Secure Angular Apps in the Cloud with StackBlitz and Auth0"
description: "Learn how to create Angular applications secured by Auth0 using StackBlitz, an online IDE for web applications powered by Visual Studio Code."
date: 2018-06-29 8:30
category: Angular, Cloud, Authentication
design: 
  bg_color: "#1A1A1A"
  image: https://cdn.auth0.com/blog/angular/logo3.png
author:
  name: Dan Arias
  url: http://twitter.com/getDanArias
  mail: dan.arias@auth.com
  avatar: https://pbs.twimg.com/profile_images/1002301567490449408/1-tPrAG__400x400.jpg
tags: 
  - stackblitz
  - angular
  - javascript
  - cloud
  - authentication
  - auth
  - ide
related:
  - 
---

Auth0 is proud to be a sponsor of the [StackBlitz](https://stackblitz.com/) platform. StackBlitz is an online IDE for web applications that is powered by Visual Studio Code. The platform feels as quick and flexible as its desktop counterpart. It offers us developers with great features such as:

* Intellisense, Project Search (Cmd/Ctrl+P), Go to Definition, and other key Visual Studio Code features.

* Hot reloading as we type.

* Importing NPM packages into a project.

* Editing while offline thanks to a revolutionary in-browser dev server.

* A hosted app URL where we see (or share) our live application at any time.

* And [many other great features](https://medium.com/@ericsimons/stackblitz-online-vs-code-ide-for-angular-react-7d09348497f4).

In this blog post, we are going to learn how easy and convenient is to build the foundation of an Angular app in the cloud using StackBlitz and to secure it with Auth0.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Say hello to the awesome v6 release of <a href="https://twitter.com/angular?ref_src=twsrc%5Etfw">@Angular</a> on StackBlitz! 👋  😍<a href="https://t.co/MxsLbdQZzS">https://t.co/MxsLbdQZzS</a> <a href="https://t.co/8Zrxh06DQL">pic.twitter.com/8Zrxh06DQL</a></p>&mdash; StackBlitz (@stackblitz) <a href="https://twitter.com/stackblitz/status/992178550173155328?ref_src=twsrc%5Etfw">May 3, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>



## Getting Familiar with StackBlitz

Getting started with StackBlitz is super easy. Let's point our browser to [`https://stackblitz.com`](https://stackblitz.com/). Once there, notice the `Start a New Project` section that offers us different options to get started. 

At the moment of this writing, the options are Angular, React, and Ionic. Just below that area, StackBlitz offers a `Featured Projects` section that includes two quickstarts from Auth0: Angular and React. Let's go ahead and click on the `Auth0 Angular` one. 


<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/1-choosing-angular-auth.png" alt="StackBlitz home page">
</p>

In a few seconds, StackBlitz scaffolds a brand new project environment for us complete with an online code editor and a browser preview, all within the same browser window!

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/2-project-ready.png" alt="StackBlitz scaffold">
</p>

A really cool StackBlitz features to mention here:

* StackBlitz lets you save your progress so that you can leave the browser and resume your work later on. To save your work, sign up with GitHub to create a StackBlitz profile. 

* Your profile showcases all of the work that you have saved in the platform, which effectively allows you to use StackBlitz as an online portfolio that you can share with others, think of it as a **live code resume**! 

* You can also import your GitHub projects into StackBlitz and continue their development in the online editor. Use StackBlitz to develop team projects, prototypes, whatever you desire, it's all portable and easily accessible through the universal platform that is the web. More on this feature later on.

We can also provide our project with a custom name that would be reflected in its URL. To do this, locate the project name in the upper left corner, click on the pencil icon, and provide it a new unique name. I am naming mine `angularblitz`. If we take a look at my browser preview domain, we can see that now I also have a custom domain:

```bash
https://angularblitz.stackblitz.io
```

This is very similar to what GitHub does with Github pages! I can share that link with anyone I want to check out my app online. The biggest and most useful difference is that the code is alive on StackBlitz! Other people can interact with my code instead of it being static. They can also fork my project to make it their own and make any changes to it. That is definitely one of the best features of **StackBlitz: living code**.

{% include tweet_quote.html quote_text="The best feature of StackBlitz is that it acts as a repository of living code. Share, fork, and change your code right within the browser!" %}

We can hide the preview browser by clicking on the top right corner `Close` button. But something better to do is to click on `Open in New Window`. If we do that, StackBlitz opens our app preview into a full browser tab. You can detach that from our browser and position side to side with the editor window. Just like that, we have recreated the usual editor and browser setup. When we make any changes in the code editor, the preview tab is live and reflects the new changes super fast.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/3-unique-name.png" alt="StackBlitz Angular Custom URL">
</p>

Notice on the editor tab that we have a full working project directory. StackBlitz scaffolds the foundation of our project.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/4-full-project-folder.png" alt="StackBlitz full project">
</p>

As a first step, let's jump into the browser preview and learn how to get started with Auth0.

## Authentication in Five Steps

In the browser preview, we have a page that lists all the needed steps to enable authentication through Auth0 in this Angular application that lives in StackBlitz.

Auth0 is a global leader in [Identity-as-a-Service (IDaaS)](https://www.webopedia.com/TERM/I/idaas-identity-as-a-service.html). It provides thousands of customers with a Universal Identity Platform for their web, mobile, IoT, and internal applications. Our extensible platform seamlessly authenticates and secures more than 1.5B logins per month, making it loved by developers and trusted by global enterprises.

The best part of the Auth0 platform is how streamlined is to get started. Let's follow the five steps listed in the page and discuss them in detail.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/5-auth0-initial-steps.png" alt="StackBlitz preview">
</p>

### Step 1: Signing Up and Getting Credentials for Auth0

<a href="https://auth0.com/signup" data-amp-replace="CLIENT_ID" data-amp-addparams="anonId=CLIENT_ID(cid-scope-cookie-fallback-name)">Sign up for a free Auth0 account here</a> or click on the sign up button in the page. You can start for free and save time with Auth0. A free account offers us:

* 7,000 free active users & unlimited logins.
* [Passwordless authentication](https://auth0.com/blog/how-passwordless-authentication-works/).
* [Lock](https://auth0.com/lock) for Web, iOS & Android.
* Up to 2 [social identity providers](https://auth0.com/docs/identityproviders) like Facebook, Github, and Twitter.
* Unlimited [Serverless Rules](https://auth0.com/docs/rules/current). 
 
During the sign-up process, you are going to create something called a *Tenant*, this represents the product or service to which you are adding authentication. More on this in a moment.

Once you are signed in, you are welcomed into the Auth0 Dashboard. In the left sidebar menu, click on "Applications". Let's understand better what this area represents.

Let's say that we have a photo-sharing app called Auth0gram. We then would create an *Auth0 tenant* called `auth0gram`. From a customer perspective, Auth0gram is that customer's product or service. Auth0gram is available as a web app that can be accessed through desktop and mobile browsers and as a native mobile app for iOS and Android. That is, Auth0gram is available on 3 platforms: web as a single page application, Android as a native mobile app, and iOS also as a native mobile app. If each platform needs authentication, then we would need to create 3 *Auth0 applications* that would connect with each respective platform to provide the product all the wiring and procedures needed to authenticate users through that platform. Auth0gram users would belong to the *Auth0 tenant* and are shared across *Auth0 applications*. If we have another product called "Auth0shop" that needs authentication, we would need to create another tenant, `auth0shop`, and create new Auth0 applications for it depending on the platforms where it lives.

With this knowledge, in "Applications", click on the button "Create Application". A modal titled "Create Application" will open up. We have the option to provide a `Name` for the application and choose its type. 

Let's name this app the same as the StackBlitz one `angularblitz` and choose `Single Page Web Applications` as the type:

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/6-create-application.png" alt="Auth0 Create Application view">
</p>

> Your StackBlitz app will be named something different, feel free to use any names you like.

Let's click "Create". Next, we are going to be welcomed by a view that asks us "What technology are you using for your web app?". This is a tool that we've created at Auth0 to provide you different quickstarts to get you up and running fast in setting up Auth0 within a project. Feel free to choose Angular and check out the content of that quickstart, but for this app, I am giving you the quick steps that relate to setting up Auth0 specifically for the StackBlitz architecture, so please, stay with me here.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Learned last night: <a href="https://t.co/pBChRzDhto">https://t.co/pBChRzDhto</a> (by <a href="https://twitter.com/auth0?ref_src=twsrc%5Etfw">@auth0</a>) + <a href="https://twitter.com/stackblitz?ref_src=twsrc%5Etfw">@stackblitz</a> = easy peasy full stack live demo setup for talks 🤯🤯🤯</p>&mdash; Sam Julien 🅰️⬆️ (@samjulien) <a href="https://twitter.com/samjulien/status/964567331832782848?ref_src=twsrc%5Etfw">February 16, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

In the next step, we are going to discuss how to help Angular and Auth0 communicate.

### Step 2: Creating a Communication Bridge Between Angular and Auth0

One of the offerings of Auth0 to reduce the overhead of adding and managing authentication is our [Universal Login](https://auth0.com/docs/hosted-pages/login) page. Auth0's Universal Login is the most secure way to easily authenticate users for your applications.

How does [Universal Login work](https://auth0.com/docs/hosted-pages/login#how-does-universal-login-work)?  

Auth0 shows the login page whenever something (or someone) triggers an authentication request. Users will see the login page provided by Auth0. Once they log in, they will be redirected back to our application. With security in mind, for this to happen, we have to specify in the Auth0 Settings to what URLs Auth0 can redirect users once they are authenticated. 

Back in the Auth0 Settings page, let's scroll down until we see **"Allowed Callback URLs"**. We are going to specify here where we want Auth0 to redirect our users. In my case, I am going to paste `https://angularblitz.stackblitz.io/callback`.

Why do we need to append `/callback` to the root domain? As we are going to see later, we'd want to redirect users to a special Angular component (a view) that processes and saves authentication data in memory and sets a flag in local storage indicating that the user is logged in. 

We also need to tell Auth0 where to redirect a user when they log out. We are going to use the root domain of our application as that target route. Therefore, I am going to paste `https://angularblitz.stackblitz.io` in the **"Allowed Callback URLs"** field. 

> After the user authenticates Auth0 will only call back to any of the URLs listed in that field.

Finally, we need to enable Cross-Origin Authentication. [What is Cross-Origin Authentication?](https://auth0.com/docs/cross-origin-authentication#what-is-cross-origin-authentication-) When authentication requests are made from our application to Auth0, the user's credentials are sent to a domain which differs from the one that serves our application. Collecting user credentials in an application served from one origin and then sending them to another origin can present certain security vulnerabilities, including the possibility of a phishing attack. 

Auth0 provides a [cross-origin authentication flow](https://raw.githubusercontent.com/jaredhanson/draft-openid-connect-cross-origin-authentication/master/Draft-1.0.txt) which makes use of [third-party cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#Third-party_cookies). The use of third-party cookies allows Auth0 to perform the necessary checks to allow for secure authentication transactions across different origins. This **helps to prevent phishing** when creating a single sign-on experience with the Lock widget or a custom login form in our application and it also helps to create a secure login experience even if single sign-on is not the goal. 

To allow transactions between our Angular app origin and Auth0, we need to add our root domain to the **Allowed Web Origins** field in the "Settings". In my case, I am adding `https://angularblitz.stackblitz.io/` as its value. 

Save these settings by scrolling down and clicking on `Save Changes` or pressing `CMD`/`CTRL` + `S`. 

### Step 3: Adding Auth0 Configuration Variables to Angular

From the Auth0 Application, we need configuration variables to allow our Angular application to use the communication bridge we previously created. Within the Auth0 Application Settings page, we need the following variables:

* **Domain**

 When we created our new account with Auth0, we were asked to pick a name for our Tenant. This name, appended with `auth0.com`, will be our Auth0 Domain. It's the base URL we will be using to access the Auth0 API and the URL where users are redirected in order to authenticate.
 
 > [Custom domains](https://auth0.com/docs/getting-started/the-basics#custom-domains) can also be used to allow Auth0 to do the authentication heavy lifting for us without compromising on branding experience.

* **Client ID**

[Each application is assigned a Client ID upon creation](https://auth0.com/docs/getting-started/the-basics). This is an alphanumeric string and it's the unique identifier for our application (such as `q8fij2iug0CmgPLfTfG1tZGdTQyGaTUA`). It cannot be modified and we will be using it in our application's code when we call Auth0 APIs. 

> **Warning:** Another important piece of information present in the "Settings" is the **Client Secret**. Think of it as your application's password which must be kept confidential at all times. If anyone gains access to your Client Secret they can impersonate your application and access protected resources.

In the next section, we will discuss the Angular project structure present on StackBlitz. For now, to start wiring our Angular app with Auth0, use the values of `Client ID` and `Domain` from the "Settings" to replace the values of `clientID` and `domain` in the `environment.ts` file present in `src/environments/` in our project directory.

```typescript
// src/environments/environment.ts

export const environment = {
  production: false,
  auth: {
    clientID: "YOUR-AUTH0-CLIENT-ID",
    domain: "YOUR-AUTH0-DOMAIN", // e.g., you.auth0.com
    redirect: "YOUR-AUTH0-CALLBACK"
  }
};
```

### Step 4: Log in

Press the login button to test that we are communicating correctly with Auth0 and that we can get authenticated. 

If everything was set up correctly, we are going to be redirected to the [Universal Login page](https://auth0.com/docs/hosted-pages/login). As explained earlier, this login page is provided by Auth0 with batteries included. It powers not only the login but also the signup of new users into our application. If you have any existing user already, go ahead and log in; otherwise, sign up as a new user.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/7-hosted-login-page.png" alt="Auth0 Universal Login page">
</p>

An advantage of the Universal Login page is that it is part of the Auth0 domain, not StackBlitz or our Angular app. It lets us delegate the process of user authentication, including registration, to Auth0. 

If you created a new user through the sign-up process, you will receive an email asking you to verify your email. There are tons of settings that we can tweak to customize the signup and login experience of our users, such as [requiring a username for registration](https://auth0.com/docs/connections/database/require-username). Feel free to check out the different options presented to you by Auth0 within the Dashboard and the [Auth0 documentation](https://auth0.com/docs).

Once we signed up or logged in, we are taken back to our Angular app hosted at StackBlitz. Notice that the button in the jumbotron (the giant header at the top of the page) changed from `Login` to `Logout`, which means that we are authenticated. 

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/8-logout-button-ready-alt.png" alt="Authenticated Session">
</p>

### Step 5: Accessing Guarded Routes

Our application uses Angular to guard the `/account` route. Angular route guards are for the UI only. They don't confer any security when it comes to accessing an API. However, if we were to enforce authentication and authorization in our API (as we should do in all our apps), we could take advantage of guards to authenticate and redirect users as well as stop unauthorized navigation. 

The `/account` route guard prevents navigation to it if the user is not authenticated. Since we have logged in, when we click on the `guarded route` link that points to `/account`, we are successfully taken to that view. In case that we were logged out, we would remain on the home screen.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/9-account-page.png" alt="Access to guarded Account View">
</p>


### Authentication Integration Completed

That's it! All that is left is for you to continue building your project in StackBlitz or to export the project locally by downloading it. Feel free to dive deeper into the [Auth0 Documentation](https://auth0.com/docs/getting-started) to learn more about how Auth0 helps you save time on implementing and managing identity. However, in the next sections, we'll explore what is happening under-the-hood of our Angular application in relation to authentication with Auth0.

## Auth0 Angular Starter

This application was created using the [Angular CLI](https://cli.angular.io/); thus, the project structure may feel familiar. Our application code centers around the contents of the `src` folder.

Within the `src` folder we find:

* `app` directory: It holds all the constructs that belong to the app and build it.
* `environments` directory: It holds configuration for different environments such as `development` and `production`.
* `index.html`: The entry point for the frontend application
* `main.ts`: The entry point for the Angular application
* `polyfills.ts`:  This file includes polyfills needed by Angular and is loaded before the app. You can add your own extra polyfills to this file.
* `styles.css`: Application-wide (global) styles. Add your own to customize the app's look.

Inside the `app` folder is where the core Angular development happens. Here we find:

* `app.module.ts` which bootstraps the application using the `app.component.ts`. 
* `app-routing.module.ts` which defines the root routes of the app.
* We have three folders that define components of the app:
  * `home`: Holds a component that defines the Home view of our app. 
  * `callback`: The route that points to this component will be called by Auth0 once it completes the authentication process successfully. This component has logic that saves the authentication data returned by Auth0 in memory.
  * `account`: Holds a component that defines an Account view that presented user profile information. This is a private view that requires authentication.
* We have an `auth` folder that holds everything related to the authentication feature of our application which is powered by Auth0.

This is the gist of the project structure available to us. Next, let's learn about the authentication flow that this Angular application is following.

## Authentication Under the Hood

Within the `app/auth` folder we have three files:

* `auth.config.ts` creates an object that contains our Auth0 application credentials and configuration.
* `auth.service.ts` creates a service that handles of all our authentication flow.
* `auth.guard.ts` wires up Angular router guards with our authentication service so that we can create guarded routes within our router configuration.

### Angular Authentication Service

`auth.service.ts` is annotated with comments that described what each method in the `AuthService` class is doing. This service imports the `auth0-js` module which contains everything needed for authentication:

```typescript
import * as auth0 from 'auth0-js';
```

When a user logs in, Auth0 returns three items:

* `access_token`: to learn more, see the [Access Token documentation](https://auth0.com/docs/tokens/access-token)

* `id_token`: to learn more, see the [ID Token documentation](https://auth0.com/docs/tokens/id-token)

* `expires_in`: the number of seconds before the Access Token expires


We use these items in our application to set up and manage authentication.

In the service, we have an instance of the `auth0.WebAuth` object. When creating that instance, we can specify the following:

* Configuration for our application and domain.
* Response type, to show that we need a user's Access Token and an ID Token after authentication.
* Audience and scope, which specify that authentication must be [OIDC-conformant](https://auth0.com/docs/api-auth/tutorials/adoption).
* The URL where we want to redirect our users after authentication.

We define the configuration object passed to `auth0.WebAuth` by importing our `AUTH_CONFIG` object and using its values here:

```typescript
import { AUTH_CONFIG } from './auth.config';
```

```typescript
auth0 = new auth0.WebAuth({
    clientID: AUTH_CONFIG.CLIENT_ID,
    domain: AUTH_CONFIG.CLIENT_DOMAIN,
    responseType: 'token id_token',
    redirectUri: AUTH_CONFIG.REDIRECT,
    audience: AUTH_CONFIG.AUDIENCE,
    scope: AUTH_CONFIG.SCOPE
  });
```


The `login` method is used for Auth0 to authorize the request by calling `this.auth0.authorize()` and it is wired to a login UI element.

`handleAuth` looks for the result of authentication in the URL hash. Then, the result is processed with the `parseHash` method from `auth0-js`.

`_setSession` stores the user's Access Token, ID Token, and the Access Token's expiry time in browser storage.

`logout` removes the user's tokens and expiry time from browser storage.

`authenticated`: checks whether the expiry time for the user's Access Token has passed.

With all these methods present in the service, we have a full authentication framework that would handle everything the user needs to have a complete authentication experience.

### Process the Authentication Result

When a user authenticates at the login page, they are redirected to our application. Their URL contains a hash fragment with their authentication information. As we saw, the `handleAuth` method in the `AuthService` service processes the hash. 

We need to call the `handleAuth` somewhere. The method processes the authentication hash while our app loads. We do this in the `ngOnInit()` lifecycle hook of the `CallbackComponent`:

```typescript
// app/callback/callback.component.ts
import { Component, OnInit } from '@angular/core';
import { AuthService } from '../auth/auth.service';

@Component({
  selector: 'callback',
  template: `
    <p>
      Loading...
    </p>
  `,
  styles: []
})
export class CallbackComponent implements OnInit {

  constructor(private authService: AuthService) { }

  ngOnInit() {
    this.authService.handleAuth();
  }

}
```

When the `CallbackComponent` is initialized by Angular, the authentication workflow is also started and our app is ready to handle login and logout requests as well as to enable or prevent navigation to guarded routes based on the authentication status of the user, which is communicated by the `authenticated` method within `AuthService`.

Our under-the-hood view of the Auth0 Angular authentication process is now complete. Authentication is hard but Auth0 definitely makes it much easier to understand and implement. 

### Conclusion

I encourage you to learn more about what Auth0 can do to help you meet your identity requirements and goals and to also experiment with developing projects in the cloud using StackBlitz. Our partnership with StackBlitz was carefully selected because we saw the potential it provides to developers around the globe to create highly available applications. 

Whether you are building a [B2C](https://auth0.com/b2c-customer-identity-management), [B2B](https://auth0.com/b2b-enterprise-identity-management), or [B2E](https://auth0.com/b2e-identity-management-for-employees) tool, Auth0 can help you focus on what matters the most to you, the special features of your product. [Auth0](https://auth0.com/) can improve your product's security with state-of-the-art features like [passwordless](https://auth0.com/passwordless), [breached password surveillance](https://auth0.com/breached-passwords), and [multifactor authentication](https://auth0.com/multifactor-authentication).

[We offer a generous **free tier**](https://auth0.com/pricing) so you can get started with modern authentication.

Let me know how you like Auth0 and StackBlitz in the comments below. Please, feel free to share with us any cool project that you may have live and public on StackBlitz, whatever tech stack it may be! 

<p style="text-align: center;">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/EBzoTnX6LzU?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
</p>
