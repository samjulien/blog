---
layout: post
title: "React Tutorial: Building and Securing Your First App"
description: "Learn how React works and create and secure your first React app in no time."
date: 2018-07-03 08:30
category: Technical Guide, First Application, React
author:
  name: "Bruno Krebs"
  url: "https://twitter.com/brunoskrebs"
  mail: "bruno.krebs@gmail.com"
  avatar: "https://cdn.auth0.com/blog/profile-picture/bruno-krebs.png"
design:
  bg_color: "#1A1A1A"
  image: https://cdn.auth0.com/blog/logos/react.png
tags:
- react
- tutorial
- development
- authentication
- auth0
- security
- spa
- auth0
related:
- 2017-11-28-redux-practical-tutorial
- 2018-08-14-react-context-api-managing-state-with-ease
---

**TL;DR:** In this article, you will learn the basic concepts of React. After that, you will have the chance to use React in action while creating a simple Q&A (Questions & Answers) app that relies on a backend API. If needed, you can check [this GitHub repository to check the code that supports this article](https://github.com/auth0-blog/react-tutorial). Have fun!

## Prerequisites

Although not mandatory, you should know a few things about JavaScript, HTML, and CSS before diving in in this tutorial. If you do not have previous experience with these technologies, you might not have an easy time following the instructions in this article and it might be a good idea to step back and learn about them first. If you do have previous experience with web development, then stick around and enjoy the article.

Also, you will need to have Node.js and NPM installed in your development machine. If you don't have these tools yet, please, [read and follow the instructions on the official documentation to install Node.js](https://nodejs.org/en/download/). NPM, which stands for Node Package Manager, comes bundled into the default Node.js installation.

Lastly, you will have to have access to a terminal in your operating system. If you are using MacOS X or Linux, you are good to go. If you are on Windows, you will probably be able to use [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) without problems.

## React Introduction

[React](https://reactjs.org/) is a JavaScript library that Facebook created to facilitate the development of [Single-Page Applications (a.k.a. SPAs)](https://en.wikipedia.org/wiki/Single-page_application). Since Facebook open-sourced and announced React, this library became extremely popular all around the world and gained mass adoption by the developer community. Nowadays, although still mainly maintained by Facebook, other big companies (like [Airbnb](https://www.airbnb.com/), [Auth0](https://auth0.com/), and [Netflix](http://netflix.com/)) embraced this library and are using it to build their products. If you check [this page, you will find a list with more than a hundred companies that use React](https://github.com/facebook/react/wiki/Sites-Using-React).

In this section, you will learn about some basic concepts that are important to keep in mind while developing apps with React. However, you have to be aware that the goal here is not to give you a complete explanation of these topics. The goal is to give you enough context so you can understand what is going on while creating your first React application.

For more information on each topic, you can always consult [the official React documentation](https://reactjs.org/).

### React Components

Components in React are the most important pieces of code. Everything you can interact with in a React application is (or is part of) a component. For example, when you load a React application, the whole thing will be handled by a root component that is usually called `App`. Then, if this application contains a navigation bar, you can bet that this bar is defined inside a component called `NavBar` or similar. Also, if this bar contains a form where you can input a value to trigger a search, you are probably dealing with another component that handles this form.

The biggest advantage of using components to define your application is that this approach lets you encapsulate different parts of your user interface into independent, reusable pieces. Having each part on its own component facilitates reasoning about each piece in particular, testing each piece, and reusing them whenever applicable. When you start finding your bearings with this approach, you will see that having a tree of components (that's what you get when you divide everything into components) also facilitates state propagation.
