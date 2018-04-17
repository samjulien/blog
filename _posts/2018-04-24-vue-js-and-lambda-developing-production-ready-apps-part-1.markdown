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

## Stack Overview
### Vue.js
### AWS Lambda
### Express
### MongoDB

## What You Will Build

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
### Preparing a MongoDB Instance

## Handling Authentication with Auth0
### Integrating Auth0 and Your Vue.js App
### Securing Your Express App with Auth0

## Conclusion and Next Steps