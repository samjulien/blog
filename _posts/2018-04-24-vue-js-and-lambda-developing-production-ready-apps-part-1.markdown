---
layout: post
title: "Vue.js and AWS Lambda: Developing Production-Ready Apps (Part 1)"
description: "In this series, you will learn how to develop production-ready applications with Vue.js and AWS Lambda."
longdescription: "In this series, you will learn how to develop production-ready applications with Vue.js and AWS Lambda. Alongside with these technologies, you will use Express to define the endpoints that you will deploy on AWS Lambda and you will use MongoDB to persist data."
date: 2018-04-03 08:30
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
### Creating an Express Project
### Preparing a MongoDB Instance

## Handling Authentication with Auth0
### Integrating Auth0 and Your Vue.js App
### Securing Your Express App with Auth0

## Conclusion and Next Steps