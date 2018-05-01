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

## Learning Angular Material

The idea of this is article is to teach you how to use Angular Material through a hands-on exercise. First, you will check the dependencies that you need in your computer to use and develop with Angular Material, then you will learn how to configure and use different components.

### Setting Up Your Project Environment

To work with Angular, you will need [Node.js](https://nodejs.org/en/) and [Angular CLI (Command Line Interface)](https://cli.angular.io/) installed in your development environment. Node.js will provide the packages needed by the CLI to work and the development server so you can check your progress in real time.

Angular CLI is the tool that helps you create a new Angular project and configure Angular components, services, and so on. You will need it because an Angular project is more than just HTML and script files. That is, An angular project uses [TypeScript](https://www.typescriptlang.org/) which needs to be transpiled and optimized to run browsers. Without Angular CLI, you would need to setup and wire a lot of tools to work together, which would consume too much time.

If you don't have Node.js installed in your computer, proceed to [the download page](https://nodejs.org/en/download/) and follow the instructions there (or use a tool like [N, a Node.js version manager](https://github.com/tj/n) to have multiple versions installed with ease). Then, after installing Node.js, use NPM (which comes along with Node.js) to install Angular CLI:

```bash
npm install -g @angular/cli
```

> **Note:** Depending on the setup of your computer, you might need to use `sudo` to use the `-g` (global) flag.

### Create a Project

### Install Angular Material and Angular CDK

### Install Animations Module

### Angular Material Theme

### Angular Material Gesture

### Material Icons

## What Will You Build

### Navigation

### Importing Material Components

### Working with Angular Material Components

### Angular Material and Flexbox

### More Angular Material Components

### Creating Routes

### Managing Data - Part 1

## Securing App  with Auth0

### Managing Data - Part 2

### Enabling Data Deletion

### Enabling Data Input

## Conclusion