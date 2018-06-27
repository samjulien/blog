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
