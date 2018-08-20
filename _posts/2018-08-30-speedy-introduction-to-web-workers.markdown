---
layout: post
title: "Speedy Introduction to Web Workers"
description: "Learn how to use web workers in Javascript to create parallel programming and perform multiple operations simultaneously rather than interleaving them."
date: 2018-08-30 8:30
category: Technical Guide, Stack, Frontend
design: 
  bg_color: "#222228"
  image: https://cdn.auth0.com/blog/logos/redis-icon-logo.png
author:
  name: Dan Arias
  url: http://twitter.com/getDanArias
  mail: dan.arias@auth0.com
  avatar: https://pbs.twimg.com/profile_images/1002301567490449408/1-tPrAG__400x400.jpg
tags: 
  - web-workers
  - performance
  - parallelism
  - javascript
  - web
  - frontend
  - architecture
  - optimization
related:
  - 2016-02-22-12-steps-to-a-faster-web-app
  - 2015-10-30-creating-offline-first-web-apps-with-service-workers
  - 2016-12-19-introduction-to-progressive-apps-part-one
---

Creating blog posts at Auth0 is a process that involves multiple steps. In a nutshell, the following is an overview of our content development process:

- Create an outline.
- Review outline.
- Write the demo app.
- Write a blog post draft.
- Proof-read post.
- Review the final draft.
- Publish post.

At any time during this process there's an extra step that Content Engineers may have to take:

- Add assets to the content.

If the assets already exist, this step is as easy as including the assets within the body of the blog post. However, if the assets need to be created they need to be requested from the design team. If the Content Engineers were to design the assets by themselves, they would be blocked from developing and writing. This detour from the workflow would increase the time it takes to publish a post.

Thankfully, we count with a talented design team at Auth0 to whom we can delegate the creating of assets. We can ping them to put a request for assets on Slack. While they are working on designing the assets, we continue working on development and writing. When the design team is done with the assets, they ping us with a link from where we can download them. We then integrate the assets with the blog post and continue our work.

At no time, we get blocked from writing due to asset creation. The design team handles the task asynchronously on their own pipeline. The design team acts exactly how a web worker acts in JavaScript applications. JavaScript is a single-threaded language. As such, running expensive logic in the main thread can block it and make our JavaScript application seem slow or unresponsive. Using web workers, we can create a separate thread to run any logic without interrupting the main thread.

{% include tweet_quote.html quote_text="Web workers in Javascript allows us to create parallel programming to perform multiple operations simultaneously rather than interleaving them." %}

> [Interleaving](https://www.dictionary.com/browse/interleaving) means "to arrange (an operation) so that two or more programs, sets of instructions, etc., are performed in an alternating fashion."

Let's explore what we need to know to make use of web workers in JavaScript and what benefits it brings to a web application.

<br>
<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">HEY<br><br>USE WEB WORKERS</p>&mdash; Jason Miller 🦊⚛ (@_developit) <a href="https://twitter.com/_developit/status/995162140016177152?ref_src=twsrc%5Etfw">May 12, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">To free up the already-congested main thread so it can spend all of it&#39;s time on layout and paint 😃</p>&mdash; Jason Miller 🦊⚛ (@_developit) <a href="https://twitter.com/_developit/status/995792286947643392?ref_src=twsrc%5Etfw">May 13, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
<br>

## Why use JavaScript Web Workers?

Let's expand a bit more on what [Jason Miller](https://twitter.com/_developit) explained in his tweets.

In JavaScript, we can create parallel programming to perform multiple operations simultaneously using [web workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers). Web workers let us create background threads that are separate from the main execution thread, where we usually run our user interface logic. The core advantage of this workload separation is that we can run expensive operations within an isolated thread without interrupting or affecting the responsiveness and usability of the main thread. When the background thread completes its task it seamlessly notifies the main thread about the results through an event that is managed through regular [JavaScript event handling](https://eloquentjavascript.net/15_event.html).

{% include tweet_quote.html quote_text="Web workers are JavaScript objects that can be treated just like any other object: you can pass them around as function arguments, assign them to class properties, and since they have a common interface, even extend them!" %}

Web workers effectively enable a form of multi-threading in JavaScript with some restrictions such as not being able to access the DOM and not having access to the web worker's parent page (the page that created it). With that in mind, let's learn next how we can create web workers.
