---
layout: post
title: HelloWorld: with Auth0
description: "Add authentication to our a SPA, customize Auth0 Lock, enable social login, and set up multi-factor authentication."
longdescription: "In this guide, you'll finish adding authentication to our simple single page application, customize Auth0 Lock, enable social login with Facebook and set up multi-factor authentication. If none of this makes any sense, don't worry. We're going to explain that as well."
date: 2018-05-19 15:58
category: Technical Guide, Identity
author:
  name: Luke Oliff
  url: https://twitter.com/mroliff
  avatar: https://avatars1.githubusercontent.com/u/956290?s=200
  mail: luke.oliff@auth0.com
design:
  bg_color: "#2B1743"
  image: https://cdn.auth0.com/blog/gatsby-react-webtask/logo.png
tags:
- helloworld
- hello-world
- jquery
- auth0
- mfa
- multifactor
- lock
- social-logins
- facebook-login
- rules
related:
- 2018-02-07-oauth2-the-complete-guide
---

**TL;DR:** In this guide, you'll finish adding authentication to our simple [single page application](https://auth0.com/docs/sso/current/single-page-apps), customize Auth0 [Lock](https://auth0.com/docs/libraries/lock/v11), enable [social login](https://auth0.com/blog/social-login-on-the-rise/) with Facebook, and set up [multi-factor authentication](https://auth0.com/docs/multifactor-authentication). If none of this makes any sense, don't worry. We're going to explain that as well.

---

Before you get started, you're going to need **NodeJS** installed on your computer. This bit of software allows you to run stuff locally, like web servers and code.

> ***Note:*** This guide has been developed with a target audience that may have no exposure to development. If you're a developer, you might want to try out [one of our many other blog articles](https://www.auth0.com/blog), on a language you might be familiar with.

## Pre-requisites

You're going to need some bits before we get started.

### NodeJS

If you do not have **NodeJS** installed on your computer, install that now. If you don't know whether or not you have it, it shouldn't hurt to install it anyway.

Go to [nodejs.org](https://nodejs.org/en/) where you're looking to download a version labelled **LTS**, or *long-term support*. 

> ***Note:*** **LTS** is the version most likely to be supported for the next few months. *Long-term support* versions usually are the most robust, tested and adopted versions which are only subject to smaller updates, that try not to introduce changes that could break your software.

Double-click on your downloaded **NodeJS** package and install it.

### What is Terminal?

Nothing to install this time. But, take a look at what Terminal looks like.

Press `Command+Space` together. This opens ***Spotlight Search***, where you can type ***Terminal*** and press enter. This opens up ***Terminal*** for you.

![new tenant on new account](/Users/olaf/Desktop/Screen Shot 2018-05-23 at 10.40.43.png)

Being in Terminal is like being in a folder that you can tell it what to do.

You should be able to issue a command like this, to change to your `Downloads` directory.

```bash
cd ~/Downloads/
```

Remember what you did here, because you'll need to get to your `Downloads` directory from ***Terminal*** in this guide.

> ***Note:*** This guide assumes you're on a Mac. Drop us a comment below and we can provide updated instructions for a Windows machine or Ubuntu machine.

## Lab 1 - Sign Up for Auth0

<a href="https://auth0.com/signup" data-amp-replace="CLIENT_ID" data-amp-addparams="anonId=CLIENT_ID(cid-scope-cookie-fallback-name)">Sign up for an Auth0 account</a>.

You can use an existing account, or an existing tenant, but I would recommend a nice clean place to start by signing up a fresh and creating a new tenant from there.

![new tenant on new account](/Users/olaf/Desktop/Screen Shot 2018-05-23 at 10.40.43.png)

## Lab 2 - Create and Run An Application

1. Go to your [**Auth0 Dashboard**](https://manage.auth0.com/#/) and click the "[create a new application](https://manage.auth0.com/#/applications/create)" button.

2. Name your new application and give it the type "Single Page Web Applications", and click the "Create" button.

   ![new tenant on new account](/Users/olaf/Desktop/Screen Shot 2018-05-23 at 10.46.26.png)

3. 

