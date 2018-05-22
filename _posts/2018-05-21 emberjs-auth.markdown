---

layout: post
title: "EmberJS with Authentication"
description: "Building an EmberJS application with Auth0"
date: 2018-05-17 15:03
category: Technical Guide, FrontEnd, Ember
author: 
name: "Sarah Jorgenson"

---

# EmberJS with Authentication

Quickly learn how to build ambitious EmberJS 3 apps with authentication and feel comfortable doing it.

**TL;DR:** Let’s dive into the world of **EmberJS**, a framework built so that we all can be more productive as developers. Easy to jump in to and easy to get started with, EmberJS is a great framework to know and understand. In this tutorial, we will be building an application using EmberJS 3 and then add some **trusty authentication** to it. You can find the repo [here](https://github.com/SarahJay55/emberJS-auth) to get the code from this tutorial. 

## EmberJS

But which framework should I use? Which one would be best for me and my project? We get it, there are tons to choose from.  Let’s take some time and let’s learn more about the powerful framework we like to call, EmberJS.  

We have the new EmberJS 3.0 that was released February 14, 2018. There were not any functionality concepts added, instead the Ember team honed in on making the framework cleaner and more focused.  You will not have to deal with long-deprecated APIs anymore but you will see support for those legacy platforms. If you are already familiar with EmberJS 2.0, EmberJS 3.0 should be just fine.

**But Who Should Use It?**

Are you looking for a everything-included type framework? One that you do not have to be plugging in multiple libraries to make things work? Ember might be for you then. It may save lots of time so you are not looking around, trying to make things fit just right. Let EmberJS do that work for you, you just start building those beautiful apps!

## The Five Key Concepts

Who here as worked with AngularJS? ReactJS? VueJS? Well then, this might look very familiar to you! EmberJS will be very easy to understand and you’ll be making apps in no time! Do these things look familiar?

  1. Routes - Being URL based, the route allows for application browsing based on the URL.
  2. Models - Objects that equate the data that your application shows in the user's view.
  3. Templates - Using Handlebar Templating, it contains the HTML for the application.
  4. Components - A template that defines how it will look and a JavaScript source file that defines how it will behave.
  5. Controllers - Behaves like a specialized type of Component that is rendered by the router when entering a Route.

These are the five key concepts when using EmberJS. It also provides many other things, but knowing and understanding these main five, you will be off to a good start.  

## Let’s Build!

We are going to be building an application that uses authentication and authorization to jump into a mock bank account. Numbers won’t be real, don’t worry, we’ll use some JavaScript to generate a random number. And we need some strong authorization to keep our bank accounts safe.  

What will our app do?

1. User sees a nav-bar with a log-in button
2. User logs in with their credentials via Auth0
3. User sees their name in the nav-bar and randomly generated bank account balance (if only we could keep the balances that randomly generate to 1,000,000).
4. Log-out button next to the name in the nav-bar

Now in EmberJS, whenever you want to generate a new file, all you need to do is type in 

`ember generate (what you want to do) and (what you want to call it)` 

For example, say I want to create a new route, I would type in to my command line, 

```bash
ember generate route login
```

That would create a routing file named `login`. Within your `app` file, you’ll see in the route folder, a new file named `login`. As we create this app, you will see those commands, EmberJS makes it easy for us to organize and create files. You will need to generate each file you need. But if you generate a component, Ember will automatically generate a component in the template file as well. If you generate a route, then Ember will automatically generate a template for that route. It is convenient for file building but be aware of it, you will not want to be adding extra files that Ember has already generated for you.

### Styling

For styling, we will be using [Bulma](https://bulma.io/) styling in today's app. Insert the bulma link tag into our index.html so we can use that styling throughout our application.

//emberJS-auth/app/index.html
```html
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.6.2/css/bulma.min.css">
```

## EmberCLI and Setup

The ember-cli is an awesome tool that allows you to do a lot of app building within the command line. We will need the ember-cli global on our machine so open up your command line and let’s type in:

```bash
npm install -g ember-cli
```

Once that is done, let’s get a EmberJS app started! We will be making a login feature that takes us to a faux bank account. To get this going all you have to do is type in:

```bash
ember new emberJS-auth
```

Sit back and relax, Ember will be taking care of a lot of stuff right now. Once it has completed, let’s cd into that new directory 

```bash
cd emberJS-auth
```

and then in that run:

```bash
ember serve
```

to get the app started up in your browser. You can find it on http://localhost:4200 if it does not pop up right away. Once you see this home page, you are ready to go:

![Imgur](https://i.imgur.com/y48FR0N.png)

Your EmberJS application is ready to use!

## Setting Up Auth0

Let's step away from our code for a second and go to Auth0.com where we will login. Once logged in, you will want to create a new single-page application so that we can have access to some very important information.  

![Imgur](https://i.imgur.com/vWKlddm.png)

![Imgur](https://i.imgur.com/6jxobLc.png)

We will be generating a couple of things that we will need in our application under Settings. We will not be needing them right this second but soon. Keep those two things close by! (aka, don't close the tab) :)

1. Domain - example.auth0.com
2. Client ID - a string of random numbers and letters
3. Callback URL - http://localhost:4200/callback

> Note! Do not forget to set your callback URL.  The callback URL is there so once the authentication goes through successfully, Auth0 will redirect the user to the proper page.

![Imgur](https://i.imgur.com/1y32iKn.png)

## Auth0 Install

Now let's go back to our app and install our Auth0 library. Just go into the command line of the project and type: 

```bash
npm install --save auth0-js
```

What this is doing is it is giving you the correct Auth0 library and putting in your dependencies list in your package.json file. 

![Imgur](https://i.imgur.com/3nx0d8d.png)

### Authentication with Auth0

Auth0 provides two types of authentication, Universal and Embedded. Today we will be using Universal login. It is the easiest, most secure way to have authentication within your application. Here at Auth0, we recommend using the Universal login. You will feel at ease knowing you have our highest level of security protecting your users information.

But what are the differences between Universal and Embedded? Universal authentication uses a central domain when the user wants to log in. No matter where you are in the applicaton, the authentication happens in one spot, and they are always redirected to the central domain. Whereas in Embedded authentication, the user is not redirected, instead they are authroized right there, on that individual domain. There are pros and cons to both, you can learn more about these types of login [here](https://auth0.com/docs/guides/login/universal-vs-embedded).

## Services in Ember

According to the EmberJS docs themselves, "an Ember.Service is an Ember object that lives for the duration of the application, and can be made available in different parts of your application." Let's let that one soak in for a bit. This reminds me of Redux in React maybe? An application-wide state? The information that goes into this file, all files can see! This file loves to share. But to go along with that it also keeps that information alive while the user is using the application. The data is saved and saved and saved until, boom, they log out and "reset" the service.

> Something an EmberJS Service would be good for would be things like geolocation, third-party APIs, or user authentication.  

In your command line type:

```bash
ember generate service auth
```

Here, in this newly created file, we will insert all of our logic for getting a session, logging in, logging out, and everything associated with authentication. For example, let's dive into the `getSession()`. In here, it will grab all the necessary authentication pieces that are required for a successful login. We will need the `access_token`, the `id_token`, and finally the `expires_at` value. With all three of these, they application will know that they are good to move on to the protected pages in the app.

//emberJS-auth/app/services/auth.js
```javascript
import Service from '@ember/service';
import { computed, get } from '@ember/object';
import config from 'emberJS-auth/config/environment';
import { isPresent } from '@ember/utils';

export default Service.extend({

  /**
   * Configure our auth0 instance
   */
  auth0: computed(function () {
    return new auth0.WebAuth({
      domain: config.auth0.domain, // domain from auth0
      clientID: config.auth0.clientId, // clientId from auth0
      redirectUri: 'http://localhost:4200/callback',
      audience: `https://${config.auth0.domain}/userinfo`,
      responseType: 'token id_token',
      scope: 'openid profile' // adding profile because we want username, given_name, etc
    });
  }),

  /**
   * Send a user over to the hosted auth0 login page
   */
  login() {
    get(this, 'auth0').authorize();

  },

  /**
   * When a user lands back on our application
   * Parse the hash and store access_token, id_token, expires_at in localStorage
   */
  handleAuthentication() {
    return new Promise((resolve, reject) => {
      this.get('auth0').parseHash((err, authResult) => {
        if (authResult && authResult.accessToken && authResult.idToken) {

          // store magic stuff into localStorage
          this.setSession(authResult);
        } else if (err) {
          return reject(err);
        }

        return resolve();
      });
    });
  },

  /**
   * Use our access_token to hit the auth0 API to get a user's information
   * If you want more information, add to the scopes when configuring auth.WebAuth({ })
   */
  getUserInfo() {
    return new Promise((resolve, reject) => {
      const accessToken = localStorage.getItem('access_token');
      if (!accessToken) return reject();

      return this
        .get('auth0')
        .client
        .userInfo(accessToken, (err, profile) => resolve(profile))
    });
  },

  /**
   * Computed to tell if a user is logged in or not
   * @return boolean
   */
  isAuthenticated: computed(function() {
    return isPresent(this.getSession().access_token) && this.isNotExpired();
  }).volatile(),

  /**
   * Returns all necessary authentication parts
   */
  getSession() {
    return {
      access_token: localStorage.getItem('access_token'),
      id_token: localStorage.getItem('id_token'),
      expires_at: localStorage.getItem('expires_at')
    };
  },

  /**
   * Store everything we need in localStorage to authenticate this user
   */
  setSession(authResult) {
    if (authResult && authResult.accessToken && authResult.idToken) {
      // Set the time that the access token will expire at
      let expiresAt = JSON.stringify((authResult.expiresIn * 1000) + new Date().getTime());
      localStorage.setItem('access_token', authResult.accessToken);
      localStorage.setItem('id_token', authResult.idToken);
      localStorage.setItem('expires_at', expiresAt);
      window.location.replace('/dashboard')
    }
  },

  /**
   * Get rid of everything in localStorage that identifies this user
   */
  logout() {
    localStorage.removeItem('access_token');
    localStorage.removeItem('id_token');
    localStorage.removeItem('expires_at');
    window.location.replace('/')
  },

  /**
   * Check whether the current time is past the access token's expiry time
   */
  isNotExpired() {
    const expiresAt = this.getSession().expires_at;
    return new Date().getTime() < expiresAt;
  }
});

```

In the section that looks like this:

```javascript
auth0: computed(function () {
    return new auth0.WebAuth({
      domain: config.auth0.domain, // domain from auth0
      clientID: config.auth0.clientId, // clientId from auth0
      redirectUri: 'http://localhost:4200/callback',
      audience: `https://${config.auth0.domain}/userinfo`,
      responseType: 'token id_token',
      scope: 'openid profile' // adding profile because we want username, given_name, etc
    });
  }),
 ```

you will want to your own credentials from your Auth0 account. That tab you still have open, yeah, let's go back to that and grab that information. In a "secret" file, you will be inputting those values and then .gitignore that file.

What you can do is in the config folder within your project you can create an `auth0-variables.js` file that can contain your auth0 secure information. It can look something like this:

```javascript
module.exports = {
  clientId: 'id goes here',
  domain: 'domain goes here',
  callbackUrl: 'callback url goes here'
}
```

Then in the `config/environment.js` file, you can call for those variables. Like so

//emberJS-auth/config/environment.js
```javascript
const AUTH_CONFIG = require('./auth0-variables');


ENV.auth0 = {
    clientId: AUTH_CONFIG.clientId,
    domain: AUTH_CONFIG.domain,
    callbackUrl: AUTH_CONFIG.callbackUrl,
    audience: AUTH_CONFIG.apiUrl
  }
```

You can declare these variable however you want, just make sure it is in a file that you .gitignore so that once you push it to github, your secret keys will not be exposed to the world.

### Adding a Global Dependency

The library `auth0-js` needs to be added to a different file in the project. In your `ember-cli-build.js` you will add this line `app.import('node_modules/auth0-js/build/auth0.js');`

//emberJS-auth/ember-cli-build.js
```javascript
'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  let app = new EmberApp(defaults, {
    // Add options here
  });

  app.import('node_modules/auth0-js/build/auth0.js');

  return app.toTree();
};
```

>Do not be alarmed, I know this is not how React or many other frameworks do it. Why not import it in the top of the file? In Ember, some dependies will need to be added to the build so that it can be used across the application. You can find the documentation for that here: https://guides.emberjs.com/v3.1.0/addons-and-dependencies/managing-dependencies/

## Each Route Needs to Be Declared

In our `app/router.js` file we need to declare what routes we are going to have. We have the standard '/' route but we will need to be able to tell the application what other routes we will be using. So go to your `app/router.js` file and input the information as shown

//emberJS-auth/app/router.js
```javascript
import EmberRouter from '@ember/routing/router';
import config from './config/environment';

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('dashboard');
  this.route('callback');
});

export default Router;
```

## The Application Route

We are going to need an all encompassing route. It won't do much except be the route that is the head parent. It is there to usually handle routing for the entire application but because we have declared routing elsewhere, this will not have that logic. Although we do need to keep it. So ensure you have built your application route.

```bash
ember generate route application
```

```javascript
import Route from '@ember/routing/route';

export default Route.extend({
});
```

## Building a Functional Nav Bar

Our nav-bar will have our login button. Once logged in and user has been authenticated, that login button will change to the user's name and the logout button. Let's look at our navbar code. We will need a couple of files generated in order to get it all working. Let's start with the component app-nav.

```bash
ember generate component app-nav
```

> Note! When naming components in Ember, you must have a `-` somewhere in the name. That is how Ember knows this file is a component.

Within the file, let's add

//emberJS-auth/app/components/app-nav.js
```javascript
import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  auth: service('auth'),
  actions: {
  
    /**
   * From service/auth, starting the login process
   */
    login() {
      this.get('auth').login();
    },
    
    /**
   * From service/auth, removing all the save tokens from the session.
   */
    logout() {
      this.get('auth').logout();
    }
  }
});
```

We have the functions from the 'auth' service, `login` and `logout` that will help those buttons do the right thing! In the template folder, we will want to create another folder called `component` and within that, create a file call `app-nav.js`. The code in there will look something like this

//emberJS-auth/app/templates/components/app-nav.hbs
```javascript
<nav class="navbar is-danger">
  <div class="navbar-brand">
    <a class="navbar-item" href="/dashboard">
      <p width="112" height="28">Bank Home</p>
    </a>
  </div>

  <div class="navbar-menu">
    <div class="navbar-start">
    </div>

    <div class="navbar-end">
      {{#if user}}
      <a class="navbar-item">{{user.given_name}} {{isAuthenticated}}</a>
      <button {{ action "logout" }} class="button is-primary">Log out</button>
      {{ else }}

      <p class="control">
        <a class="button is-primary" href="#" {{action "login"}}>
          Login
        </a>
      </p>
      {{/if}}
    </div>
  </div>
</nav>
```

You will see here that when the user first visits the page, they will see on the nav-bar a `Bank Home` title and a `Login` button. Once logged in, it changes to their name and `Logout` button. A nice, clean toggle between the two.

Now that we have the buttons ready for us, let's set up our authentication so those buttons know, "Hey, they are authenticated, let's let them pass to the dashboard!"

## Building Our All-Encompassing App

We will want to add another controller titled `application`. The application controller will be using the auth service file to keep our user logged in and authenticated. So image it is the parent component to the dashboard. It is wrapping itself around the entire application. So while the user is in the dashboard, logged in, the application controller will ensure they keep that authenticated status.

```bash
ember generate controller application
```

In there the code should be

//emberJS-auth/app/controllers/application.js
```javascript
import Controller from '@ember/controller';
import { inject as service } from '@ember/service';

export default Controller.extend({
  auth: service(),
  init() {
    this._super(...arguments);
    this.set('isAuthenticated', this.get('auth').isAuthenticated);
    this.get('auth').getUserInfo().then(user => this.set('user', user));
  }
});
```

Using functions from the auth service, this will allow the authentication to actually fire off. And then to match up with the controller, the application template will have code that will show what the user needs to see.

//emberJS-auth/app/templates/application.hbs
```javascript
{{app-nav user=user }}

<main>
  {{outlet}}
</main>
```

## Handling Authentication

We are going to help the application know what to do once the authentication process takes place. So if we look at our handleAuthentication function in our auth services file, you'll see that we will take in the accessToken and the idToken to then set the session. If these things are not passed through and we cannot properly handle the authentication, then this function being called will reject with an error. Here in our callback route, we will be using that function to allow for this to all take place.

Create the file

```bash
ember generate route callback
```

The information inside that file

//emberJS-auth/app/routes/callback.js
```javascript
import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import { get } from '@ember/object';

export default Route.extend({
  auth: service('auth'),
  beforeModel() {
    const auth = get(this, 'auth');

    auth
      .handleAuthentication() // stores access_token, id_token, expires_at in localStorage
      .then(() => {

        // if (get(this, 'auth.isAuthenticated')) {
        //   this.transitionTo('dashboard')
        // }

        this.transitionTo('/dashboard');
      });
  },
});
```

## Adding an Authenticated Dashboard

The user, once authenticated needs to be re-directed to the dashboard, how about we go and get that set up now as well. In our dashboard we will see the `login` button change to the users name and the `logout` button and also a randomly number that show's their faux bank account balance. Because we want that number safe and secure, right?

Create a controller for the dashboard and also a template. 

```bash
ember generate controller dashboard
```
```bash
ember generate template dashboard
```

The controller will have the logic, the template will have the view of that logic for the user.

Your dashboard controller should look like so

//emberJS-auth/app/controllers/dashboard.js
```javascript
import Controller from '@ember/controller';

export default Controller.extend({
  // bank: service(), // get fake data
  init() {
    this._super(...arguments);


    // banking data
    this.set('balance', this.bankBalance());
  },
  bankBalance() {
    // get real data from a bank here
    // this.get('bank').getBankBalance();

    // or spoof it like this
    return "$" + Math.floor((Math.random() + 1) * 10000) + ".00";
  }
});
```

And the template for the dashboard should be something like this.

//emberJS-auth/app/templates/dashboard.hbs
```javascript
<section class="hero is-medium is-primary is-bold is-fullheight has-text-centered">
  <div class="hero-body">
    <div class="container">
      <h1 class="title is-size-1">
        Your Bank Balance
      </h1>
      <h2 class="subtitle is-size-3">
        {{balance}}
        {{model.user}}
      </h2>
    </div>
  </div>
</section>
```

Remember, the template is what the user is seeing. So they see the words "Your Bank Balance" and then the balance underneath it. You also see that we are using Bulma classes here to give it a simple styling. 

> Note! The stuff that happens on the dashboard can be whatever you want! We just want to make sure that the user is authenticated before they get to a protected page. And in this example, it is a faux bank account balance with a randomly generated number.

We will need to also create a dashboard route. 

```bash
ember generate route dashboard
```

There we will put the logic so that if they try and access the dashboard without being authenticated, it will send them back to the home screen with the login button. Can you imagine if the user was able to type in `yoururl.com/dashboard` and see the bank account balance without having to be authenticated first? In this `route/dashboard` file, the user is checked by the application. If they are not authenticated, then they will transition to the base URL. This keeps things safe and sound.

//emberJS-auth/app/routes/dashboard.js
```javascript
import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

export default Route.extend({
  auth: service('auth'),
  beforeModel() {
    // this is where we check if a user is authenticated
    // if not authenticated, kick them to the home page
    if (!this.auth.isAuthenticated) {
      this.transitionTo('/');
    }
  },
  model() {
    user: this.get('auth').currentUser
  }
});
```

Now the user is logged in and authenticated and will see a large, randomly generated number. You can of course change the size of that number so your user sees large or smaller numbers.

## Local Storage Check

If you look in your local storage, you will see a key stored in there for the current session. Once logged in, check to see if that key is there. It will be a randomly generated string, but if you have that, you know the authenticated went through and it is being stored correctly. You just built yourself a secure EmberJS application!

## The Banking Application

Now that it is all set up, let's use the application. The user will come to the site, and see this navbar.

![Imgur](https://i.imgur.com/6wseHTX.png)

Once they click on `Login`, they will get redirected to the Auth0 modal.

![Imgur](https://i.imgur.com/1ErPfYG.png?1)

If authentication goes through, they will be redirected to the dashboard showing them their name, a `Logout` button, and a randomly generated bank account balance. Once they hit logout, they will loose their authentication and be redirected back to the login screen.

![Imgur](https://i.imgur.com/rH2kmO5.png)


## Conclusion 

This application tutorial was to get you started with Authentication in EmberJS. You should now have a successfully built application. The magic that happens after the login can be whatever you want. EmberJS although easy to get running, has a learning curve that can be quite steep. It requires a lot of different files talking to each other in order for one thing to fire off. But once you start using it and building with it, you will start to see the flow clearly. 

>Try visiting the site incognito, you will see there that you will not be able to visit the dashboard page without first being authenticated!

#### Auth0

Using the powerful tool of Auth0 allows for that worry-free authentication. You, as a developer, can rest assured that your users and your application are backed by a strong force of security.
