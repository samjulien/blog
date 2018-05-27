---
layout: post
title: "Upgrade Your AngularJS Authentication"
description: "In this article, we’re going to talk about two difficult subjects: ngUpgrade and authentication."
longdescription: "In this article, we’re going to talk about two difficult subjects: ngUpgrade and authentication. First, we’ll cover the foundations of upgrading a real application from AngularJS to Angular. Then, we’ll look at a practical example of upgrading AngularJS authentication strategies to Angular."
date: 2018-05-22 17:28
category: Technical Guide, Angular
author:
  name: "Sam Julien"
  url: "https://www.upgradingangularjs.com/"
  avatar: "https://cdn.auth0.com/blog/guest-authors/sam-julien.jpeg"
design:
  bg_color: "#012C6C"
  image: https://cdn.auth0.com/blog/logos/angular.png
tags:
- angular
- angularjs
- ngupgrade
- authentication
- auth0
related:
- 2016-09-29-angular-2-authentication
- 2017-06-28-real-world-angular-series-part-1
---

**TL;DR:** In this article, we’re going to talk about two notoriously difficult subjects very near and dear to my heart: ngUpgrade and authentication. First, we’ll cover the foundations of upgrading a real application from AngularJS to Angular. Then, we’ll look at a practical example of upgrading AngularJS authentication strategies to Angular. We’ll look at a sample app that uses machine-to-machine authentication with Auth0.

> This article is based on a talk I gave for [the Auth0 online meet up](https://www.meetup.com/Auth0-Online-Meetup/). [You can watch the recording of that talk here](https://register.gotowebinar.com/register/7495371156540204033) and [access the slides here](https://www.upgradingangularjs.com/auth0).

## ngUpgrade Foundations

Back in late 2016, I was going through some very painful issues trying to upgrade my company’s apps from AngularJS to Angular. I was completely overwhelmed and totally lost. Rather than rage-flip my desk and go live in a cave, I decided to channel my frustrations into learning everything I could about the upgrade process and documenting it along the way for the community. That’s where my video course [Upgrading AngularJS](https://www.upgradingangularjs.com/?ref=auth0) came from: my own blood, sweat, and tears of figuring this process out. I’m hoping to save other people the hundreds of hours that I put into it.

That’s also why I’m writing articles like this one — to help you save time. 

### ngUpgrade Background

Let’s start with a bit of background. AngularJS (1.x) is going to be entering a [long term stable schedule](https://blog.angular.io/stable-angularjs-and-long-term-support-7e077635ee9c) starting July 1st, 2018, and lasting through June 30, 2021. The last stable version is going to be version 1.7. So, where does that leave us? That leaves us with the new Angular (2+). You’ve now got this bridge period to determine if you need to upgrade and, if so, to complete that upgrade using the ngUpgrade library.

Most of the time, you should upgrade, but there are a handful of exceptions. The main exception is if your application is just going to lay dormant from now on. If you’re never going to do anymore feature development on it, you don’t need to upgrade. The AngularJS packages and CDNs will stay around forever. You don’t need to worry about your legacy code evaporating into thin air and being unable to do anything about it.

That being said, if you are doing feature development, you should do yourself a favor and move over to Angular. Angular is much faster, has a lot better features, and has lots of architecture and data flow best practices already baked into the framework. Don’t worry, though. You don’t have to do it all in one shot — you can do it gradually and take the time that you need do it right.

Another question I get asked a lot is, “Should I just rewrite everything to React/Vue/whatever?” Most of the time, the answer is no, unless you’ve already got team members who have that expertise (or you just, for whatever reason, really want to move to a different framework). It’s very unlikely it’s going be easier to move to another framework. The ngUpgrade library, which is the `@angular/upgrade/static` package, is explicitly made to bridge the gap between AngularJS and Angular. There’s no such equivalent library for React or Vue.