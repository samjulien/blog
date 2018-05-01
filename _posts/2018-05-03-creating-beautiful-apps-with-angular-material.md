---
layout: post
title: "Creating Beautiful Apps with Angular Material"
description: "In this article, you will learn how to take advantage of Angular Material to create beautiful and modern Angular applications."
date: 2018-05-03 8:30
category: Technical Guide, Angular, Angular2
design: 
  image: https://cdn.auth0.com/blog/identity-management-hybrid-cloud/logo.png
  bg_color: "#00635D"
author:
  name: "Oliver Mensah"
  url: "https://twitter.com/Oliver_Mensah"
  mail: "olivermensah96@gmail.com"
  avatar: "https://twitter.com/Oliver_Mensah/profile_image?size=original"
design:
  image: https://cdn.auth0.com/blog/angular/logo3.png
  bg_color: "#012C6C"
tags:
- javascript
- angular
- material
- spa
related:
- 2017-06-28-real-world-angular-series-part-1
- 2016-11-07-migrating-an-angular-1-app-to-angular-2-part-1
---

**TL;DR:** In this article, you will learn how to take advantage of Angular Material to create beautiful and modern Angular applications.

## So, What Exactly is Angular Material?

Angular Material is a third-party package used on Angular projects to facilitate the development process through reutilization of common components like Cards, beautiful Inputs, Data Tables, and so on. The list of available components is big and continues to grow as we speak. So, for a full reference of components with examples, check [the official website](https://material.angular.io/).

With Angular, the entire app is a composition of components and, instead of building and styling components from the group up, you can leverage with Angular Material which provides out-of-the-box styled components that follow the [Material Design Spec](https://material.io/guidelines/).

This specification is used by Google in the Android operating system and is also very popular on the web due to its beautiful UI utilities.

## Angular Material Tutorial

The idea of this is article is to teach you how to use Angular Material through a hands-on exercise. First, you will check the dependencies that you need in your computer to use and develop with Angular Material, then you will learn how to configure and use different components.

### Setup the Environment for Angular

To work with Angular, you will need [Node.js](https://nodejs.org/en/) and [Angular CLI (Command Line Interface)](https://cli.angular.io/) installed in your development environment. Node.js will provide the packages needed by the CLI to work and the development server so you can check your progress in real time.

Angular CLI is the tool that helps you create a new Angular project and configure Angular components, services, and so on. You will need it because an Angular project is more than just HTML and script files. That is, An angular project uses [TypeScript](https://www.typescriptlang.org/) which needs to be transpiled and optimized to run browsers. Without Angular CLI, you would need to setup and wire a lot of tools to work together, which would consume too much time.

If you don't have Node.js installed in your computer, proceed to [the download page](https://nodejs.org/en/download/) and follow the instructions there (or use a tool like [N, a Node.js version manager](https://github.com/tj/n) to have multiple versions installed with ease). Then, after installing Node.js, use NPM (which comes along with Node.js) to install Angular CLI:

```bash
npm install -g @angular/cli
```

> **Note:** Depending on the setup of your computer, you might need to use `sudo` to use the `-g` (global) flag.

### Create an Angular Project

Having both Node.js and Angular CLI correctly installed in your computer, you can use the following command to setup a new Angular project:

```bash
# create a new Angular project under angular-material-tutorial
ng new angular-material-tutorial
```

This command will generate a directory/file (under a new directory called `angular-material-tutorial`) structure with a bunch of files that are needed so you can create your Angular applications. To learn the details of this structure, please, check [the Angular CLI documentation](https://github.com/angular/angular-cli).

To help you throughout this tutorial, you can set an environment variable to point to the root directory of your Angular project:

```bash
# create a variable to point to the root dir
ROOT_DIR=$(pwd)/angular-material-tutorial

# move into it
cd $ROOT_DIR
```

### Install Angular Material

To install Angular Material as a dependency of your project, run the following command:

```bash
npm install @angular/material @angular/cdk
```

For now, you won't make any changes into your project's source code. First, you will install a few more cool dependencies.

### Angular Material Theme

After installing Angular Material, you will configure a [theme](https://material.angular.io/guide/theming) that defines what colors will be used in your Angular Material components. To configure the basic theme, open the `src/styles.css` file and paste the following code in it:

```css
@import "~@angular/material/prebuilt-themes/indigo-pink.css";
```

By the way, if you don't know what IDE (Integrated Development Environment) to use while developing with Angular, [Visual Studio Code](https://code.visualstudio.com/) is a great (and free) alternative.

### Angular Material Gesture

Some components like [Slide Toggle](https://material.angular.io/components/slide-toggle/overview), [Slider](https://material.angular.io/components/slider/overview), and [Tooltip](https://material.angular.io/components/tooltip/overview) rely on a library called HammerJS to capture touch gestures. So, you will need to install HammerJS and load it into our application.

To do so, from the `$ROOT_DIR` directory, run:

```bash
npm install hammerjs
```

After installing it, add the following line at the top of the `src/main.ts` file:

```js
import 'hammerjs'; 
``` 

### Material Icons

Another cool thing to add to your project is the [Material Icons](https://material.io/icons/) library. To have access to this huge library of icons, update the `src/index.html` file as follows:

```html
<!doctype html>
<html lang="en">
<head>
  <!-- ... other tags ... -->
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<!-- ... body and app root ... -->
</html>
```

## What Will You Build with Angular Material

After setting up the Angular project structure and some dependencies, you will be able to start developing apps. In this article, to learn Angular Material through practical exercises, you will develop a dashboard for a blog engine where users will be able to insert new posts and delete existing ones. This won't be a full fledged application with a backend persistence nor enhanced features. The idea here is to show how cool and easy it is to use Angular Material.

{% include tweet_quote.html quote_text="I'm learning Angular Material through practical exercises!" %}

### Importing Material Components

The first thing you will do is to create a new file called `material.module.ts` in the `./src/app` directory. Inside this file, you will add the following code:

```typescript
import {NgModule} from '@angular/core';

@NgModule({
  imports: [],
  exports: []
})
export class MaterialModule {}
```

The idea of creating a new Angular module (`@NgModule`) is to centralize what you will import from Angular Material in a single file. So, before adding Angular Material components in this file, you will need to import and configure it in your main module (i.e. in the `./src/app/app.module.ts` file) as follows:

```typescript
// ... other import statements ...
import {MaterialModule} from './material.module';

@NgModule({
  // ... declarations property ...
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    MaterialModule,
  ],
  // ... providers and bootstrap properties ...
})
export class AppModule {}
```

> **Note:** You are also adding `BrowserAnimationsModule` so your app can count on some cool animation features (like the shadow on the click of the buttons).

### Angular Material Sidenav

After defining a centralized place to import Angular Material components, you can focus on adding a navigation bar to your app. For this, you will update the `./src/app/app.module.ts` to look like this:

```typescript
import {NgModule} from '@angular/core';

import {
  MatSidenavModule,
  MatToolbarModule,
  MatIconModule,
  MatListModule,
} from '@angular/material';

@NgModule({
  imports: [
    MatSidenavModule,
    MatToolbarModule,
    MatIconModule,
    MatListModule,
  ],
  exports: [
    MatSidenavModule,
    MatToolbarModule,
    MatIconModule,
    MatListModule,
  ]
})
export class MaterialModule {}
```

This change will make `MatSidenavModule` available in your application. So, now, you can update the app template (`./src/app/app.component.html`) to use this component:

{% highlight html %}
{% raw %}
<mat-sidenav-container>
  <mat-sidenav  #sidenav role="navigation">
   <mat-nav-list>
    <a mat-list-item>
      <mat-icon class="icon">input</mat-icon>
      <span class="label">Login</span>
    </a>
    <a mat-list-item>
      <mat-icon class="icon">home</mat-icon>  
        <span class="label">Home</span>
    </a>
    <a mat-list-item>
      <mat-icon class="icon">dashboard</mat-icon>  
      <span class="label">Dashboard</span>
    </a>
    <a  mat-list-item type="button">
      <mat-icon class="icon">input</mat-icon>
      <span class="label">LogOut</span>
    </a>  
    </mat-nav-list>
  </mat-sidenav>
  <mat-sidenav-content>
    <mat-toolbar color="primary">
     <div fxHide.gt-xs>
       <button mat-icon-button>
        <mat-icon>menu</mat-icon>
      </button>
    </div>
     <div>
       <a>
          Material Blog
       </a>
     </div>
     <div fxFlex fxLayout fxLayoutAlign="flex-end"  fxHide.xs>
        <ul fxLayout fxLayoutGap="20px" class="navigation-items">
            <li>
                <a>
                  <mat-icon class="icon">input</mat-icon>
                  <span  class="label">Login</span>
                 </a>
            </li>
            <li>
              <a >
                  <mat-icon class="icon">home</mat-icon>
                  <span class="label">Home</span>
              </a>
            </li>
            <li>
                <a>
                    <mat-icon class="icon">dashboard</mat-icon>
                    <span class="label">Dashboard</span>
                </a>
              </li>
            <li>
                <a>
                  <mat-icon class="icon">input</mat-icon>
                  <span class="label">LogOut</span>
                 </a>
            </li>
        </ul>
     </div>
    </mat-toolbar>
    <main>
    </main>
  </mat-sidenav-content>
</mat-sidenav-container>
{% endraw %}
{% endhighlight %}

For now, you won't have anything nice to see in a browser yet, but you will get there soon.

### Angular Material and Flexbox

To make your life easier when defining the layout of your Angular application, you will take advantage of the Flex layout schema introduced recently on CSS. More specifically, you will use an Angular directive called `fxFlex` to handle the Flex layout.

To use it, install the Flex layout package with the following command:

```bash
npm install @angular/flex-layout
````

Then, import and configure it into `src/app.module.ts` as shown here:

```typescript
// ... other import statements ...
import {FlexLayoutModule} from '@angular/flex-layout';

@NgModule({
  // ... declarations property ...
  imports: [
    // ... other modules ...
    FlexLayoutModule,
  ],
  // ... providers and bootstrap properties ...
})
export class AppModule {}
```

If you take a close look, you will see that you are already using some features of this package in the navigation bar defined before. For example, you have added directives like `fxLayout`, `fxLayoutAlign`, and other `fxFlex` directives.

Before running your app for the first time, add the following CSS rules to `app.component.css` so your navigation looks a little bit better:

```css
mat-sidenav-container, mat-sidenav-content, mat-sidenav {
  height: 100%;
}

mat-sidenav {
  width: 250px;
}

a {
  text-decoration: none;
  color: white;
}

a:hover,
a:active {
  color: lightgray;
}

.navigation-items {
  list-style: none;
  padding: 0;
  margin: 0;
  cursor: pointer;
}

.icon {
  display: inline-block;
  height: 30px;
  margin: 0 auto;
  padding-right: 5px;
  text-align: center;
  vertical-align: middle;
  width: 15%;
}

.label {
  display: inline-block;
  line-height: 30px;
  margin: 0;
  width: 85%;
}
```

Also, add the following rule to `./src/styles.css` so you don't have any white margins around your app:

```css
@import "~@angular/material/prebuilt-themes/indigo-pink.css";

body {
  margin: 0;
}
```

With these rules in place, you can issue `ng serve` from your project root to check your application for the first time.

![Navigation bar with Angular Material](https://cdn.auth0.com/blog/angular-material/navigation.png)

### More Angular Material Components

### Creating Routes

### Managing Data - Part 1

## Securing App  with Auth0

### Managing Data - Part 2

### Enabling Data Deletion

### Enabling Data Input

## Conclusion