---
layout: post
title: "Vue.js and AWS Lambda: Developing Production-Ready Apps (Part 1)"
description: "In this series, you will learn how to develop production-ready applications with Vue.js and AWS Lambda."
longdescription: "In this series, you will learn how to develop production-ready applications with Vue.js and AWS Lambda. Alongside with these technologies, you will use Express to define the endpoints that you will deploy on AWS Lambda and you will use MongoDB to persist data."
date: 2018-04-24 08:30
category: Technical Guide, Vue.js
author:
  name: "Bruno Krebs"
  url: "https://twitter.com/brunoskrebs"
  mail: "bruno.krebs@gmail.com"
  avatar: "https://twitter.com/brunoskrebs/profile_image?size=original"
design:
  bg_color: "#4A4A4A"
  image: https://cdn.auth0.com/blog/python-flask-angular/logo.png
tags:
- vue.js
- aws-lambda
- aws
- lambda
- spa
- auth0
related:
- 2018-03-29-vuejs-kanban-board-the-development-process
- 2017-04-18-vuejs2-authentication-tutorial
---

**TL;DR:** In this series, you will use modern technologies like Vue.js, AWS Lambda, Express, MongoDB, and Auth0 to create a production-ready application that acts like a micro-blog engine. The first part of the series (this one) will focus on the setup of the Vue.js client that users will interact with and on the definition of the Express backend app. [You can find the final code developed in this part in this GitHub repository](https://github.com/auth0-blog/vue-js-lambda-part-1).

## Stack Overview

Before starting with the hands-on exercises, let's take a brief overview of each piece that will compose your micro-blog engine.

### Vue.js

[As stated by the official guide, Vue.js is a progressive framework for building user interfaces](https://vuejs.org/v2/guide/). One of its focuses is on enabling developers to incrementally adopt the framework. That is, instead of demanding that developers use it to structure the whole application, Vue.js allows them to use it on specific parts to enhance the user experience on legacy apps. With that said, the guide also states that Vue.js is "perfectly capable of powering sophisticated Single-Page Applications (SPAs) when used in combination with modern tooling (like Webpack) and supporting libraries".

In this series, you will have the opportunity to see this great framework in action to create a SPA from the ground up.

### AWS Lambda

[AWS Lambda](https://aws.amazon.com/lambda/) is a serverless computer platform, provided by Amazon, that allows developers to run their code without having to spend too much time thinking about the servers needed to run it. Although the main idea of using a serverless platform is to facilitate the deployment process and the scalability of applications, AWS Lambda is not easy for newcomers. In fact, AWS Lambda on its own is not enough to run Rest APIs like the one you will need for your micro-blog engine. Besides this AWS service, you will also need to use [AWS API Gateway](https://aws.amazon.com/api-gateway/) to define how external services (or, in this case, a Vue.js client) can communicate with your serverless backend app. This last piece is exactly what makes AWS Lambda not straightforward.

So, to avoid wasting your time with the intricacies of AWS API Gateway and AWS Lambda, you will take advantage of an open-source tool called [Claudia](https://claudiajs.com/). The goal of this tool is to enable youto deploy your Node.js projects to AWS Lambda and API Gateway easily.

### Express

Express is the most popular framework for developing web applications on the Node.js landscape. By using it, you will have access to tons of (and great) documenation, a huge community, and a lot of middleware that will help you achieve your goals. In this series for example, you will use at least four popular middleware to define your backend enpoints: `bodyParser`, `cors`, `helmet`, and `morgan`.

If you haven't heard about them, you will find a brief explanation of what they are capable of doing and you will see that using them is pretty straightforward. You will also that defining endpoints and communicating with databases (in this case, MongoDB), cannot be easier.

### MongoDB

MongoDB is a popular NoSQL database that treats data as documents. That is, instead of the classic approach of defining data as tables and rows that relate with each other, MongoDB allows developers to persist and query complex data structures. As you will see, using MongoDB to persist JSON data sent by clients and processed by Node.js (or Express in this case) is really simple.

### Auth0

Handling identity on modern applications is not easy. For starter, if the developers choose to homegrown their own solution they will have to create everything from the sign up page, passing through the recovering password feature, till the handling of sessions and access tokens. Not to say that if they want to integrate with social networks like Facebook or Google, or if they want to allow users from companies that rely on Active Directory or SAML, they will face a scenario that is way more complex.

To avoid all these challenges and to enable you to focus on what matters the most to your application (its special features) you will take advantage of Auth0. With Auth0, a global leader in Identity-as-a-Service (IDaaS), you only have to write a few lines of code to get [solid identity management solution](https://auth0.com/user-management), [single sign-on](https://auth0.com/docs/sso/single-sign-on), support for [social identity providers (like Facebook, GitHub, Twitter, etc.)](https://auth0.com/docs/identityproviders), and support for [enterprise identity providers (Active Directory, LDAP, SAML, custom, etc.)](https://auth0.com/enterprise).

## What You Will Build

Throughout this series, you will use the stack described above (mainly Vue.js, Lambda, Express, and MongoDB) to create a micro-blog that contains a single public channel of micro-posts. That is, visitors (unauthenticated users) will be able to see all micro-posts and registered users will be able to express their minds publicly.

Although simple, this application will enable you to learn how to create secure, modern, and production-ready applications with Vue.js and AWS Lambda.

Now, regarding this specific part of the series, you will achieve the following objectives:

1. You will bootstrap your Vue.js application with `vue-cli`.
2. You will create your backend app with Express.
3. You will initialise a MongoDB instance and use it in your Express app.
4. You will enable identity management in both your Vue.js application and your Express backend with the help of Auth0.

So, without further ado, it's time to start developing!

## Vue.js, Express, and Mongo: Hands-On!

So, now that you know the stack that you will use and that you know what you will build, it's time to start creating your app. To keep things organised, you will create a directory to keep both you frontend and backend source code:

```bash
# create the root directory
mkdir vuejs-lambda

# move into it
cd vuejs-lambda
```

Then, as a responsible developer, you will make this directory a Git repository so you can keep your code safe and sound:

```bash
# initialize Git in the directory
git init
```

For now, there is nothing to save in your Git repository but, if you want to save some keystrokes in the future, you can define a Git alias to add and commit files:

```bash
git config --global alias.cm '!git add -A && git commit -m'
```

With this alias in place, you can just issue `git cm 'some message'` when you want to save your work.

### Bootstrapping Vue.js

To create your Vue.js application based on best practices, you will take advantage of [the `vue-cli` tool](https://github.com/vuejs/vue-cli/tree/master). So, before using this command line interface, you will have to install it in your machine:

```bash
npm install -g vue-cli
```

Then, in the root directory of your project, you will run the following command:

```bash
vue init webpack client
```

This command will make `vue-cli` ask a bunch of questions. You can answer them as follows:

- `Project name:` vuejs-micro-blog-engine
- `Project description:` A Vue.js Micro-Blog Engine
- `Author:` Your Name
- `Vue build:` Runtime + Compiler: recommended for most users
- `Install vue-router?` Yes
- `Use ESLint to lint your code?` Yes
- `Pick an ESLint preset:` Standard
- `Set up unit tests:` No
- `Setup e2e tests with Nightwatch?` No
- `Run npm install?` Yes, use NPM

> **Note:** If you are an advanced user, you can tweak the answers at will. For example, you can choose another [ESLint preset like Airbnb](https://www.npmjs.com/package/eslint-config-airbnb) or [choose to use Yarn](https://yarnpkg.com/en/) instead of NPM. However, keep in mind that if you change answers, the coding style shown here might not be the same as your project expects or that you will have to change a few of the commands shown.

After answering the questions appropriately, you can issue the following commands to check if your frontend Vue.js client is really working:

```bash
# move dir into your new client
cd client

# run the development server
npm run dev
```

The last command will run the development server on [`http://localhost:8080`](http://localhost:8080). So, if you open a browser and head to this address, you will see the following screen:

![Vue.js up and running.](https://cdn.auth0.com/blog/vuejs-lambda/vuejs-up-and-running.png)

Good, you can now stop your server by hitting `Ctrl + C` (or `⌘ + C` on a Mac) and save your work:

```bash
git cm 'bootstrapping the Vue.js client'
```

### Creating an Express Project

Now that you have your Vue.js frontend application skeleton defined, you can focus on scaffolding your backend application. For that, you will create a new directory called `backend` and install some dependencies:

```bash
# move back to the project root
cd ..

# create the backend dir
mkdir backend

# move into the backend directory
cd backend

# initialise NPM
npm init -y

# install dependencies
npm i express body-parser cors mongodb morgan helmet
```

So, as you can see, the commands above initialised NPM in the `backend` directory and installed six NPM packages:

- [`express`](https://github.com/expressjs/express): the most popular Node.js web application framework;
- [`body-parser`](https://github.com/expressjs/body-parser): an Express middleware that parses request bodies so you can access JSON objects sent by clients;
- [`cors`](https://github.com/expressjs/cors): an Express middleware to make your endpoint accept cross-origin requests;
- [`mongodb`](https://github.com/mongodb/node-mongodb-native): the MongoDB native driver for Node.js;
- [`morgan`](https://github.com/expressjs/morgan): an HTTP request logger middleware for Node.js web apps;
- and [`helmet`](https://github.com/helmetjs/helmet): an Express middleware that helps securing your apps with various HTTP headers.

> **Note:** If you want more information, you can check the official documentation of each package on the links above.

After installing all dependencies, you can create a new directory to hold the JavaScript source code and define the `index.js` file inside it:

```bash
# define a directory to hold the javascript code
mkdir src

# create the index.js file
touch src/index.js
```

Then, in this new file, you can add the following code:

```javascript
//import dependencies
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

// define the Express app
const app = express();

// enhance your app security with Helmet
app.use(helmet());

// use bodyParser to parse application/json content-type
app.use(bodyParser.json());

// enable all CORS requests
app.use(cors());

// log HTTP requests
app.use(morgan('combined'));

// start the server
app.listen(8081, () => {
  console.log('listening on port 8081');
});
```

As you can see, the code above is quite simple. From top to bottom, it:

1. starts by importing most of the packages that you installed before (the only one missing is `mongodb` because you will use it elsewhere);
2. then, it defines a new Express web application;
3. after that, it configures `helmet`, `bodyParser`, `cors`, and `morgan` middleware;
4. and, finally, it triggers the server on port `8081`.

Right now, there is no reason to start your Express application. Why? Because there are no endpoints defined on it and because you have no MongoDB instance to communicate with.

In the next section, you will initialise a MongoDB instance and then create a few endpoints to communicate with it. However, before proceeding into it, you will be better of creating two new files (in the project root) to help you in your development process.

The first one is a `.gitignore` file to keep you from commiting useless files into your Git repository. So, create this file in the project root directory and [copy the contents of this file into it](https://raw.githubusercontent.com/auth0-blog/vue-js-lambda-part-1/master/.gitignore). Or, if you prefer, you can also create and populate this file quite easily with the following commands:

```bash
# move to the project root
cd ..

# create and populate .gitignore
curl https://raw.githubusercontent.com/auth0-blog/vue-js-lambda-part-1/master/.gitignore >> .gitignore
```

After that, you can create the second file. This one, called `.editorconfig` will help you keeping your indentation style consistent. Again, [you can copy and paste the contents from the internet](https://raw.githubusercontent.com/auth0-blog/vue-js-lambda-part-1/master/.editorconfig), or you can use the following command:

```bash
curl https://raw.githubusercontent.com/auth0-blog/vue-js-lambda-part-1/master/.editorconfig >> .editorconfig
```

Great! Now, you are ready to save your progress and move to the next section:

```bash
git cm 'Scaffolding the Express web application.'
```

### Preparing a MongoDB Instance

After defining the basic structure of both your backend and frontend applications, you will need to initialise a MongoDB instance to persist your users' data. There are many options to create a new MongoDB instanc. For example:

1. You can install MongoDB in your development machine, but this would make the process of upgrading to newer versions harder.
2. You can use a MongoDB service like [MLab](https://mlab.com/), but this is a little extreme and slow for the development machine.
3. You can use Docker to initialise a container with a MongoDB instance.

Although the last alternative requires you to have Docker installed in your development machine, this is the best option for the development phase because it allows you to have multiple MongoDB instances at the same time in the same machine. So, if you don't have Docker already installed locally, head to [the Docker Community download page](https://www.docker.com/community-edition) and follow the instructions for your OS.

> **Note:** In the next article, you will create an MLab account to use a reliable and globally available instance of MongoDB. Don't worry, as any other service used in this series, MLab provides a free tier that is more than enough for this series.

After installing it, you can trigger a new MongoDB instance with the following command:

```bash
docker run --name mongo \
    -p 27017:27017 \
    -d mongo
```

Yup, that's it. It's easy like that to initialise a new MongoDB instance in a Docker container. For more information about it, you can check the instructions on [the official Docker image for MongoDB](https://hub.docker.com/_/mongo/).

## Integrating Vue.js, Express, and MongoDB

You now have all the basic building blocks in place and ready to be used. So, it's time to tie them up to see the stack in action.

For starters, you will create a new file called `routes.js` in the `backend/src` directory and add the following code to it:

```js
const express = require('express');
const MongoClient = require('mongodb').MongoClient;

const router = express.Router();

// retrieve latest micro-posts
router.get('/', async (req, res) => {
  const collection = await loadMicroPostsCollection();
  res.send(
    await collection.find({}).toArray()
  );
});

// insert a new micro-post
router.post('/', async (req, res) => {
  const collection = await loadMicroPostsCollection();
  await collection.insertOne({
    text: req.body.text,
  });
  res.status(200).send();
});

async function loadMicroPostsCollection() {
  const client = await MongoClient.connect('mongodb://localhost:27017/');
  return client.db('micro-blog').collection('micro-posts');
}

module.exports = router;
```

As you can seem, the code necessary to integrate your Express application with a MongoDB instance is extremely simple (for this basic app of course). In less than 30 lines, you defined two routes for your app: one for sending micro-posts to users and one to persist new microposts in the database.

Now, to use your new routes, you will have to update the `index.js` file (the one that resides in the `backend/src` directory) as follows:

```js
// ... other require statements
const routes = require('./routes');

// express app definition and middleware config

app.use('/micro-posts', routes);

app.listen(8081, () => {
  console.log('listening on port 8081');
});
```

Again, pretty straightforward, isn't it? You just had to `require` the new file and make your Express app aware of the routes defined on it through the `use` function.

With these changes in place, you can test your backend with the following commands (or with any HTTP client for that matter):

```bash
# move cursor to the backend directory
cd backend

# start up your Express app
node src

# fetches the micro-posts (for now, an empty array)
curl 0:8081/micro-posts

# add the first micro-post
curl -X POST -H 'Content-Type: application/json' -d '{
  "text": "I love coding"
}' 0:8081/micro-posts

# fetches the micro-posts again
curl 0:8081/micro-posts
```

As you now have your Express app integrated with a MongoDB instance, it's time to save your progress:

```bash
git cm 'integrating Express and Mongo'
```

## Handling Authentication with Auth0
### Integrating Auth0 and Your Vue.js App
### Securing Your Express App with Auth0

## Conclusion and Next Steps