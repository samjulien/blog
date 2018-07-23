---
layout: post
title: "TypeScript from Top to Bottom - Part 2: Developing the Angular App"
description: "Learn how to use TypeScript to create a full-stack web application with Angular and Nest.js"
date: "2018-08-01 08:30"
category: Technical Guide, Node.js, Nest.js
author:
  name: "Ana Ribeiro"
  url: "https://twitter.com/anacosri"
  mail: "aninhacostaribeiro@gmail.com"
  avatar: "https://cdn.auth0.com/blog/guest-authors/ana-ribeiro.jpg"
design:
  bg_color: "#003A60"
  image: "https://cdn.auth0.com/blog/typescript-intro/typescript-logo.png"
tags:
- typescript
- angular
- nest
- auth0
- full-stack
- frontend
- backend
related:
- 2018-07-31-typescript-from-top-to-bottom-part-1-developing-an-api-with-nestjs.markdown
- 2017-10-31-typescript-practical-introduction.markdown
---

**TL;DR:** This is a small series on how to build a full-stack TypeScript application using Angular and Nest.js. In the first part, you learnt how to build a simple API with Nest.js. In this second part, you are going to learn how to use Angular to build the frontend application that communicates with Nest.js. [You can find the final code developed throughout this article in this GitHub repository](https://github.com/auth0-blog/).

## Summarizing part 1

In part 1, you learnt why you should use [Angular](https://angular.io/) together [Nest.js](https://nestjs.com/) to create a full stack web Application using Typescript. 

Then, you created a Nest.js backend application that manages the menu of a restaurant, this API had 3 endpoints, one that was public (`GET /items`), another one that needed user's identification (`POST /shop-cart`) and the third one that need admin's authorization (`POST /items`). Let this API running, since you are going to use it in part 2 (the aim of the front end application is to be a web interface that interacts with this API). 

You also created an Auth0 API application, open the settings page of this application and leave this page open as you will need to copy _Domain_ and _Client ID_ to configure your front end application.

## Set up Angular

Here you are going to use [Angular CLI](https://github.com/angular/angular-cli) to start your application. Since you already installed Node and NPM in part 1, run the following command to install Angular CLI:

```bash
npm install -g @angular/cli # it will install Angular Cli
```

And then generate a new project by running the following command:

```bash
ng new angular-restaurant-front # angular-restaurant-front
```

After a while, it will generate a project with the following structure:

```bash
├── README.md
├── angular.json
├── package-lock.json
├── package.json
├── src
│   ├── app
│   │   ├── app.component.css
│   │   ├── app.component.html
│   │   ├── app.component.spec.ts
│   │   ├── app.component.ts
│   │   └── app.module.ts
│   ├── assets
│   ├── browserslist
│   ├── environments
│   │   ├── environment.prod.ts
│   │   └── environment.ts
│   ├── favicon.ico
│   ├── index.html
│   ├── karma.conf.js
│   ├── main.ts
│   ├── polyfills.ts
│   ├── styles.css
│   ├── test.ts
│   ├── tsconfig.app.json
│   ├── tsconfig.spec.json
│   └── tslint.json
├── tsconfig.json
└── tslint.json
```

The code that you are going to create will be located under the directory `src/app`, those files that have `spec` in their names are related to tests, and are going to be ignored in this tutorial. Detailed meaning of each file in this folder you can find in [Angular's documentation page](https://angular.io/guide/quickstart). To start this application, you must type the following on your terminal:

```bash
cd angular-restaurant-front # goes to your app's folder
ng serve --open # starts and open the angular app
```

After doing that, you will get a page like the following one on [localhost:4200](http://localhost:4200):

![Angular page](https://angular.io/generated/images/guide/cli-quickstart/app-works.png)

## Create a Static Angular App

First, you are going to create an angular app that doesn't interact with the backend application, and then you are going to add some integration to it.

### Installing dependencies

You are going to use [Twitter's Bootstrap](https://getbootstrap.com/) to give some style to your app (if you don't do that, your app will still work, but in an uglier way). To import bootstrap, go to your application's folder and run the following command:

```bash
npm install bootstrap
```

Then open the file `src/styles.css` and add the following line to it:

```css
@import "bootstrap/dist/css/bootstrap.css";
```

### Create an Angular Component to Show the Items

First, you are going to create the page where the user will see the items of the menu. First you need to create a component by typing the following command: 

```bash
ng generate component items
```

After that you will get a new folder `items` with 3 main files:

  * `items.component.css`: where you may add some local style for item's page;
  * `items.component.html`: as the name states, where you are going to add HTML code to structure the page;
  * `items.component.ts`: where you are going to place the logic related to this component.

Copy to this folder the `items.interface.ts` that you have developed in the part one of this tutorial, since the same interface is going to be used for handling data on frontend. Then open the `items.components.ts` and paste the following peace of code to it:

```typescript
import { Component, OnInit } from '@angular/core';
import { Item } from './item.interface';

@Component({
  selector: 'app-items',
  templateUrl: './items.component.html',
  styleUrls: ['./items.component.css']
})
export class ItemsComponent implements OnInit {
  items: Item [] = [{
    name: 'Pizza',
    price: 3
  },
  {
    name: 'Salad',
    price: 2
  }];
  constructor() { }

  addToCart() {
    window.alert('Added');
  }

  ngOnInit() {
  }
}

```
You are basically creating the items object there and a fake function to add items to shopping cart. The `@Component` annotation says that this class is a component, its selector says how this component is going to be called in a parent components, template and style are links to html and css files that refers to this component. The method `ngOnInit()` is going to be executed when the page is loading.

Now, you are going to add the code needed in the HTML page. Go to `items.component.html` and add the following code to it:

{% highlight html %}
<table class="table">
  <thead>
    <tr>
      <td>Name</td>
      <td>Price</td>
      <td>Action</td>
    </tr>
  </thead>
  <tbody>
    <tr *ngFor="let item of items"> <!--for every item in object items, create a table row-->
      <td>{% raw %}{{item.name }}{% endraw %}</td> <!--Write it's name in a column--> 
      <td>{% raw %}${{item.price}}{% endraw %}</td> <!--Write it's price in a column--> 
      <td>
        <button class="btn btn-default"
                (click)="addToCart()">
          Add to shopping cart
        </button>
      </td>
    </tr> 
  </tbody>
</table>
{% endhighlight %}

The code above is basically a HTML table with Angular directive `*ngFor` for the `<tr>` tag. This element saying that for every item in the object `items` there should be a table row containing columns with the name of the item, it's price and button which is for add this product to a shop cart. 

Now you should call the component you have just created in the `src/app/app.component.html` file, just delete the code automatically generated there and add the following line of code:

{% highlight html %}
<app-items></app-items>
{% endhighlight %}

And then visit again [localhost:4200](http://localhost:4200) and if everything was done correctly, you will get a page like the following one:
 
![Table of items](https://screenshotscdn.firefoxusercontent.com/images/b1f3a4fd-2e79-4d04-a158-07e220d8dd1d.png)

### Create a Reactive Angular Form to Add New Items

Now you are going to create a form to add new items to your `items` object. For doing that, you are going to use Angular's Reactive form, which creates a object for the form and makes it easy to validate and test the form. To do that, first add Angular's form component to you `app.module.ts` file (this file is used for importing libraries), that will look like that after the addition:

```typescript
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';
import { ItemsComponent } from './items/items.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HeaderComponent } from './header/header.component';

@NgModule({
  declarations: [
    AppComponent,
    ItemsComponent,
    HeaderComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [ AppComponent ]
})
export class AppModule { }
```
Then, you should add some code to your `items.component.ts` (_note_: you could create a new component called something like `itemsform` for that form, but to keep things shorter, everything in this tutorial related to items will be under the same component), there you are going to add a few properties to the class: `itemForm` of the type `formGroup` which is the form itself and `itemSubmitted` a boolean used for validation, you will also need a method for adding new items to the array. After adding that, your code will be like the following one:

```typescript
import { Component, OnInit } from '@angular/core';
import { Item } from './item.interface';
import { FormGroup, Validators, FormBuilder } from '@angular/forms';

@Component({
  selector: 'app-items',
  templateUrl: './items.component.html',
  styleUrls: ['./items.component.css']
})
export class ItemsComponent implements OnInit {
  items: Item [] = [{
    name: 'Pizza',
    price: 3
  },
  {
    name: 'Salad',
    price: 2
  }];
  itemSubmitted = false;
  itemForm: FormGroup;

  constructor(private formBuilder: FormBuilder) { }

  ngOnInit() {
    // Initiating the form with the fields and the required validators
    this.itemForm = this.formBuilder.group({
      name: ['', Validators.required], // Name is required
      price: ['', [Validators.required, Validators.min(0)]] // Price is required and must be a positive number
    });
  }

  get getItemForm() {
    return this.itemForm.controls;
  }

  addNewItem() {
    this.itemSubmitted = true;
    if (this.itemForm.invalid) {
      console.log(this.itemForm);
    } else {
      this.items.push(this.itemForm.value);
    }
  }
}

```

Now the file `items.component.html`, there you will add the HTML code that represents the form defined by `itemForm`, to do that add the following code to the bottom of the already existing code:

{% highlight html %}
...
<div>
  <h3 class="col-md-12">Add a new Item</h3>
  <form class="form-inline" (submit)="addNewItem()" [formGroup]="itemForm">
    <div class="col-auto">
      <input type="text" 
        class="form-control" 
        placeholder="Name" 
        formControlName="name" 
        [ngClass]="{ 'is-invalid': itemSubmitted && getItemForm.name.errors }" >
        <div *ngIf="itemSubmitted && getItemForm.name.errors" class="invalid-feedback">
          <div *ngIf="getItemForm.name.errors.required">Name is required</div>
        </div>
    </div>
    <div class="col-auto">
      <input type="number" 
        class="form-control" 
        placeholder="Price" 
        formControlName="price" 
        [ngClass]="{ 'is-invalid': itemSubmitted && getItemForm.price.errors }" >
        <div *ngIf="itemSubmitted && getItemForm.price.errors" class="invalid-feedback">
          <div *ngIf="getItemForm.price.errors.required">Price is required and must be a number</div>
          <div *ngIf="getItemForm.price.errors.min">Must start from 0</div>
        </div>
    </div>
    <div class="col-auto">
      <button type="submit" class="btn btn-primary mb-2">Add new item</button>
    </div>
  </form>
</div>
{% endhighlight %}

Now you can visit [localhost:4200](http://localhost:4200) again and get a page like the following one, you may play around and try to submit valid and invalid values:

![Table with form](https://screenshotscdn.firefoxusercontent.com/images/aaef632a-07c5-499a-ac55-c2d57d4f6408.png)

## Integrating Angular Apps with Auth0

Now you are going to create learn how to add authentication and authorization in your app using the Auth0 API you set up on the last tutorial.

### Installing the Dependencies

You will need to install `auth0-js` and `auth0/angular-jwt` in order to follow this tutorial. Run the following commands:

```bash
npm install auth0-js@latest # installs auth-0
npm install @auth0/angular-jwt # auth0/angular-jtw
```
### Create an Auth0 Angular Service

You will create a Angular service that interacts with Auth0 server to provide identification and authorization. If you have ever created a similar service using browser's `localstorage` before, here you are going to use a better strategy because you are not going to use browser's `localStorage` to store user's token, instead you are going to require a new token to Auth0 every time the page reloads, so you will make your application safer since when tokens were stored within the browsers could be stollen by any script running in the user's browser.

To create this service type run following command:

```bash
ng generate service auth/auth # creates auth.service.ts in auth directory
```
And then open the just created file `auth.service.ts` and paste the following code:

```typescript
import { Injectable } from '@angular/core';
import { AuthOptions, WebAuth } from 'auth0-js';
import { JwtHelperService } from '@auth0/angular-jwt';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  protected _auth0Client: WebAuth;
  private _accessToken: string;
  private _idToken: string;
  private _properties: AuthOptions;

  constructor() {
    this._properties = {
      clientID: '[CLIENT_ID]',
      domain: '[DOMAIN]',
      responseType: 'token id_token',
      audience: 'http://localhost:3000',
      redirectUri: 'http://localhost:4200/login',
      scope: 'openid profile'
    };
    this._auth0Client = new WebAuth({...this._properties});
  }

  public login(): void {
    // triggers auth0 authentication page
    this._auth0Client.authorize();
  }

  public checkSession(): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      // checks in Auth0's server if the browser has a session
      this._auth0Client.checkSession(this._properties, async (error, authResult) => {
        if (error && error.error !== 'login_required') {
          // some other error
          return reject(error);
        } else if (error) {
          // explicit authentication
          this.handleAuthentication();          
          return resolve(false);
        }
        if (!this.isAuthenticated()) {
          this._setSession(authResult);
          return resolve(true);
        }
      });
    });
  }

  public isAuthenticated(): boolean {
    // Check whether the current time is past the
    // Access Token's expiry time
    return this._accessToken != null;
  }

  private handleAuthentication(): void {
    this._auth0Client.parseHash((err, authResult) => {
      if (authResult && authResult.accessToken && authResult.idToken) {
        window.location.hash = '';
        this._setSession(authResult);
      } else if (err) {
        console.log(err);
      }
    });
  }

  private _setSession(authResult): void {
    this._accessToken = authResult.accessToken;
    this._idToken = authResult.idToken;
  }
  
  // check if there is a property Admin in access token
  public isAdmin(): boolean {
    if (this._accessToken) {
      const helper = new JwtHelperService();
      const decodedToken = helper.decodeToken(this._accessToken);
      if (decodedToken['http://localhost:3000/roles'].indexOf('admin') > -1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  public getProfile(): Object {
    if (this._idToken) {
      const helper = new JwtHelperService();
      return helper.decodeToken(this._idToken);
    }
  }

  public getAccessToken(): String {
    return this._accessToken;
  }

  public logout(): void {
    // Remove tokens
    delete this._accessToken;
    delete this._idToken;
  }
}
```

Don't forget to change your client id and your domain to those in your Auth0 page. Next you are going to understand in more details which every method of this class does. 

### Create an Angular Component for the Header 

You are going to create a header component for triggering the authentication component. To do that, create a component as you did a few paragraphs before called `header`, then open the file `header.component.ts` and copy the following code:

```typescript
import { Component, OnInit } from '@angular/core';
import { AuthService } from '../auth/auth.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {

  title = 'Food menu';

  constructor(private authService: AuthService) {
  }

  ngOnInit() {
  }

  isAuthenticated() {
    return this.authService.isAuthenticated();
  }

  login() {
    return this.authService.login();
  }

  logout() {
    return this.authService.logout();
  }

  getProfile() {
    return this.authService.getProfile();
  }
}

```
The code is basically instantiating the authService that you created before to this service as a private instance (so you may not access the methods of the `AuthService` directly from HTML), that is a good practice because all the methods called in HTML template should be in it's component, so you don't loose control from where those methods are being called.

Now open the page `header.component.html` and then add the following peace of code to it:

{% highlight html %}
<nav class="navbar navbar-expand-lg navbar-light bg-light justify-content-between">
  <a class="navbar-brand" href="#">{% raw %}{{title}}{% raw %}</a>
  <button class="btn btn-primary login" *ngIf="!isAuthenticated()" (click)="login()">
      Login
  </button>
  <span  *ngIf="isAuthenticated()">
    <span>
      Logged in as:
      <img [src]="getProfile().picture" width="40">
      {% raw %}{{getProfile().name }}{% raw %}
    </span>
    <button class="btn btn-secondary" (click)="logout()">Logout</button>
  </span>
</nav>  
{% endhighlight %}

The HTML code is basically verifying if the user is logged through the `*ngIF` directive (if it is true, it will create the tag in which the directive is in), if the user is authenticated it will show the profile, otherwise it will show the login button.

Now you should add this new component to the top of `app.component.html`:

{% highlight html %}
<app-header></app-header>
...
{% endhighlight %}

And last but not least, you are going to add code to `app.component.ts` to handle authentication when auth0 page redirects back to your app's main (and single) page and checks if the user is authenticated.

```typescript
import { Component } from '@angular/core';
import { AuthService } from './auth/auth.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  constructor(private authService: AuthService) {
    this.authService.checkSession();
  }
}

```

Now, you may run the code and play around authentication methods with Auth0. If everything is okay, you will probably see a page like the following one when you authenticate:

![Authenticated page](https://screenshotscdn.firefoxusercontent.com/images/ea396a6a-bbca-43f2-930e-588ae5e1d988.png)

### Verify identity and authorization on items 

Now remember our business rules: people who are not identified users should not be able to click the button to add an item to their shop cart and people who are not admin users should not be able to post new items. For doing that, you need also to import auth service to `item.component.ts` just as you did to `header.component.ts`. The code will look like that after the modifications: 

```typescript
...
export class ItemsComponent implements OnInit {
  ...
  constructor(private authService: AuthService, private formBuilder: FormBuilder) { }

  isAdmin() {
    return this.authService.isAdmin();
  }

  isAuthenticated() {
    return this.authService.isAuthenticated();
  }
  ...
}
...

```

Now you will add to HTML template some verification to see if the user has the right to access some of the services. To do that, you will add the following lines of code to the file `items.component.html`:

{% highlight html %}
<table>
...
  <tr>
  ...
     <td>
        <!--The button will be disabled if is authenticated is false-->
        <button class="btn btn-default"
          (click)="addToCart()"
          [disabled]="!isAuthenticated()">
          Add to shopping cart
        </button>
      </td>
  <tr>
</table>

<!--It will show the form div if the user is admin-->
<div *ngIf="isAdmin()">
...
  <form>
    ...
  </form>
</div>
{% endhighlight %}

Now you can may play around with different accounts and see how it works.

## Integrating Angular with Nest.js

Now finally you are going to integrate this front end with the back end you created on part 1. 

### Create a Proxy

In order to interact with the backend service, you will need to deal with [CORS Cross Request Origin Sharing](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS), because the calls among the front end and back end will be blocked by the browser because of the [Same-origin policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy) used by most of the web browsers. 

One way to deal with that is going back to your backend and [enabling CORS on it](https://docs.nestjs.com/techniques/cors), to do that, just add the following line of code to `main.ts`. 

```typescript
...
app.enableCors();
...
```

It is a easy way to do that, but basically it allows any page on the web to have scripts inserted by your back end, which is not ideal. You can also set a proxy to your application when you deploys it (for example, a [NGINX proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)), but in this tutorial you are going to create a proxy for development (it should be used mainly when you are developing this application and should be changed by NGINX or something similar when you deploy it). To do that, create a file in the root of your project called `proxy.config.js`:

```javascript
const proxy = [
    {
      context: '/api',
      target: 'http://localhost:3000',
      pathRewrite: {'^/api' : ''}
    }
  ];
  
module.exports = proxy;

```

Now you can restart your application using this proxy by running the following command:

```bash
ng serve --proxy-config proxy.config.js
```

### Create Requests with Angular Services

You are going to need to import into your project Angular HTTP requester. Your `app.module.ts` will look like that after importing it:

```typescript

import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';
import { ItemsComponent } from './items/items.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HeaderComponent } from './header/header.component';

@NgModule({
  declarations: [
    AppComponent,
    ItemsComponent,
    HeaderComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [ AppComponent ]
})
export class AppModule { }

```

Now, with this http document, you are going to create a service that does all the HTTP calls that you did on part 1 of this tutorial using curl. To generate this service, run the following command: 

```bash
ng generate service items/items # it will generate the service items inside of items folder
```

And then open the just created file and add the following code to it:

```typescript

import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Item } from './item.interface';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { AuthService } from '../auth/auth.service';

@Injectable({
  providedIn: 'root'
})
export class ItemsService {

  constructor(private http: HttpClient, private auth: AuthService) { }

  // creates header
  private _authHeader(): Object {
    return {
      headers: new HttpHeaders({ 'authorization': `Bearer ${this.auth.getAccessToken()}`})
    };
  }

  public getItems(): Observable<Item[]> {
    return this.http.get<Item[]>('/api/items');
  }

  public postItems(item: Item): Observable<Item> {
    return this.http.post<Item>('/api/items', item, this._authHeader());
  }

  public postToShoppingCart(): Observable<String> {
    return this.http.post<String>('/api/shopping-cart', '', this._authHeader());
  }
}
```
As you may have noticed, every method other than `_authHeader()` (which adds the Auth0's token to the request). Now you are going to add the `items.service.ts` to the `items.component.ts`, the code will look like the following:

```typescript
import { ItemsService } from './items.service';
...
export class ItemsComponent implements OnInit {
..
items: Item [];
...
constructor(public authService: AuthService, private itemService: ItemsService, private formBuilder: FormBuilder) {}

 ngOnInit() {
    this.itemService.getItems().subscribe(items => this.items = items);
    ...
  }

  addToCart() {
    this.itemService.postToShoppingCart().subscribe(response => {
    }, error => {
        window.alert(error.error.message || error.error.text);
        console.log(error);
    });
  }

  addNewItem() {
    this.itemSubmitted = true;

    if (this.itemForm.invalid) {
      console.log(this.itemForm);
    } else {
      this.itemService.postItems(this.itemForm.value).subscribe(response => {
        window.location.reload();
      }, error => {
          window.alert(error.error.message);
      });
    }
  }
  ...
}

```

Now you may visit [localhost:4200](http://localhost:4200) and play around with your just integrated application.

## Conclusion

You learned how to create an application using typescript from back end to front end. It is not a production ready application yet: far from it! You will need to learn how to create tests to it, how to integrate it with a database as Mongo DB and many other things, but I hope that this tutorial will help you as an introduction to your further studies on NEST and Angular 6.