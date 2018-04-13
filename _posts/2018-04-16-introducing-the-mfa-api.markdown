---
layout: post
title: "Introducing the Multi-Factor Authorization API"
description: "Embed Multi-Factor Authorization using push notifications, SMS, or TOTP anywhere, taking full control of the experience."
longdescription: "We have developed a new API to make use of Multi-Factor Authorization through an HTTP API, allowing developers to take full control of the experience. Push notifications, SMS, and TOTP are supported. In this article we take a look at the API while developing a CLI application."
date: 2018-04-10 12:30
category: Announcements, Content
author:
  name: Sebastián Peyrott
  url: https://twitter.com/speyrott?lang=en
  mail: speyrott@auth0.com
  avatar: https://en.gravatar.com/userimage/92476393/001c9ddc5ceb9829b6aaf24f5d28502a.png?size=200
design:
  bg_color: "#222228"
  image: https://cdn.auth0.com/blog/jwtalgos/logo.png
  image_size: "100%"
  image_bg_color: "#222228"
tags:
- oauth
- oauth2
- mfa
- rfc
- ietf
- network
- working
- group
- multi-factor
- authentication
- authorization
- otp
- totp
- push
- push-notifications
- guardian
- authenticator
- google-authenticator
- duo
related:
- 2018-02-07-oauth2-the-complete-guide
- 2017-10-19-oauth-2-best-practices-for-native-apps
- ten-things-you-should-know-about-tokens-and-cookies
---

We are pleased to announce the availability of our [Multi-Factor Authorization API](). Up to now, we have provided support for MFA through a simple switch in the Auth0 Dashboard, following our premise of *simplicity* and ease of use. However, we also believe in providing powerful *building blocks* for our users. For this reason we have developed a new API to perform the full MFA flow in a flexible and convenient way. In this article we will take a look at the API and build a simple CLI app to demonstrate how to use it. Read on!

{% include tweet_quote.html quote_text="The MFA API is now available, learn how to embed MFA in your apps taking full control of the experience!" %}

---

## Why?
Up to now, enabling MFA at Auth0 was simply a matter of flipping a switch and optionally selecting which client you wanted to enable MFA for. When MFA is enabled, hitting the `/authorize` endpoint or starting an authorization flow through one of our libraries was enough to trigger MFA. Simple, convenient.

![MFA Switch]()

However, some of our customers, like [Commonwealth Bank of Australia](), have requested to have more control over the MFA process. For this reason we have developed a new API to give back control to you when required. Let's check it out.

![Commonwealth Bank of Australia Logo]()

## A Simple API
The API works by introducing some changes to how the `/token` endpoint behaves. Let's take a look.

{% include tweet_quote.html quote_text="The new MFA API is simple, it works on top of the existing /token endpoint." %}

The API works in four simple steps:

1. Access token request to `/token`.
2. Challenge request to `/challenge`.
3. Asking the user for a code (if necessary).
4. Final request to `/token`.

> This scenario assumes the user is already enrolled in MFA and has at least one authenticator enabled. There's also a [new API for enrollment]() to have full control over the enrollment process as well.

### 1. Access Token Request to `/token`
When a request is made to the `/token` endpoint to get an access token, normally you either get an error, or you get an access token. However, when the MFA API is enabled, the `/token` endpoint may return a new error code: `mfa_required`.

The `mfa_required` error means that MFA is enabled for this specific request and an additional, stronger grant is required before getting the access token.

When the `mfa_required` error is triggered, a new type of token, the `mfa_token` is returned along with it. This token serves as a temporal kind of token that is required to perform the remaining steps in the multi-factor authorization process. The next step in this process is called the `challenge`.

### 2. Perform an MFA Challenge
When MFA is enabled and required, which the client learns through the `mfa_required` error code, it must then start the MFA process by requesting a `challenge`.

A challenge is a special type of request that serves three purposes:

- To negotiate the use of an authorization factor that is supported by both the client and the authorization server.
- To inform the client of the requirements of the MFA process. For instance, it may signal the client that a TOTP code must be entered. This way the client knows it must prompt the user for the code.
- To trigger any additional actions that may be required as part of the MFA process. For example, if the MFA process works through push notifications, this triggers the notification in the user's authenticator.

The challenge request is performed by sending an HTTP request to the `/mfa/challenge` endpoint. This request includes the `mfa_token` along with information about the challenges supported by the client (TOTP, push, SMS, etc.). The authorization server replies by picking a MFA mechanism supported by both and provides the client with all the needed information to continue the process. For example, if an SMS code is required, it tells the client "ask the user for a code"; or if push notifications are used, it tells the client to "poll the authorization server to see if the request has been authorized".

### 3. Prompt For Input (If Necessary)
For the MFA methods that require the user to input a code into the client application, like SMS or TOTP, this is the moment when this happens. Some methods, like push notifications, handle all communications between the authenticator and the authorization server behind the scenes. For those cases, the client is expected to skip this step and go right into the next one.

### 4. Get The Access Token
Now that the client has all the necessary information to perform a stronger authorization request, it may perform a new request to the `/token` endpoint.

For the cases where the user must provide a code, the client must wait until this code is entered before performing this request.

For all other cases, the client is expected to perform the request right away. If the user has not interacted with the authenticator yet, the authorization server will reply with a `authorization_pending` error code. The client is expected to repeat the request after waiting some time. The authorization server may also reply with an `slow_down` error code signalling the client to wait more between consecutive requests.

This request to the `/token` endpoint does not include the credentials passed in step 1. Instead, the `mfa_token` is used in their place. This request includes the code entered by the user (if any) and may require additional parameters according to the MFA method (these are returned by the `/challenge` endpoint in step 2).

That's it! If all went well, you now have an access token issued through MFA!

## Example: A CLI App with MFA
To give you a better understanding of how the API works we have developed a [simple CLI app that uses MFA](https://github.com/auth0-blog/oauth2-mfa-cli-example).

![]()

Take a look at the [full code in GitHub](https://github.com/auth0-blog/oauth2-mfa-cli-example). You will find the interesting bits in the `/token-endpoint.mjs` file, particularly in the `token` function.

To use the app, make sure that:
- You have created a new [Application]() in the Auth0 Dashboard. Select the `Machine-to-Machine type`.
- The `token authentication method` is set to `none` in the Auth0 Application settings.
- You have enabled the `Password` and `MFA` grants in `Application -> Advanced Settings -> Grant Types`. You may need to request early access through a support ticket to see the `MFA` grant option.
- You have MFA enabled. Go to [Multifactor Auth](https://manage.auth0.com/#/guardian) and enable SMS and push notifications for [Guardian]().
- You have set the right client ID (get this from the [application]() settings area) in the MFA rule in the [Multifactor Auth](https://manage.auth0.com/#/guardian) section. Otherwise MFA will be enabled for all clients.

To use the app simply do:

```sh
git clone git@github.com:auth0-blog/oauth2-mfa-cli-example.git
cd oauth2-mfa-cli-example
npm install
node src/index.js login
```

The app supports some other commands. You can take a look at them by running it with no arguments.

## Conclusion
The MFA API brings flexibility to the use of MFA in your apps. One thing you may have noticed is that we are using the [OAuth 2.0 `/token` endpoint](). In fact, we designed this to be compatible with OAuth 2.0 right from the start. We have prepared two specification drafts, [one for MFA](), [the other for authenticator association](), to be sent to the IETF OAuth 2.0 Working Group. Other implementations of OAuth 2.0 can follow these specifications to implement MFA in a flexible, yet powerful way, while remaining compatible. We will have more information about this in an upcoming post.

We can't wait to see how you use this API to build powerful multi-factor flows! Let us know what you think in the comments.

{% include tweet_quote.html quote_text="We can't wait to see how you use this API to build powerful multi-factor flows!" %}
