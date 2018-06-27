---
layout: post
title: "Vue.js and AWS Lambda: Developing Production-Ready Apps (Part 2)"
description: "In this series, you will learn how to develop production-ready applications with Vue.js and AWS Lambda."
date: 2018-06-28 08:30
category: Technical Guide, Frontend, VueJS
author:
  name: "Bruno Krebs"
  url: "https://twitter.com/brunoskrebs"
  mail: "bruno.krebs@gmail.com"
  avatar: "https://cdn.auth0.com/blog/profile-picture/bruno-krebs.png"
design:
  bg_color: "#213040"
  image: https://cdn.auth0.com/blog/vue-js-and-lambda-developing-production-ready-apps/logo.png
tags:
- vue.js
- aws-lambda
- aws
- lambda
- spa
- auth0
related:
- 2018-06-13-vue-js-and-lambda-developing-production-ready-apps-part-1
- 2017-04-18-vuejs2-authentication-tutorial
---

**TL;DR:** In this series, you will use modern technologies like Vue.js, AWS Lambda, Express, MongoDB, and Auth0 to create a production-ready application that acts like a micro-blog engine. [The first part of the series focused on the setup of the Vue.js client that users will interact with and on the definition of the Express backend app](https://auth0.com/blog/vue-js-and-lambda-developing-production-ready-apps-part-1/). 

The second part (this one) will show you how to prepare your app for showtime. You will start by signing up to AWS and to MongoLabs (where you will deploy the production MongoDB instance), then you will focus on refactoring both your frontend and backend apps to support different environments (in this case, development and production).

> **Note:** the instructions described in this article probably won't incur any charges. Both AWS and MongoLabs have free tiers that support a good amount of requests and processing. If you don't extrapolate usage, you won't have to pay anything.

If interested, [you can find the final code developed in this part in this GitHub repository](https://github.com/auth0-blog/vue-js-lambda-part-2).

## Before Starting

Before you can start following the instructions presented in this article, you will need to make sure you have a version of the app running in your local machine. If you already followed [the instructions described in the previous article](https://auth0.com/blog/vue-js-and-lambda-developing-production-ready-apps-part-1/) and already have the app running locally, you can jump this section. Otherwise, you can opt to ignore the previous article and take the shortcut described in the following subsections.

### Configure an Auth0 Application and an Auth0 API

As you want your micro-blog engine to be as secure as possible and don't want to waste time focusing on features that are not unique to your app (i.e. [identity management features](https://auth0.com/learn/cloud-identity-access-management/)), you will use Auth0 to manage authentication. As such, if you haven't done so yet, you can <a href="https://auth0.com/signup" data-amp-replace="CLIENT_ID" data-amp-addparams="anonId=CLIENT_ID(cid-scope-cookie-fallback-name)">sign up for a free Auth0 account here</a>.

After signing up to Auth0, [you can head to the APIs section of the management dashboard](https://manage.auth0.com/#/apis) and click on the _Create API_ button. In the form that Auth0 shows, you can fill the fields as follows:

- _Name_: "Micro-Blog API"
- _Identifier_: `https://micro-blog-app`
- _Signing Algorithm_: `RS256`

To finish the creation of your Auth0 API, click on the _Create_ button. After that, head to [the _Applications_ section](https://manage.auth0.com/#/applications) and click on the _Create Application_ button. In the form presented, fill the options as follows:

1. The name of your application: you can enter something like "Vue.js Micro-Blog".
2. The type of your application: here you will have to choose _Single Page Web Applications_.

After clicking on the _Create_ button, Auth0 will redirect you to a new page where you will need to tweak your application configuration. For now, you are only interested in adding values to two fields:

- "Allowed Callback URLs": Here you will need to add `http://localhost:8080/callback` so that Auth0 knows it can redirect users to this URL after the authentication process.
- "Allowed Logout URLs": The same idea but for the logout process. So, add `http://localhost:8080/` in this field.

After inserting these values into these fields, hit the _Save Changes_ button at the bottom of the page.

### Creating a MongoDB Instance Locally

After creating both the Auth0 Application and the Auth0 API, you will need to initialise a MongoDB instance to persist your users' data. To facilitate this process, you can rely on Docker (for this, [you will need Docker installed in your machine](https://docs.docker.com/install/)). After installing it, you can trigger a new MongoDB instance with the following command:

```bash
docker run --name mongo \
    -p 27017:27017 \
    -d mongo
```

Yup, that's it. It's easy like that to initialise a new MongoDB instance in a Docker container. For more information about it, you can check the instructions on [the official Docker image for MongoDB](https://hub.docker.com/_/mongo/).

### Forking and Cloning the App's GitHub Repository

The first thing you will need to is [to fork and clone](https://guides.github.com/activities/forking/) the [GitHub repository created throughout the previous article](https://github.com/auth0-blog/vue-js-lambda-part-1). After forking it into your own GitHub account, you can use the following commands to clone your fork:

```bash
# replace this with your own GitHub user
GITHUB_USER=brunokrebs

# clone your fork
git clone git@github.com:$GITHUB_USER/vue-js-lambda-part-1.git
```

After that, you can install the backend and frontend dependencies:

```bash
# move into the Vue.js app
cd vue-js-lambda-part-1/client

# install frontend dependencies
npm i

# then move into the Express app
cd ../backend

# install backend dependencies
npm i
```

Then, open the project root (the parent of the `client` and `backend` directories) into your preferred IDE and proceed as follows:

1. Open the `/client/src/App.vue` file and replace the `domain`, `clientID`, and `audience` properties of the object passed to `Auth0.configure` with the properties from the Auth0 Application created previously.
2. 

## AWS Lambda Overview

## Signing Up to AWS

## Deploying a MongoDB Instance on the Cloud

## Installing and Configuring Claudia

## Preparing the Express App for Claudia
### Refactoring your Index Express File
### Creating a new Auth0 Tenant for Production
### Creating a new Auth0 API
### Extracting Environment Variables
### Wrapping your Express App with an AWS Lambda Proxy
### Deploying your Express App to AWS Lambda

## Preparing your Vue.js App to AWS S3
### Creating a new Auth0 Client
### Extracting Environment Variables
### Creating an AWS S3 Bucket
### Uploading your Vue.js App to AWS S3

## Conclusion and Next Steps
