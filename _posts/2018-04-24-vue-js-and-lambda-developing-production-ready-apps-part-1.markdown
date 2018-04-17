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
### Vue.js
### AWS Lambda
### Express
### MongoDB
### Auth0

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

## Handling Authentication with Auth0
### Integrating Auth0 and Your Vue.js App
### Securing Your Express App with Auth0

## Conclusion and Next Steps