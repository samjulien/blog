---
layout: post
title: Configuring SwissID Login into Custom Applications
description: Learn how to support SwissID login into your custom applications with ease.
date: 2018-07-24 18:30
category: Technical Guide, Identity
author:
  name: Peter Fernandez
  url: https://twitter.com/HandsumQbn
  mail: peter.fernandez@auth0.com
  avatar: https://cdn.auth0.com/blog/guest-authors/peter-fernandez.png
design:
  bg_color: #4236c9
  image: https://cdn.auth0.com/blog/ml-kit-sdk/android-ml-kit-machine-learning-sdk-logo.png
tags:
- swissid
- oauth
- openid
- auth0
- social-connection
related:
- 2015-12-16-how-to-use-social-login-to-drive-your-apps-growth
- 2017-11-06-authenticated-identity-trusted-key-auth0
---

SwissID (https://swissid.ch) is the standardized digital identity initiative for use across Switzerland. It’s a joint venture of state-affiliated businesses, financial institutions, and health insurance companies - including Swiss Post and SBB – that provides interested application vendors with a third party Identity Provider service. Users retain exclusive sovereignty over their personal data, and online transactions are not only easier to process but are also more secure.

Application vendors natively implementing support for SwissID require a working knowledge of the OAuth 2.0 protocol and the OpenID Connect specification. Alternatively, Auth0 (https://auth0.com) now supports SwissID as a Custom Social Connection, making it easier for developers to integrate SwissID alongside a host of other Identity Provider services – such as Facebook, Google and LinkedIn – as well as add capabilities such as Single Sign On and Multi-Factor Authentication.

## Signing up to SwissID

As an application vendor (a.k.a. a Relying Party) you will first need to sign-up to SwissID. Starting the sign-up process can be done by contacting SwissID in order to become a Business Partner: https://www.swissid.ch/en/business-partners#become-a-part-of-a-success-story. Signing up with SwissID involves providing information about your redirection URI’s, and in turn you will be provide you with – amongst other things – a Client ID and Client Secret which will be required in order to setup SwissID within you Auth0 tenant. For details on signing up with Auth0 in order to create an Auth0 tenant please visit https://auth0.com)       

## Setup a SwissID Custom Social Connection in Auth0

You will also need to setup install the Custom Social Connections extension with your Auth0 tenant (https://auth0.com/docs/extensions/custom-social-extensions). The Custom Social Connections extension provides an easy way to manage social connections within Auth0 that are not supplied as ‘first class citizens’ out-of-the-box.
Once the Custom Social Connections extension is installed it can be used to setup a SwissID Custom Social Connection within Auth0. From the Custom Social Connections dialog click + New Connection to add a new connection:

This will bring up the New Connection dialog which can then be used to configure your SwissID connection as described in the section below.

## Configuring the SwissID Custom Social Connection in Auth0

Once SwissID sign-up is complete and you have your SwissID registration details, you can configure the SwissID Custom Social Connection within Auth0. Creating a new Custom Social Connection (as described in the section above) will provide a New Connection dialog in which the configuration information for SwissID can entered as shown below: 

The Name of the connection of the connection obviously reflects the fact that it is for SwissID, but can be something else if you so desire. Client ID and Client Secret will typically be provided as part of SwissID registration details; Client ID is typically supplied as-is, and Client Secret is typically supplied as Password. 
The Fetch User Profile Script is expanded below. The function declared in the script is fully customizable JavaScript, and is used to obtain the various supported claims from SwissID in order to build the profile for a User. SwissID provide a reference application which can be used to explore what claims are available, and also some of the other functions that are provided; their reference application it is located at:  https://login.int.swissid.ch/swissid-ref-app

## Testing the SwissID Custom Social Connection in Auth0

Once configured the TRY button can be used to verify that the configuration is successful; pressing it will typically present the SwissID login page, and once your credentials have been successfully presented a page similar to the following will be displayed by Auth0:

You can then use the Apps tab on the Connection page to enable the applications you want to use with SwissID (see https://auth0.com/docs/extensions/custom-social-extensions for further information).

## Configuring Auth0 Lock to use SwissID

By default, the out-of-box hosted Login page (which by default uses the Lock widget; https://auth0.com/docs/hosted-pages/login) will automatically display any and all connections enabled for an application. For out-of-box, first class connections – such as Facebook or Google – the Lock widget will automatically display an appropriate icon for the connection. However for custom connections – such as Swiss ID – only a default icon is displayed. 
However, Lock supports configuration options that can be used to tailor the look and presentation for any connection on either the login or the registration dialog. This allows you to host a logo for SwissID on your own CDN, and then tell Lock to use this logo – as in the following example (see https://auth0.com/docs/hosted-pages/login#how-to-customize-your-login-page for further details on customizing Lock and the hosted Login page):   

{% include asides/about-auth0.markdown %}
