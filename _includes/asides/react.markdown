## Aside: Securing React Apps with Auth0

As you will learn in this section, you can easily secure your React applications with Auth0, a global leader in Identity-as-a-Service (IDaaS) that provides thousands of enterprise customers with modern identity solutions. Alongside with the classic [username and password authentication process](https://auth0.com/docs/connections/database), Auth0 allows you to add features like [Social Login](https://auth0.com/learn/social-login/), [Multifactor Authentication](https://auth0.com/docs/multifactor-authentication), [Passwordless Login](https://auth0.com/passwordless), and [much more](https://auth0.com/docs/getting-started/overview) with just a few clicks.

To follow along the instruction describe here, you will need an Auth0 account. If you don't have one yet, now is a good time to <a href="https://auth0.com/signup" data-amp-replace="CLIENT_ID" data-amp-addparams="anonId=CLIENT_ID(cid-scope-cookie-fallback-name)">sign up for a free Auth0 account</a>.

### Setting Up an Auth0 Application

To represent your React application in your Auth0 account, you will need to create an [Auth0 Application](https://auth0.com/docs/applications). So, head to [the Applications section on your Auth0 dashboard](https://manage.auth0.com/#/applications) and proceed as follows:

1. click on the [_Create Application_](https://manage.auth0.com/#/applications/create) button;
2. then define a name to your new application (e.g., "React Demo");
3. then select _Single Page Web Applications_ as its type.
4. and hit the _Create_ button to end the process.

After creating your application, Auth0 will redirect you to its _Quick Start_ tab. From there, you will have to click on the _Settings_ tab to whitelist some URLs that Auth0 can call after the authentication process. This is a security measure implemented by Auth0 to avoid leaking of sensitive data (like [ID Tokens](https://auth0.com/docs/tokens/id-token)).

So, when you arrive at the _Settings_ tab, search for the _Allowed Callback URLs_ field and add `http://localhost:3000/callback` into it. For this tutorial, this single URL will suffice.

That's it! From the Auth0 perspective, you are good to go and can start securing your React application.

### Dependencies and Setup

To secure your React application with Auth0, there are only two dependencies that you will need to install: [`auth0.js`](https://github.com/auth0/auth0.js) and [`history`](https://github.com/ReactTraining/history). To install these dependencies, move into your project root and issue the following command:

```bash
npm install --save auth0-js history
```

> **Note:** As you want the best security available, you are going to rely on the [Auth0 login page](https://auth0.com/docs/hosted-pages/login). This method consists of redirecting users to a login page hosted by Auth0 that is easily customizable right from the [Dashboard](https://manage.auth0.com/). If you want to learn why this is the best approach, check [the _Universal vs. Embedded Login_ article](https://auth0.com/docs/guides/login/universal-vs-embedded).

After installing `auth0-js` and `history`, you can create an authentication service to handle the process. You can call this service `Auth` and create it in the `src/Auth/` directory with the following code:

```js
import history from '../history';
import auth0 from 'auth0-js';

export default class Auth {
  constructor(props) {
    super(props);

    this.auth0 = new auth0.WebAuth({
      // the following three lines MUST be updated
      domain: '<AUTH0_DOMAIN>',
      audience: 'https://<AUTH0_DOMAIN>/userinfo',
      clientID: '<AUTH0_CLIENT_ID>',
      redirectUri: 'http://localhost:3000/callback',
      responseType: 'token id_token',
      scope: 'openid'
    });

    this.isAuthenticated = this.isAuthenticated.bind(this);
    this.handleAuthentication = this.handleAuthentication.bind(this);
    this.login = this.login.bind(this);
    this.logout = this.logout.bind(this);
    this.setSession = this.setSession.bind(this);
  }

  handleAuthentication() {
    this.auth0.parseHash((err, authResult) => {
      if (authResult && authResult.idToken) {
        this.setSession(authResult);
        history.replace('/home');
      } else if (err) {
        history.replace('/home');
        console.log(err);
      }
    });
  }

  setSession(authResult) {
    this.idToken = authResult.idToken;
    // set the time that the id token will expire at
    this.expiresAt = authResult.expiresIn * 1000 + new Date().getTime();
    // navigate to the home route
    history.replace('/home');
  }

  login() {
    this.auth0.authorize();
  }

  logout() {
    // clear id token and expiration
    this.idToken = null;
    this.expiresAt = null;
    // navigate to the home route
    history.replace('/home');
  }

  isAuthenticated() {
    return new Date().getTime() < this.expiresAt;
  }
}
```

The `Auth` service that you just created contains functions to deal with different steps of the sign in/sign up process. The following list briefly summarizes these functions and what they do:

- `handleAuthentication`: This function looks for the result of the authentication process in the URL hash. Then, process the result with the `parseHash` method from `auth0-js`.
- `setSession`: This function sets the user's access token and the access token's expiry time.
- `login`: This function initiates the login process, redirecting users to the login page.
- `logout`: This function removes the user's tokens and expiry time from browser storage.
- `isAuthenticated`: This function checks whether the expiry time for the user's access token has passed.

Besides these functions, the class contains a field called `auth0` that is initialized with values extracted from your Auth0 application. It is important to keep in mind that you **have to** replace the `<AUTH0_DOMAIN>` and `<AUTH0_CLIENT_ID>` placeholders that you are passing to the `auth0` field.

Attentive readers will probably notice that the `Auth` service also imports a module called `history` that you defined yet. This module is actually pretty simple, and you can define it in only two lines. You could also create it inside the `Auth` service, however, to provide reusability, you will create in a module of its own.

So, create a file called `./src/history.js` and add the following code to it:

```js
import createHistory from 'history/createBrowserHistory'

export default createHistory()
```

After creating the `createHistory` and the `Auth` services, you can refactor your `App` component to integrate everything together.

```jsx
import React, { Component } from 'react';
import history from '../history';
import './App.css';

class App extends Component {
  // ... constructor definition ...

  goTo(route) {
    history.replace(`/${route}`)
  }

  login() {
    this.props.auth.login();
  }

  logout() {
    this.props.auth.logout();
  }

  render() {
    const { isAuthenticated } = this.props.auth;

    // ... render the view
  }
}

export default App;
```

Note that you are passing the `Auth` service through `props` to `App`. As such, when including the `App` component, you need to inject `Auth` into it: `<App auth={auth} />`.

Considering that you are using the Auth0 login page, your users are taken away from the application. However, after they authenticate, users automatically return to the callback URL that you set up previously (i.e., `http://localhost:3000/callback`). This means that you need to create a component responsible for this URL.

So, create a new file called `Callback.js` inside the `src` directory and insert the following code into it:

```jsx
import React, { Component } from 'react';

class Callback extends Component {
  render() {
    return (
      <div>
        Loading user profile.
      </div>
    );
  }
}

export default Callback;
```

This component can just contain a loading indicator that keeps spinning while the application sets up a client-side session for the users. After the session is set up, your app redirects users to another route (in this case, to `/home`).

If you are interested in learning more, please, refer to [the official React Quick Start Guide](https://auth0.com/docs/quickstart/spa/react/01-login) to see, step by step, how to properly secure a React application. Besides the steps shown in this section, the guide also shows:

- [How to manage profile information of authenticated users](https://auth0.com/docs/quickstart/spa/react/02-user-profile).
- [How to properly call an API](https://auth0.com/docs/quickstart/spa/react/03-calling-an-api).
- [How to control which routes users can see/interact with](https://auth0.com/docs/quickstart/spa/react/04-authorization).
- [How to deal with expiry time of users' access token](https://auth0.com/docs/quickstart/spa/react/05-token-renewal).
