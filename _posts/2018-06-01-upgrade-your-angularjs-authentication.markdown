---
layout: post
title: "Upgrade Your AngularJS Authentication"
description: "In this article, we’re going to talk about two difficult subjects: ngUpgrade and authentication."
longdescription: "In this article, we’re going to talk about two difficult subjects: ngUpgrade and authentication. First, we’ll cover the foundations of upgrading a real application from AngularJS to Angular. Then, we’ll look at a practical example of upgrading AngularJS authentication strategies to Angular."
date: 2018-05-22 17:28
category: Technical Guide, Angular
author:
  name: "Sam Julien"
  url: "https://www.upgradingangularjs.com/"
  avatar: "https://cdn.auth0.com/blog/guest-authors/sam-julien.jpeg"
design:
  bg_color: "#012C6C"
  image: https://cdn.auth0.com/blog/logos/angular.png
tags:
- angular
- angularjs
- ngupgrade
- authentication
- auth0
related:
- 2016-09-29-angular-2-authentication
- 2017-06-28-real-world-angular-series-part-1
---

**TL;DR:** In this article, we’re going to talk about two notoriously difficult subjects very near and dear to my heart: ngUpgrade and authentication. First, we’ll cover the foundations of upgrading a real application from AngularJS to Angular. Then, we’ll look at a practical example of upgrading AngularJS authentication strategies to Angular. We’ll look at a sample app that uses machine-to-machine authentication with Auth0.

> This article is based on a talk I gave for [the Auth0 online meet up](https://www.meetup.com/Auth0-Online-Meetup/). [You can watch the recording of that talk here](https://register.gotowebinar.com/register/7495371156540204033) and [access the slides here](https://www.upgradingangularjs.com/auth0).

## ngUpgrade Foundations

Back in late 2016, I was going through some very painful issues trying to upgrade my company’s apps from AngularJS to Angular. I was completely overwhelmed and totally lost. Rather than rage-flip my desk and go live in a cave, I decided to channel my frustrations into learning everything I could about the upgrade process and documenting it along the way for the community. That’s where my video course [Upgrading AngularJS](https://www.upgradingangularjs.com/?ref=auth0) came from: my own blood, sweat, and tears of figuring this process out. I’m hoping to save other people the hundreds of hours that I put into it.

That’s also why I’m writing articles like this one — to help you save time. 

### ngUpgrade Background

Let’s start with a bit of background. AngularJS (1.x) is going to be entering a [long term stable schedule](https://blog.angular.io/stable-angularjs-and-long-term-support-7e077635ee9c) starting July 1st, 2018, and lasting through June 30, 2021. The last stable version is going to be version 1.7. So, where does that leave us? That leaves us with the new Angular (2+). You’ve now got this bridge period to determine if you need to upgrade and, if so, to complete that upgrade using the ngUpgrade library.

Most of the time, you should upgrade, but there are a handful of exceptions. The main exception is if your application is just going to lay dormant from now on. If you’re never going to do anymore feature development on it, you don’t need to upgrade. The AngularJS packages and CDNs will stay around forever. You don’t need to worry about your legacy code evaporating into thin air and being unable to do anything about it.

That being said, if you are doing feature development, you should do yourself a favor and move over to Angular. Angular is much faster, has a lot better features, and has lots of architecture and data flow best practices already baked into the framework. Don’t worry, though. You don’t have to do it all in one shot — you can do it gradually and take the time that you need do it right.

Another question I get asked a lot is, “Should I just rewrite everything to React/Vue/whatever?” Most of the time, the answer is no, unless you’ve already got team members who have that expertise (or you just, for whatever reason, really want to move to a different framework). It’s very unlikely it’s going be easier to move to another framework. The ngUpgrade library, which is the `@angular/upgrade/static` package, is explicitly made to bridge the gap between AngularJS and Angular. There’s no such equivalent library for React or Vue.

## The ngUpgrade Process

Let’s get a high-level look at what the upgrade process looks like. There are two distinct phases. 

### Phase 1: Preparation

The first is the preparation phase. One of the nice things about AngularJS was that it was extremely flexible. You could use AngularJS in a lot of different situations, from simple data binding to complex single-page applications.

That flexibility had a downside, though. For a long time, there wasn’t a collection of best practices for AngularJS, until John Papa came along and codified everything in the [AngularJS style guide](https://github.com/johnpapa/angular-styleguide/blob/master/a1/README.md). That was really helpful, because that it was really confusing having so many possible ways to structure applications. Not all applications were able to immediately conform to the style guide, though. That means we have many possible starting points for ngUpgrade. There’s no “one size fits all” solution. For that reason, part of the ngUpgrade process is getting your AngularJS code conformed to best practices.

The preparation phase consists of four **building blocks** to the ngUpgrade process:

- Your **file structure**. There are two critical things here to get in line with the style guide. First, organize your files by feature, not by type. Second, have only one item per file.
- Your **dependencies**. We at one point were a divided community on how best to manage dependencies. Now, we’ve settled on npm (or yarn) as the best way to manage our packages and dependencies (no more Bower!). We also need to be using one of the latest versions of AngularJS (at least 1.5, but preferably the most recent). 
- Your **architecture**. AngularJS 1.5 introduced the component API, which enabled component architecture. Moving your application to component architecture is part of the preparation phase. AngularJS 1.5 also introduced things like life-cycle hooks and one-way data binding. As you upgrade, you’ll need to replace controllers with components and get rid of all of those instances of `$scope`. You don’t necessarily need to get everything in tip-top shape before you even start using ngUpgrade, but your end result will be component architecture, whether in AngularJS or Angular. The closer you are to components, the easier your upgrade will be.
- Your **build process**. The build process is the tooling that we want to do to get all of our application compiling and ready for the ngUpgrade library. Practically speaking, this means using Webpack for module bundling and Typescript for your code. This means replacing script tags or task runners like Gulp and Grunt with ES6 modules. Our goal is to make our tooling exactly in line with the Angular tooling so that at some point we can move to the Angular CLI.

Speaking of the CLI — if you can use it right away in your legacy application, by all means, do so. In certain situations, though, you can’t really get the CLI into an upgrade project right off the bat. You might have your code structure all over the place or a very customized build process. In these cases, you‘ll need to wait until you’ve at least cleaned up your code and architecture so that your application fits better with the CLI. The CLI is highly opinionated in how it wants to organize your code, and it wants to own your build process. This is fantastic in the long run — it solves the exact problem of the early days of AngularJS — but in the short term it can be frustrating if you’re working with a big application that uses old patterns. 

One last note on working through these four building blocks. It’s not necessarily a linear process. Not all of this needs to be completely perfect before you start moving on to ngUpgrade. Particularly, the architecture part can really be done slowly or at the same time as the upgrade process. It really depends on how big your application is and how much capacity you have for working through this technical debt while you’re also doing feature development and bug fixes. The only one that is really critical outside of being up to date with your dependencies is the _build process_, because we really do need a module bundler and TypeScript in order to use ngUpgrade and start moving our application over.

### Phase 2: Upgrading

Now let’s talk about the upgrading phase, which has three different parts. 

The first one is the **install and setup**, where you’ll install all of the packages for Angular and ngUpgrade and then bootstrap both frameworks to run side by side together. (We won’t cover that in detail here, but I wrote a thorough post over on Scotch.io to help you with that.)

Then the second part is the **migration process**. This is the loop of gradually moving pieces of your application over to Angular and using ngUpgrade to get your Angular and AngularJS code talking to each other. There are different approaches to this, but most people pick a route and start from the bottom or the top depending on how their application is structured. You’ll typically move from items that have the least number of dependencies to the most number of dependencies. For example, I usually start with the services in a route and then work my way up through the components.

This migration process can take as long as you need. I like to get the application all set up for ngUpgrade and then draw a line in the sand that all of my new features will be in Angular. Then, as I’m adding a new feature in Angular, inevitably I’m going to touch other pieces of the code base. While I’m doing that, I can just rewrite those pieces and work my way through it so that it’s a natural process throughout my development cycle.

Finally, leave your routing to the very end, since the routing is the brain of the application. Get everything rewritten to Angular, then swap out the old AngularJS router with the new Angular router.

Somewhere in here you’re going to have to deploy this code to production if you want keep bringing home a paycheck. You’re going to have to **set up your code for production**. This means that you need to take advantage of Angular’s static compilation process, called Ahead of Time compiling. Angular has two modes that it can run in. It can run in a Just in Time (JIT) compilation mode or it can run in Ahead of Time (AOT) compilation mode.

The compiler takes up a big chunk of the Angular library. When you’re in development and using JIT compilation, that compiler is being wrapped up in your bundle and going with you to the browser. 

![The compiler takes up a big chunk of Angular.](https://cdn.auth0.com/blog/ngupgrade/compiler-chunk.png)

When you use the AOT compilation process, everything gets compiled ahead of time and the compiler code itself doesn’t have to be put into your bundle.

There are a bunch of other reasons that you want do this, like better security, but the bottom line is that AOT is smaller and faster than JIT, so it’s better for production. To read more about how to set up Webpack for AOT, you can [check out this article I wrote](https://medium.com/@UpgradingAJS/the-ultimate-guide-to-setting-up-aot-for-ngupgrade-without-jumping-out-a-window-998df2fdd196). I also have step-by-step videos on [this setup in my course](https://www.upgradingangularjs.com/?ref=auth0).

Now that we’ve got a handle on the different parts of the upgrade process, let’s dive in to a practical example of Phase 2’s **migration process**.

## The Sample Application

Go ahead and [clone this updated fork of my course sample project](https://github.com/upgradingangularjs/ordersystem-evergreen) (don’t forget to run `npm install` or `yarn install` in both the `server` and the `public` folders). You can checkout the `auth0` branch and the starting commit by running these commands:

```bash
git checkout auth0
git checkout c6b2055f831134b616452ad3319309817ab9d574
```

This basic order system application starts off as a hybrid application with AngularJS 1.6 and Angular 5 (don’t worry, nothing we cover in this tutorial is different in Angular 6). It’s not too fancy, but I’ve made it in a way that is extensible and uses some patterns that you’ve seen in the real world in AngularJS.

### Current Authentication Setup

The Express server is set up with Auth0 with a machine-to-machine API and client relationship. I used machine-to-machine because a user login system is an extra layer of complexity that, for this purpose, doesn’t actually matter that much. All we really care about is the ability to go get a token and add it to our outgoing requests to be able to get our data. Whether that’s specific to a user or to an application doesn’t matter. (I should also say that, while I’m using Auth0, the approach we take in this article applies to any sort of token system.) 

I’ve also got two routes using authentication: the customers route and the products route. This is because the customers route is using an Angular component and service, but the products route is still using AngularJS pieces. That’ll let us see both approaches and how to upgrade.

If you want to follow along, you’ll need to use Auth0 to set up your own machine-to-machine API and application, since this server is just running locally. You can do that from the Auth0 dashboard. First [create the API](https://auth0.com/docs/quickstart/backend/nodejs), then create the application as a machine-to-machine application.

![Machine to machine application.](https://cdn.auth0.com/blog/ngupgrade/machine-to-machine-auth0-api.png)

You’ll wire up this application to use the API you just made.

Once you’re done with the Auth0 setup, you can just edit `server/auth.js` to replace my API information with yours:

```js
const checkJwt = jwt({
  secret: jwksRsa.expressJwtSecret({
    cache: true,
    rateLimit: true,
    jwksRequestsPerMinute: 5,
    jwksUri: `https://samjulien.auth0.com/.well-known/jwks.json` // <-- replace
  }),

  // Validate the audience and the issuer.
  audience: 'ordersystem-api', // <-- replace
  issuer: `https://samjulien.auth0.com/`, // <-- replace
  algorithms: ['RS256']
});
```

You’ll also need to add a file called `authVariables.js` to the root of the project and export your application’s client id and client secret as variables, like this:

```js
export const CLIENT_ID = '[client id here]';
export const CLIENT_SECRET = '[client secret here]';
```

The AngularJS AuthService will use that file to go get the token from the API.

On the client side (the `public` folder), inside of our `src` folder, we have a file called `app.run.ajs.ts`. This file contains a function that calls the authentication service to check if we’re authenticated and go get the token if not:

```ts
runAuth.$inject = ['authService'];
export function runAuth(authService) {  
  if (!authService.isAuthenticated()) authService.getToken();
}
```

This function gets added to our AngularJS module using `angular.module().run()` in `app.module.ajs.ts`.

To add our token to outgoing requests, we have an HTTP interceptor for the AngularJS `$http` provider (`auth.interceptor.ajs.ts`). It goes and gets the token from local storage and then it adds the authorization header with the bearer token before the request goes out.

The authentication service (`./shared/authService.ts`), which is also still in AngularJS, goes and gets the token from Auth0 (via the server) and then sets that token in local storage. 

To see that this is working, first open a terminal and run `npm start` inside of the `server` folder. Then, open another terminal and run `npm run dev` inside of the `public` folder. Navigate to [`localhost:9000`](localhost:9000), open up Chrome developer tools, and click on the Customers tab. You can see that the token has been added as a header on the outgoing request:

![The Authorization header on the customers request.](https://cdn.auth0.com/blog/ngupgrade/authorization-header.png)

You can do the same thing with the Products tab, which also uses authentication for the `/products` call to the Express server.

Of course, this is a very simple way of doing token authentication. We could make this more sophisticated in a number of ways, like adding error handling, but I want you to understand the basic concepts here.