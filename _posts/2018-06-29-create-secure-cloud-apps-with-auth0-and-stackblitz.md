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



## Setting up Angular with Auth0

Getting started with StackBlitz is super easy. Let's point our browser to [`https://stackblitz.com`](https://stackblitz.com/). Once there, notice the `Start a New Project` section that offers us different options to get started. 

At the moment of this writing, the options are Angular, React, and Ionic. Just below that area, StackBlitz offers a `Featured Projects` section that includes two quickstarts from Auth0: Angular and React. Let's go ahead and click on the `Auth0 Angular` one. 


<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/1-choosing-angular-auth.png" alt="StackBlitz home page">
</p>

In a few seconds, StackBlitz scaffolds a brand new project environment for us complete with a code editor and a browser preview, all within the same browser window!

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/2-project-ready.png" alt="StackBlitz scaffold">
</p>

A few cool things to mention here:

StackBlitz lets you save your progress so that you can leave the browser and come back to complete your work.

You can sign up with GitHub and basically create an online portfolio with live code to share with others, team projects, prototypes, whatever you desire, all portable and easily accessible through the universal platform that is the web.

We can also provide our project with a custom name that would be reflected in its URL. To do this, locate the project name in the upper left corner, click on the pencil icon, and provide it a new unique name. I am naming mine `angular-cloud`. If we take a look at my browser preview domain, we can see that now I also have a custom domain:

```bash
https://angular-cloud.stackblitz.io
```

This is very similar to what GitHub does with Github pages! I can share that link with anyone I want to check out my app online. The biggest and most useful difference is that the code is alive on StackBlitz! Other people can interact with my code instead of it being static. They can also fork my project to make it their own and make any changes to it. That is definitely one of the best features of StackBlitz: living code.

{% include tweet_quote.html quote_text="The best feature of StackBlitz is that it acts as a repository of living code. Share, fork, and change your code right within the browser!" %}

We can hide the preview browser by clicking on the top right corner `Close` button. But something better to do is to click on `Open in New Window`. If we do that, StackBlitz opens our app preview into a full browser tab. You can detach that from our browser and position side to side with the editor window. Just like that, we have recreated the usual editor and browser setup. When we make any changes in the code editor, the preview tab is live and reflects the new changes super fast.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/3-unique-name.png" alt="StackBlitz Angular Custom URL">
</p>

Notice on the editor tab that we have a full working project directory. StackBlitz scaffolds the foundation of our project. Let's go over what resources we have available next.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/4-full-project-folder.png" alt="StackBlitz full project">
</p>

## Auth0 Angular Starter

If you are familiar with Angular apps generated through the [Angular CLI](https://cli.angular.io/), the initial project structure created by StackBlitz won't look too different. 

At the project root folder we have:

* `app` directory: It holds all the constructs that belong to the app.
* `index.htmt`: The entry point for the frontend application
* `main.ts`: The entry point for the Angular application
* `polyfills.ts`:  This file includes polyfills needed by Angular and is loaded before the app. You can add your own extra polyfills to this file.
* `styles.css`: Application-wide (global) styles. Add your own to customize the app's look.

Inside the `app` folder is where the core Angular development actions happen. Inside that folder we have:

* `app-module.ts` which bootstraps the application using the `app.component.ts`. 
* `router.module.ts` which defines the root routes of the app.
* We also have three folders that define features and other components of the app:
  * `auth`: This folder holds everything related to the authentication feature of our application which is powered by 
  Auth0. This is the core focus of this post and we are going to learn more about its details soon.
  * `account`: Holds a component that defines an Account Management feature.
  * `home`: Holds a component that defines the Home Screen of our app. 
  * `callback`: This component will be called when we complete the authentication process successfully.
 
If we go back to `https://angular-cloud.stackblitz.io/` in the preview tab, the home screen will show us some steps that we need to take to enable Auth0 in our project:
 
<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/5-auth0-initial-steps.png" alt="StackBlitz preview">
</p>
 
Let's go over these steps next!
 
## Setting Up Angular Authentication with Auth0
 
Let's go briefly over the steps that we need to take to set up Auth0 to use it with our project.
 
### Signing up for an Auth0 account

> If you already have an account, you can skip this step. Otherwise, read on, please.

<a href="https://auth0.com/signup" data-amp-replace="CLIENT_ID" data-amp-addparams="anonId=CLIENT_ID(cid-scope-cookie-fallback-name)">Sign up for a free Auth0 account here</a>. During the sign-up process, you are going to create something called a *Tenant*, this represents the product or service to which you that are adding authentication. I'll explain more on this is a moment. 

Once you are signed in, you are welcomed into the Auth0 Dashboard. In the left sidebar menu, click on `Applications`. Let's understand better what this area represents.

Let's say that we have a photo-sharing app called Auth0gram. We then would create an *Auth0 tenant* called `auth0gram`. From a customer perspective, Auth0gram is that customer's product or service. Auth0gram is available as a web app that can be accessed through desktop and mobile browsers and as a native mobile app for iOS and Android. That is, Auth0gram is available on 3 platforms: web as a single page application, Android as a native mobile app, and iOS also as a native mobile app. If each platform needs authentication, then we would need to create 3 *Auth0 applications* that would connect with each respective platform to provide the product all the wiring and procedures needed to authenticate users through that platform. Auth0gram users would belong to the *Auth0 tenant* and are shared across *Auth0 applications*. If we have another product called "Auth0shop" that needs authentication, we would need to create another tenant, `auth0shop`, and create new Auth0 applications for it depending on the platforms where it lives.    

With this knowledge, in `Applications`, click on the button `Create Application`. A modal titled `Create Application` will open up. We have the option to provide a `Name` for the application and choose its type. 

Let's name this app the same as the StackBlitz one `angular-cloud` and choose `Single Page Web Applications` as the type:

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/6-create-application.png" alt="Auth0 Create Application view">
</p>

> Your StackBlitz app will be named something different, feel free to use any names you like! 

Let's click `Create`. Next, we are going to be welcomed by a view that asks us `What technology are you using for your web app?`. This is a tool that we've created at Auth0 to provide you different quickstarts to get you up and running fast in setting up Auth0 within a project. Feel free to choose Angular and check out the content of that quickstart, but for this app, I am giving you the quick steps that relate to setting up Auth0 specifically for the StackBlitz architecture, so please, stay with me here.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Learned last night: <a href="https://t.co/pBChRzDhto">https://t.co/pBChRzDhto</a> (by <a href="https://twitter.com/auth0?ref_src=twsrc%5Etfw">@auth0</a>) + <a href="https://twitter.com/stackblitz?ref_src=twsrc%5Etfw">@stackblitz</a> = easy peasy full stack live demo setup for talks 🤯🤯🤯</p>&mdash; Sam Julien 🅰️⬆️ (@samjulien) <a href="https://twitter.com/samjulien/status/964567331832782848?ref_src=twsrc%5Etfw">February 16, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


### Wiring up Auth0 with Angular in StackBlitz

What we want from the Auth0 Application are some data points that we need to make available in our Angular app so that it can talk to Auth0. Click on the `Settings` tab of your application and you are going to get a view of different fields. So what do we need from here? To answer that, let's look at the `auth.config.ts` file within the `app/auth` folder:

```typescript
// auth.config.ts

interface AuthConfig {
  CLIENT_ID: string;
  CLIENT_DOMAIN: string;
  REDIRECT: string;
  SCOPE: string;
}

export const AUTH_CONFIG: AuthConfig = {
  CLIENT_ID: 'YOUR-CLIENT-ID', //e.g. 8zOgTfK4Ga1KaiFPNFen6gQstt2Jvwlo
  CLIENT_DOMAIN: 'YOUR-DOMAIN.auth0.com', // e.g., adobot.auth0.com
  REDIRECT: 'https://auth0.stackblitz.io/callback',
  SCOPE: 'openid profile email'
};
```

To populate the `AUTH_CONFIG` object, we need the `CLIENT_ID` and the `CLIENT_DOMAIN` which we can get from the Auth0 `Settings`. Copy your `Client ID` and paste it as the value of `CLIENT_ID`. Next copy your `Domain` and paste it as the value of `CLIENT_DOMAIN`.

What this is doing is establishing the credentials that our Angular app will use to tell Auth0 that it is authorized to be part of the authentication flow. Please change the `REDIRECT` field with the value of your StackBlitz app URL plus a `/callback` path. In my case, it would look like this: 

```typescript
REDIRECT: 'https://angular-cloud.stackblitz.io/callback'
```

What is `SCOPES` for anyway?

Scopes are the scopes that we need for our application.  For the `/userinfo` endpoint, they are the [OIDC standard scopes](https://openid.net/specs/openid-connect-core-1_0.html#UserInfo). This tells the authentication service which user claims to put in the ID token and make available on the `/userinfo` endpoint.

Finally, we need to list our StackBlitz app URL in the `Allowed Callback URLs` from the `Settings`. In my case, I'd need to paste `https://angular-cloud.stackblitz.io/callback` into the text box. This will allow Auth0 to redirect to an area of our app when it completes the authentication process successfully. Notice that this is the same URL that we defined as the value of the `REDIRECT`. Auth0 will only call back to any of the URLs defined in this text box. 

Save these settings by scrolling down and clicking on `Save Changes` or pressing `CMD`/`CTRL` + `S`.

We are done wiring up Auth0. It's time that we see it in action.

## Testing Authentication for Angular

Let's go back to our app preview tab. In the Home Screen, if you click on the `protected page` link in "Step 4", nothing will happen. That's because we are not logged in and we are implementing a [route guard](https://angular.io/guide/router#milestone-5-route-guards) in our application. Route guards determine whether a user should be allowed to access a specific route or not. If the guard evaluates to `true`, navigation is allowed to complete. If the guard evaluates to `false`, the route is not activated and the user's attempted navigation does not take place. With the `AuthGuard` implemented in `auth/auth.guard.ts` we establish one level of authorization: Is the user authenticated?

```typescript
// auth/auth.guard.ts

import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs/Observable';
import { AuthService } from './auth.service';
import { Router } from '@angular/router';

@Injectable()
export class AuthGuard implements CanActivate {

  constructor(private authService: AuthService, private router: Router) {}

  canActivate(
    next: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Observable<boolean> | Promise<boolean> | boolean {
    if (!this.authService.authenticated) {
      this.router.navigate(['/']);
      return false;
    }
    return true;
  }
}
```

When `AuthGuard` is invoked by the router, if the user is not authenticated, the router navigates to the Home Screen. Within our router configuration in `app/router.module.ts`, we use `AuthGuard` to guard the path `/account` from unauthenticated access: 

```typescript
// app/router.module.ts

// ... 

const routes: Routes = [
  {
    path: '',
    component: HomeComponent,
  },
  {
    path: 'account',
    component: AccountComponent,
    canActivate: [
      AuthGuard
    ]
  },
  {
    path: 'callback',
    component: CallbackComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  providers: [AuthGuard],
  exports: [RouterModule]
})
export class AppRoutingModule { }
``` 

You can use `AuthGuard` to protect any other route you may create afterward. 

Route guards are for the UI only. They don't confer any security when it comes to accessing an API. However, if we were to enforce authentication and authorization in our API (as we should do in all our apps), we could take advantage of guards to authenticate and redirect users as well as stop unauthorized navigation.

So let's go ahead and click on the `Login` button in "Step 3" and test if we are communicating correctly with Auth0 and get authenticated. 

If everything was set up correctly, we are going to be received by our awesome [Universal Login page](https://auth0.com/docs/hosted-pages/login). It's a login page provided by Auth0 with batteries included that powers not only the login but the signup of new users into our application. If you have any existing user already, go ahead and log in; otherwise, sign up as a new user.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/7-hosted-login-page.png" alt="Auth0 Universal Login page">
</p>

What is really awesome is that the Universal Login page is part of the Auth0 domain, not StackBlitz or our app. It lets us delegate the process of user authentication, including registration, to Auth0!  

If you created a new user through the sign-up process, you will receive an email asking you to verify your email. There are tons of settings that we can tweak to customize the signup and login experience of our users, such as [requiring a username for registration](https://auth0.com/docs/connections/database/require-username). Feel free to check out all the power presented to you by Auth0 within the Dashboard and our [Docs](https://auth0.com/docs).

Once we signed up or logged in, we are taken back to our Angular app that is hosted in the StackBlitz domain. Notice that the button in the jumbotron changed from `Login` to `Logout` that means we are in! 

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/8-logout-button-ready-alt.png" alt="Authenticated Session">
</p>

If we click on the `protected page` link in "Step 4" that points to the guarded route `/account`, this time around we are successfully taken to that view. 

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/create-secure-cloud-apps-with-auth0-and-stackblitz/9-account-page.png" alt="Access to guarded Account View">
</p>


And, that's it! All that is left is for you to continue building your project in StackBlitz or to export the project locally by downloading it.

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
