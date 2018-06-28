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

The second part (this one) will show you how to prepare your app for showtime. You will start by signing up to AWS and to mLab (where you will deploy the production MongoDB instance), then you will focus on refactoring both your frontend and backend apps to support different environments (in this case, development and production).

> **Note:** the instructions described in this article probably won't incur any charges. Both AWS and mLab have free tiers that support a good amount of requests and processing. If you don't extrapolate usage, you won't have to pay anything.

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

After inserting these values into these fields, hit the _Save Changes_ button at the bottom of the page and leave this page open (as you will need to copy some properties from it soon).

### Creating a MongoDB Instance Locally

After creating both the Auth0 Application and the Auth0 API, you will need to initialise a MongoDB instance to persist your users' data. To facilitate this process, you can rely on Docker (for this, [you will need Docker installed in your machine](https://docs.docker.com/install/)). After installing it, you can trigger a new MongoDB instance with the following command:

```bash
docker run --name mongo \
    -p 27017:27017 \
    -d mongo
```

Yup, that's it. It's easy like that to initialise a new MongoDB instance in a Docker container. For more information about it, you can check the instructions on [the official Docker image for MongoDB](https://hub.docker.com/_/mongo/).

### Forking and Cloning the App's GitHub Repository

With both Auth0 and a MongoDB instance properly configured, the next thing to do is [to fork and clone](https://guides.github.com/activities/forking/) the [GitHub repository created throughout the previous article](https://github.com/auth0-blog/vue-js-lambda-part-1). After forking it into your own GitHub account, you can use the following commands to clone your fork locally:

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

Then, you will need to open the project root (the parent of the `client` and `backend` directories) into your preferred IDE and proceed as follows:

1. On the `./client/src/App.vue` file, replace the `domain`, `clientID`, and `audience` properties of the object passed to `Auth0.configure` with the properties from the Auth0 Application created previously.
2. On the `./backend/src/routes.js` file, replace all appearances of `bk-tmp.auth0.com` with your own Auth0 domain and replace the `clientId` property of the object passed to `auth0.AuthenticationClient` with the _Client ID_ of your Auth0 Application.

After changing these files, you can use the following commands to start your application:

```bash
# from the backend directory, start the Express app in the background
node src/index.js &

# then move into the client directory
cd ../client

# and run the Vue.js app
npm start
```

Now, if you open [`http://localhost:8080`](http://localhost:8080) on a web browser, you should be able to sign in into your app through Auth0 and to post messages to your micro-blog engine.

![Running locally your Vue.js and Express app](https://cdn.auth0.com/blog/vuejs-lambda-part-2/running-the-app-locally.png)

## AWS Lambda Overview

As [AWS Lambda](https://aws.amazon.com/lambda/) is one of the most popular serverless solutions available, it probably doesn't need a thorough introduction. Nevertheless, even though you are going to use Claudia.js to abstract the usage of the AWS Lambda service, a basic understanding of how this solution works might come in handy.

On its own, AWS Lambda functions are not enough to handle HTTP requests originated from the Internet (and from your users' browsers when accessing the Vue.js application). If you were creating your serverless functions without the help of Claudia.js, you would have to use the [AWS API Gateway](https://aws.amazon.com/api-gateway/) solution along with Lambda. This would be needed because Lambda functions are raw functionalities that can be triggered by different clients (for example, from other resources at your AWS account, which wouldn't need the API Gateway).

As such, to make Lambda functions available to public clients like your Vue.js app, you would need to set up an API Gateway that would make the middle between both ends (Lambda and Vue.js, for example).

This (extremely) short introduction about AWS Lambda and AWS API Gateway is not even close to provide a complete explanation on how these features can be used (nor it is the goal here). If you need more explanation around these topics, [you can refer to the official documentation available at AWS](https://docs.aws.amazon.com/apigateway/latest/developerguide/getting-started-with-lambda-integration.html) and, if you are wondering how cumbersome would be to remove Claudia.js from your setup, you can refer to [this nice blog post that shows how to use the AWS CLI to create everything manually](https://ig.nore.me/2016/03/setting-up-lambda-and-a-gateway-through-the-cli/).

### Signing Up to AWS

Now, to set up AWS Lambda functions and an API Gateway (both manually or with the help of Claudia.js), you will need an AWS account. If you don't have one yet, [you can open this page to create your account](https://portal.aws.amazon.com/billing/signup). As you can see there, new AWS accounts include 12 months of free tier access which, [as described here](https://aws.amazon.com/free/), grant you (among other things):

- _Amazon API Gateway_: 1 million API calls per month;
- _AWS Lambda_: 1 million free requests per month;

This will probably be enough for the use case presented here. Unless you end up creating the next Twitter. :)

## Deploying a MongoDB Instance on the Cloud

After signing up to AWS, the next service that you will need to sign up to is [mLab](https://mlab.com/). You will need this service because it facilitates the deployment of production-ready, world-wide available MongoDB instances.

> **Note:** you can also choose to host a MongoDB instance on your own servers (like on an EC2 instance). However, to keep things easier to grasp, this article won't cover the steps needed to do so.

After signing up to mLab, you can head to [their dashboard and click on the _Create New_ button](https://mlab.com/create/wizard). Then, you will have to choose a cloud provider (as you will use this instance with AWS Lambda functions, it might make sense to choose _Amazon Web Services_ here) and a _Plan Type_. For the last option, _sandbox_ (the free plan) will be more than enough.

Now, you can click on _Continue_ and choose a region for your deployment. Choose some region geographically close to yourself. Then, when you click on _Continue_, mLab will require you to choose a database name. Here, you can set something like `micro-blog` and click on _Continue_. After this, mLab will present the details of your instance where, if everything is looking good, you will be able to finish the process by clicking on the _Submit Order_ button.

The last thing you will need to do to use your MongoDB instance is to define a user and password for your connections. So, [click on your instance](https://mlab.com/databases/micro-blog) and choose the _Users_ tab. There, you can click on the _Add Database User_ button and fill the form with the details of your new user (e.g. `micro-blog-db-user` as the username and `357-DbPass`as the password).

That's it, you are now ready to start refactoring your project source code to deploy it to production. Just leave this page open for further reference (you will need to copy the connection string from here).

## Preparing the Express App for Claudia.js

Having both your AWS and mLab accounts properly created, you can start changing your code. In the subsections presented here, you will install some dependencies, refactor parts of your Express API, and deploy your API to AWS Lambda.

### Installing Claudia.js

The process of installing and configuring Claudia.js can be pretty simple. Basically, to prepare your environment and your project to integrate with Cluadia.js, you will need to:

1. Install Claudia.js globally (you will need its CLI in a moment). This can be done by issuing `npm install claudia -g` in any terminal.
2. Install Claudia.js as a project development dependency to the `backend` subproject. You can achieve this by issuing `npm install claudia -D` on a terminal pointing to the `backend` directory.
3. Create an AWS profile and configure it locally so Claudia.js can deploy the project for you.

To create an AWS profile, go to the [_Users_ section of your _IAM Management Console_](https://console.aws.amazon.com/iam/home#/users) and click on _add user_. Then, you can configure your new user as follows:

- _User name_: Just enter something meaningful like `claudiajs-manager`.
- _Access type_: Check only the _programmatic access_ option as you won't use this user to log into the AWS console.

After that, click on the _next (permissions)_ button and click on the _create group_ button. You will need a new group to restrict access to what the Claudia.js user needs (i.e. the `AWSLambdaFullAccess` policy type). So, on the page that creates groups, configure the new one as follows:

- For the _Group name_, input something meaningful like `lambda-group`.
- Then, check the `AWSLambdaFullAccess`, `AmazonAPIGatewayAdministrator`, and the `IAMFullAccess` policy types to grant Claudia.js enough access.

Now you can hit the _create group_ button which will redirect you back to the user creation page. There, you will need to make sure that _only_ your new group (e.g. `lambda-group`) is selected. Having checked that, click on _Next: Review_.

On the next step, as shown in the next screenshot, you will see a page where you will have access to both the access and the secret access keys. Leave this page open so you can copy both keys.

![AWS access key and secret access key strings.](https://cdn.auth0.com/blog/vuejs-lambda-part-2/aws-user-credentials.png)

The last things you will need to do is to head back to the terminal, move into your home directory (`~/`), and update the `.aws/credentials` file to include both keys (you might actually need to create the `.aws` directory and the `credentials` file inside it):

```bash
[auth0]
aws_access_key_id = AKIR...WDNA
aws_secret_access_key = kuNgBlgz...xsBl
```

Just make sure you replace `AKIR...WDNA` and `kuNgBlgz...xsBl` with your own credentials and that you replace `auth0` with a meaningful profile name.

In case you need more info about this topic, [you can check the official Claudia.js docs](https://claudiajs.com/tutorials/installing.html#configuring-access-credentials) or you can [get in touch in the comments section down here](#disqus_thread).

### Refactoring your Index Express File

To use your Express API with AWS Lambda, Claudia.js requires that you export an `express` instance (instead of triggering `listen` manually) from the `./backend/src/index.js` file. So, open this file and replace the `app.listen` call (the last three lines of this file) with this:

```javascript
// ... require statements and app definition

module.exports = app;
```

After that, you will loose the ability to run your server locally. To circumvent this problem, you will need to create a new file called `development-server.js` inside the `./backend/src/` directory and add the following code to it:

```javascript
const app = require('./index');

app.listen(8081, () => {
  console.log('listening on port 8081');
});
```

With that in place, you can issue `node src/development-server.js` from the `backend` directory to start the Express app in your machine.

### Creating a new Auth0 Tenant for Production
### Creating a new Auth0 Application
### Creating a new Auth0 API
### Extracting Environment Variables

After creating the new Auth0 settings, you will need to replace the content of the `./backend/src/routes.js` file with this:

```javascript
const express = require('express');
const MongoClient = require('mongodb').MongoClient;
const auth0 = require('auth0');
const jwt = require('express-jwt');
const jwksRsa = require('jwks-rsa');

const router = express.Router();

const { AUTH0_CLIENT_ID, AUTH0_DOMAIN, MONGODB_URL } = process.env;

// retrieve latest micro-posts
router.get('/', async (req, res) => {
  const collection = await loadMicroPostsCollection();
  res.send(
    await collection.find({}).toArray()
  );
});

const checkJwt = jwt({
  secret: jwksRsa.expressJwtSecret({
    cache: true,
    rateLimit: true,
    jwksRequestsPerMinute: 5,
    jwksUri: `https://${AUTH0_DOMAIN}/.well-known/jwks.json`
  }),

  // Validate the audience and the issuer.
  audience: 'https://micro-blog-app',
  issuer: `https://${AUTH0_DOMAIN}/`,
  algorithms: ['RS256']
});

// insert a new micro-post
router.post('/', checkJwt, async (req, res) => {
  const collection = await loadMicroPostsCollection();

  const token = req.headers.authorization
    .replace('bearer ', '')
    .replace('Bearer ', '');

  const authClient = new auth0.AuthenticationClient({
    domain: AUTH0_DOMAIN,
    clientId: AUTH0_CLIENT_ID,
  });

  authClient.getProfile(token, async (err, userInfo) => {
    if (err) {
      return res.status(500).send(err);
    }

    await collection.insertOne({
      text: req.body.text,
      createdAt: new Date(),
      author: {
        sub: userInfo.sub,
        name: userInfo.name,
        picture: userInfo.picture,
      },
    });

    res.status(200).send();
  });
});

async function loadMicroPostsCollection() {
  const client = await MongoClient.connect(MONGODB_URL);
  return client.db('micro-blog').collection('micro-posts');
}

module.exports = router;
```

If you take a close look to this file now, you will notice that its new version makes your code more configurable by extracting some hard-coded values into `AUTH0_CLIENT_ID`, `AUTH0_DOMAIN`, and `MONGODB_URL`. From now on, these values will come from environment variables (`process.env`). As such, before executing the Express API locally again, you will have to set these three environment variables in your machine:

```bash
export AUTH0_CLIENT_ID=KsX...mBGPy
export AUTH0_DOMAIN=bk-tmp.auth0.com
export MONGODB_URL=mongodb://localhost:27017/

node ./backend/src/development-server.js
```

> **Don't forget**: The values presented above are for illustration only, use your own values. Mainly for the `AUTH0_CLIENT_ID` and `AUTH0_DOMAIN` variables.

### Wrapping your Express API with an AWS Lambda Proxy

After refactoring your Express API, you will use the `claudia` CLI tool to prepare a serverless proxy around it:

```bash
# make sure you are on the backend directory
cd backend

# generate the proxy
claudia generate-serverless-express-proxy --express-module src/index
```

Running the code above will result in the creation of a file called `lambda.js`. This file will act as the connection point between your Express API and the AWS Lambda infrastructure. As such, you should commit this file to your Git repository (you are committing stuff to Git, right?).

### Deploying your Express App to AWS Lambda

Now, to the most expected part of this section, the deployment of your Express API to AWS Lambda, you will have to define the `AWS_PROFILE` that Claudia.js will use. Then, you will have to define the `AUTH0_CLIENT_ID`, `AUTH0_DOMAIN`, and `MONGODB_URL` variables with the settings for the production deployment (i.e. use the Auth0 properties of the new tenant you created for production and the URL provided by mLab) so you can call `create` on its CLI:

```bash
# define the profile Claudia.js will use
export AWS_PROFILE=auth0
export AUTH0_CLIENT_ID=KsX...BGPy
export AUTH0_DOMAIN=bk-tmp.auth0.com
export MONGODB_URL=mongodb://micro-blog-db-user:357-DbPass@ds212391.mlab.com:21301/micro-blog

# make Claudia.js create the AWS Lambda function for you
claudia create \
  --handler lambda.handler \
  --deploy-proxy-api \
  --region us-east-1 \
  --set-env AUTH0_CLIENT_ID=$AUTH0_CLIENT_ID,AUTH0_DOMAIN=$AUTH0_DOMAIN,MONGODB_URL=$MONGODB_URL
```

> **Note**: Replace the value set to `AWS_PROFILE` to the name of the profile you added to `~/.aws/credentials` before. Also, replace `AUTH0_CLIENT_ID`, `AUTH0_DOMAIN`, and `MONGODB_URL` with your production settings. Besides that, you can choose an AWS region other than `us-east-1` to deploy your Lambda function.

This will result in a response like this:

```bash
saving configuration
{
  "lambda": {
    "role": "backend-executor",
    "name": "backend",
    "region": "us-east-1"
  },
  "api": {
    "id": "7kq5w1ilz2",
    "url": "https://7kq5w1ilz2.execute-api.us-east-1.amazonaws.com/latest"
  }
}
```

Here, you can grab the `url` of your new Lambda function.

If you are wondering what happened behind the scenes, the last step in the code snippet above ended up:

- creating a role called `backend-executor` that has the `log-writer` policy attached to it (needed so your Lambda functions can write to CloudWatch);
- creating the Lambda function (called `backend`) with your Express API code;
- and creating an API Gateway (also called `backend`) that does nothing else besides proxying requests to the Lambda function;

And that's it. You now have deployed your Express API to AWS Lambda with the help of Claudia.js. To test it, you can issue an HTTP GET request to it like so:

```bash
curl https://8qi5y1ils2.execute-api.us-east-1.amazonaws.com/latest/micro-posts
```

Just make sure you replace `8qi5y1ils2.execute-api.us-east-1.amazonaws.com` in the URL with the endpoint created by Claudia.js for you (you can find this info in the `url` property of the `api` object returned after invoking `claudia create`).

## Preparing your Vue.js App to AWS S3
### Creating a new Auth0 Client
### Extracting Environment Variables
### Creating an AWS S3 Bucket
### Uploading your Vue.js App to AWS S3

## Conclusion and Next Steps
