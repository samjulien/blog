## Aside: Authenticate an Angular App and Node API with Auth0

We can protect our applications and APIs so that only authenticated users can access them. Let's explore how to do this with an Angular application and a Node API using [Auth0](https://auth0.com). You can clone this sample app and API from the [angular-auth0-aside repo on GitHub](https://github.com/auth0-blog/angular-auth0-aside).

![Auth0 login screen](https://cdn.auth0.com/blog/resources/auth0-centralized-login.jpg)

### Features

The [sample Angular application and API](https://github.com/auth0-blog/angular-auth0-aside) has the following features:

* Angular application generated with [Angular CLI](https://github.com/angular/angular-cli) and served at [http://localhost:4200](http://localhost:4200)
* Authentication with [auth0.js](https://auth0.com/docs/libraries/auth0js) using a [login page](https://auth0.com/docs/hosted-pages/login)
* Node server protected API route `http://localhost:3001/api/dragons` returns JSON data for authenticated `GET` requests
* Angular app fetches data from API once user is authenticated with Auth0
* Profile page requires authentication for access using route guards
* Authentication service uses subjects to provide authentication and profile data to the app

### Sign Up for Auth0

You'll need an [Auth0](https://auth0.com) account to manage authentication. You can sign up for a <a href="https://auth0.com/signup" data-amp-replace="CLIENT_ID" data-amp-addparams="anonId=CLIENT_ID(cid-scope-cookie-fallback-name)">free account here</a>. Next, set up an Auth0 application and API so Auth0 can interface with an Angular app and Node API.

### Set Up an Auth0 Application

1. Go to your [**Auth0 Dashboard: Applications**](https://manage.auth0.com/#/applications) section and click the "[+ Create Application](https://manage.auth0.com/#/applications/create)" button.
2. Name your new app and select "Single Page Web Applications".
3. In the **Settings** for your new Auth0 app, add `http://localhost:4200/callback` to the **Allowed Callback URLs**.
4. Add `http://localhost:4200` to the **Allowed Logout URLs**. Click the "Save Changes" button.
5. If you'd like, you can [set up some social connections](https://manage.auth0.com/#/connections/social). You can then enable them for your app in the **Application** options under the **Connections** tab. The example shown in the screenshot above uses username/password database, Facebook, Google, and Twitter. For production, make sure you set up your own social keys and do not leave social connections set to use Auth0 dev keys.

> **Note:** Under the **OAuth** tab of **Advanced Settings** (at the bottom of the **Settings** section) you should see that the **JsonWebToken Signature Algorithm** is set to `RS256`. This is the default for new applications. If it is set to `HS256`, please change it to `RS256`. You can [read more about RS256 vs. HS256 JWT signing algorithms here](https://community.auth0.com/questions/6942/jwt-signing-algorithms-rs256-vs-hs256).

### Set Up an API

1. Go to [**APIs**](https://manage.auth0.com/#/apis) in your Auth0 dashboard and click on the "Create API" button. Enter a name for the API. Set the **Identifier** to your API endpoint URL. In this example, this is `http://localhost:3001/api/`. The **Signing Algorithm** should be `RS256`.
2. You can consult the Node.js example under the **Quick Start** tab in your new API's settings. We'll implement our Node API in this fashion, using [Express](https://expressjs.com/), [express-jwt](https://github.com/auth0/express-jwt), and [jwks-rsa](https://github.com/auth0/node-jwks-rsa).

We're now ready to implement Auth0 authentication on both our Angular client and Node backend API.

### Dependencies and Setup

The Angular app utilizes the [Angular CLI](https://github.com/angular/angular-cli). Make sure you have the CLI installed globally:

```bash
$ npm install -g @angular/cli
```

Once you've cloned [the project on GitHub](https://github.com/auth0-blog/angular-auth0-aside), install the Node dependencies for both the Angular app and the Node server by running the following commands in the root of your project folder:

```bash
$ npm install
$ cd server
$ npm install
```

The Node API is located in the [`/server` folder](https://github.com/auth0-blog/angular-auth0-aside/tree/master/server) at the root of our sample application.

Find the [`config.js.example` file](https://github.com/auth0-blog/angular-auth0-aside/blob/master/server/config.js.example) and **remove** the `.example` extension from the filename. Then open the file:

```js
// server/config.js (formerly config.js.example)
module.exports = {
  CLIENT_DOMAIN: '[YOUR_AUTH0_DOMAIN]', // e.g., 'you.auth0.com'
  AUTH0_AUDIENCE: 'http://localhost:3001/api/'
};
```

Change the `CLIENT_DOMAIN` value to your full Auth0 domain and set the `AUTH0_AUDIENCE` to your audience (in this example, this is `http://localhost:3001/api/`). The `/api/dragons` route will be protected with [express-jwt](https://github.com/auth0/express-jwt) and [jwks-rsa](https://github.com/auth0/node-jwks-rsa).

> **Note:** To learn more about RS256 and JSON Web Key Set, read [Navigating RS256 and JWKS](https://auth0.com/blog/navigating-rs256-and-jwks/).

Our API is now protected, so let's make sure that our Angular application can also interface with Auth0. To do this, we'll activate the [`src/environments/environment.ts.example` file](https://github.com/auth0-blog/angular-auth0-aside/blob/master/src/environments/environment.ts.example) by deleting `.example` from the file extension. Then open the file and change the `[YOUR_CLIENT_ID]` and `[YOUR_AUTH0_DOMAIN]` strings to your Auth0 information:

```js
// src/environments/environment.ts (formerly environment.ts.example)
...
export const environment = {
  production: false,
  auth: {
    CLIENT_ID: '[YOUR_CLIENT_ID]',
    CLIENT_DOMAIN: '[YOUR_AUTH0_DOMAIN]', // e.g., 'you.auth0.com'
    ...
  }
};
```

Our app and API are now set up. They can be served by running `ng serve` from the root folder and `node server` from the `/server` folder. The `npm start` command will run _both at the same time for you_ by using [concurrently](https://www.npmjs.com/package/concurrently).

With the Node API and Angular app running, let's take a look at how authentication is implemented.

### Token Data Model

In order to support the authentication service we're going to build, we should use a model for the authentication data we'll receive from the authorization server. We're going to create an observable behavior subject of this data, so we'll need a way to ensure it's created and stored in a way that won't produce errors if it's not present.

We do this with a `TokenData` class located in the [`src/app/auth/tokendata.model.ts` file](https://github.com/auth0-blog/angular-auth0-aside/blob/master/src/app/auth/tokendata.model.ts).

### Authentication Service

Authentication logic on the front end is handled with an `AuthService` authentication service: [`src/app/auth/auth.service.ts` file](https://github.com/auth0-blog/angular-auth0-aside/blob/master/src/app/auth/auth.service.ts). We'll step through this code below.

```js
// src/app/auth/auth.service.ts
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import * as auth0 from 'auth0-js';
import { environment } from '../../environments/environment';
import { Router } from '@angular/router';
import { TokenData } from './tokendata.model';

@Injectable()
export class AuthService {
  // Create Auth0 web auth instance
  // @TODO: Update environment variables and remove .example
  //  extension in src/environments/environment.ts.example
  private _Auth0 = new auth0.WebAuth({
    clientID: environment.auth.CLIENT_ID,
    domain: environment.auth.CLIENT_DOMAIN,
    responseType: 'id_token token',
    redirectUri: environment.auth.REDIRECT,
    audience: environment.auth.AUDIENCE,
    scope: 'openid profile email'
  });
  // Track whether or not to renew token
  private _authFlag = 'isLoggedIn';
  // Create streams for authentication data
  tokenData$ = new BehaviorSubject(new TokenData());
  userProfile$ = new BehaviorSubject(null);
  // Authentication navigation
  onAuthSuccessUrl = '/';
  onAuthFailureUrl = '/';
  logoutUrl = environment.auth.LOGOUT_URL;

  // Create observable of Auth0 parseHash method to gather auth results
  parseHash$ = Observable.create(observer => {
    this._Auth0.parseHash((err, authResult) => {
      if (err) {
        observer.error(err);
      } else if (authResult && authResult.accessToken) {
        observer.next(authResult);
      }
      observer.complete();
    });
  });

  // Create observable of Auth0 checkSession method to
  // verify authorization server session and renew tokens
  checkSession$ = Observable.create(observer => {
    this._Auth0.checkSession({}, (err, authResult) => {
      if (err) {
        observer.error(err);
      } else if (authResult && authResult.accessToken) {
        observer.next(authResult);
      }
      observer.complete();
    });
  });

  constructor(private router: Router) { }

  login() {
    this._Auth0.authorize();
  }

  handleLoginCallback() {
    if (window.location.hash && !this.authenticated) {
      this.parseHash$.subscribe(
        authResult => {
          this._streamSession(authResult);
          window.location.hash = '';
          this.router.navigate([this.onAuthSuccessUrl]);
        },
        err => this._handleError(err)
      )
    }
  }

  private _streamSession(authResult) {
    // Emit values for auth observables
    this.tokenData$.next({
      expiresAt: authResult.expiresIn * 1000 + Date.now(),
      accessToken: authResult.accessToken
    });
    this.userProfile$.next(authResult.idTokenPayload);
    // Set flag in local storage stating this app is logged in
    localStorage.setItem(this._authFlag, JSON.stringify(true));
  }

  renewAuth() {
    if (this.authenticated) {
      this.checkSession$.subscribe(
        authResult => this._streamSession(authResult),
        err => {
          localStorage.removeItem(this._authFlag);
          this.router.navigate([this.onAuthFailureUrl]);
        }
      );
    }
  }

  logout() {
    // Set authentication status flag in local storage to false
    localStorage.setItem(this._authFlag, JSON.stringify(false));
    // This does a refresh and redirects back to homepage
    // Make sure you have the logout URL in your Auth0
    // Dashboard Application settings in Allowed Logout URLs
    this._Auth0.logout({
      returnTo: this.logoutUrl,
      clientID: environment.auth.CLIENT_ID
    });
  }

  get authenticated(): boolean {
    return JSON.parse(localStorage.getItem(this._authFlag));
  }

  private _handleError(err) {
    if (err.error_description) {
      console.error(`Error: ${err.error_description}`);
    } else {
      console.error(`Error: ${JSON.stringify(err)}`);
    }
  }

}
```

This service uses the auth config variables from `environment.ts` to instantiate an [`auth0.js` WebAuth](https://auth0.com/docs/libraries/auth0js/v9#initialization) instance. Next an `_authFlag` member is created, which is simply a flag that we can store in local storage. It tells us whether or not to attempt to renew tokens with the Auth0 authorization server (for example, after a full-page refresh or when returning to the app later).

We will use [RxJS `BehaviorSubject`s](https://github.com/ReactiveX/rxjs/blob/master/doc/subject.md#behaviorsubject) to provide streams of authentication events (token data and user profile data) that you can subscribe to anywhere in the app. We'll also store some paths for navigation so the app can easily determine where to send users when authentication succeeds, fails, or the user has logged out.

The next thing that we'll do is [create _observables_](https://angular.io/guide/observables) of the auth0.js methods [`parseHash()` (which allows us to extract authentication data from the hash upon login)](https://auth0.com/docs/libraries/auth0js/v9#extract-the-authresult-and-get-user-info) and [`checkSession()` (which allows us to acquire new tokens when a user has an existing session with the authorization server)](https://auth0.com/docs/libraries/auth0js/v9#using-checksession-to-acquire-new-tokens). Using observables with these methods allows us to easily publish authentication events and subscribe to them within our Angular application.

The `login()` method authorizes the authentication request with Auth0 using the environment config variables. A [login page](https://auth0.com/docs/hosted-pages/login) will be shown to the user and they can then authenticate.

> **Note:** If it's the user's first visit to our app _and_ our callback is on `localhost`, they'll also be presented with a consent screen where they can grant access to our API. A first party client on a non-localhost domain would be highly trusted, so the consent dialog would not be presented in this case. You can modify this by editing your [Auth0 Dashboard API](https://manage.auth0.com/#/apis) **Settings**. Look for the "Allow Skipping User Consent" toggle.

We'll receive `accessToken`, `expiresIn`, and `idTokenPayload` in the URL hash from Auth0 when returning to our app after authenticating at the [login page](https://auth0.com/docs/hosted-pages/login). The `handleLoginCallback()` method subscribes to the `parseHash$` observable to stream authentication data (`_setSession()`) by emitting values for the `tokenData$` and `userProfile$` behavior subjects. This way, any subscribed components in the app are informed that the authentication and user data has been updated. The `_authFlag` is also set to `true` and stored in local storage so if the user returns to the app later, we can check whether to ask the authorization server for a fresh token. Essentially, the flag serves to tell the authorization server, "This app _thinks_ this user is authenticated. If they are, give me their data." We check the status of the flag in local storage with the accessor method `authenticated`.

> **Note:** The user profile data takes the shape defined by [OpenID standard claims](https://openid.net/specs/openid-connect-core-1_0.html#StandardClaims).

The `renewAuth()` method, if the `_authFlag` is `true`, subscribes to the `checkSession$` observable to ask the authorization server if the user is indeed authorized. If they are, fresh authentication data is returned and we'll run the `_setSession()` method to update the necessary behavior subjects in our app. If the user is _not_ authorized with Auth0, the `_authFlag` is removed and the user will be redirected to the URL we set as the authentication failure location.

Next, we have a `logout()` method that sets the `_authFlag` to `false` and logs out of the authentication session on Auth0's server. The [Auth0 `logout()` method](https://auth0.com/docs/libraries/auth0js/v9#logout) then redirects back to the location we set as our `logoutUrl`.

Once [`AuthService` is provided in `app.module.ts`](https://github.com/auth0-blog/angular-auth0-aside/blob/master/src/app/app.module.ts#L28), its methods and properties can be used anywhere in our app, such as the [home component](https://github.com/auth0-blog/angular-auth0-aside/tree/master/src/app/home).

### Callback Component

The [callback component](https://github.com/auth0-blog/angular-auth0-aside/tree/master/src/app/pages/callback.component.ts) is where the app is redirected after authentication. This component simply shows a loading message until the login process is completed. It executes the authentication service's `handleLoginCallback()` method to parse the hash and extract authentication information.

```js
// src/app/callback/callback.component.ts
import { Component, OnInit } from '@angular/core';
import { AuthService } from '../auth/auth.service';

@Component({
  selector: 'app-callback',
  template: `<div>Loading...</div>`,
  styles: []
})
export class CallbackComponent implements OnInit {
  constructor(private auth: AuthService) { }

  ngOnInit() {
    this.auth.handleLoginCallback();
  }

}
```

### Making Authenticated API Requests

In order to make authenticated HTTP requests, it's necessary to add an `Authorization` header with the access token in our [`api.service.ts` file](https://github.com/auth0-blog/angular-auth0-aside/blob/master/src/app/api.service.ts#L20).

```js
// src/app/api.service.ts
  ...
  getDragons$(accessToken: string): Observable<any[]> {
    return this.http
      .get<any[]>(`${this.baseUrl}dragons`, {
        headers: new HttpHeaders().set(
          'Authorization', `Bearer ${accessToken}`
        )
      })
      .pipe(
        catchError(this._handleError)
      );
  }
  ...
```

Now when we use `getDragons$()`, we can pass the access token to the method.

The [Homepage class](https://github.com/auth0-blog/angular-auth0-aside/blob/master/src/app/pages/home/home.component.ts) of our sample app subscribes to the `tokenData$` behavior subject. Once it has an access token, it can pass this to the `getDragons$()` API method to return and subscribe to the HTTP observable and retrieve the dragons data.

### Final Touches: Route Guard and Profile Page

A [profile page component](https://github.com/auth0-blog/angular-auth0-aside/tree/master/src/app/pages/profile) can show an authenticated user's profile information. However, we only want this component to be accessible if the user is logged in.

With an authenticated API request and login/logout [implemented in the Home component](https://github.com/auth0-blog/angular-auth0-aside/blob/master/src/app/pages/home), the final touch is to protect our profile route from unauthorized access. The [`auth.guard.ts` route guard](https://github.com/auth0-blog/angular-auth0-aside/blob/master/src/app/auth/auth.guard.ts) can check authentication and activate routes conditionally. The guard is implemented on specific routes of our choosing in the [`app-routing.module.ts` file](https://github.com/auth0-blog/angular-auth0-aside/blob/master/src/app/app-routing.module.ts#L24) like so:

```js
// src/app/app-routing.module.ts
...
import { AuthGuard } from './auth/auth.guard';
...
      {
        path: 'profile',
        component: ProfileComponent,
        canActivate: [
          AuthGuard
        ]
      },
...
```

### More Resources

That's it! We have an authenticated Node API and Angular application with login, logout, profile information, and a protected route. To learn more, check out the following resources:

* [Why You Should Always Use Access Tokens to Secure an API](https://auth0.com/blog/why-should-use-accesstokens-to-secure-an-api/)
* [Navigating RS256 and JWKS](https://auth0.com/blog/navigating-rs256-and-jwks/)
* [Access Token](https://auth0.com/docs/tokens/access-token)
* [Verify Access Tokens](https://auth0.com/docs/api-auth/tutorials/verify-access-token)
* [Call APIs from Client-side Web Apps](https://auth0.com/docs/api-auth/grant/implicit)
* [How to implement the Implicit Grant](https://auth0.com/docs/api-auth/tutorials/implicit-grant)
* [Auth0.js Documentation](https://auth0.com/docs/libraries/auth0js)
* [OpenID Standard Claims](https://openid.net/specs/openid-connect-core-1_0.html#StandardClaims)
