---
layout: post
title: "Developing Real-Time Web Applications with Server-Sent Events"
description: "Learn how to create real-time web applications by using the Server-Sent Events specification."
date: 2018-08-31 08:30
category: Technical Guide, Backend
author:
  name: "Andrea Chiarelli"
  url: "https://twitter.com/andychiare"
  mail: "andrea.chiarelli.ac@gmail.com"
  avatar: "https://pbs.twimg.com/profile_images/827888770510880769/nnvUxzSd_400x400.jpg"
design:
  image: https://cdn.auth0.com/blog/api-introduction/logo.png
  bg_color: "#202226"
tags:
- real-time
- backend
- node-js
- react
- server-sent-events
- sse
- javascript
related:
- 2018-06-12-real-time-charts-using-angular-d3-and-socket-io
- 2017-11-21-developing-real-time-apps-with-meteor
---

**TL;DR:** [Server-Sent Events (SSE)](https://html.spec.whatwg.org/multipage/server-sent-events.html) is a standard that enables Web servers to push data in real time to clients. In this article, we will learn how to use this standard by building a flight timetable demo application with React and Node.js. However, the concepts you will learn following this tutorial are applicable to any programming language and technology. [You can find the final code of the application in this GitHub repository](https://github.com/andychiare/server-sent-events).