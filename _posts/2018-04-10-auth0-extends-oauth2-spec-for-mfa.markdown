---
layout: post
title: "Auth0 Proposes OAuth 2.0 Extension for Multi-Factor Authentication"
description: "We have proposed an extension for the OAuth 2.0 specification that standardizes common MFA patterns and partially implemented it."
longdescription: "Auth0 has proposed a series of extensions to the OAuth 2.0 specification that bring the necessary endpoints to use multi-factor authentication in a standard way with any OAuth 2.0 server that implements them. In this article we take a look at the extensions and the current implementation at Auth0."
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
related:
- 2018-02-07-oauth2-the-complete-guide
- 2017-10-19-oauth-2-best-practices-for-native-apps
- ten-things-you-should-know-about-tokens-and-cookies
---

At Auth0 we use and support [OAuth 2.0]() extensively. Not only is it part of our core product, it is a fundamental piece of the identity landscape for major players such as Google, Facebook and Microsoft. Authentication and authorization are critical parts of any modern infrastructure. As such, better practices for securing the process have been developed. Multi-factor authentication/authorization is one of those practices. In this article, we explore a proposed extension to the OAuth 2.0 specification that standardizes the way OAuth 2.0 implementations interact with multi-factor solutions.

This article is split in three sections. The [first section]() provides a short recap of what OAuth 2.0 is and how current proprietary MFA solutions work. The [second section]() explains the OAuth 2.0 extensions for MFA proposed by us. The [third section]() showcases our current partial implementation that is ready for public testing. Read on!

{% include tweet_quote.html quote_text="Learn more about the OAuth 2.0 proposed draft for multi-factor authentication!" %}

---

## OAuth 2.0 and Current MFA Solutions
OAuth 2.0 is a framework that aims to separate the role of a client (such as a third-party service, or mobile application) from that of a resource owner (such as yourself). In contrast to traditional authorization solutions, OAuth 2.0 defines a series of mechanisms by which a client can request a special set of credentials that permit access to a protected resource from a resource server (that hosts the resource owner's data) by going through an additional party known as the authorization server. In this way, resource owners need not share their private credentials with the client. This increases security in several ways:

- Resource owner credentials are not shared, reducing the number of possible places for a security breach.
- Resource owner credentials need not be stored to provide better user experience.
- Access can be limited to the requested protected resource, rather than requiring the use of resource owner credentials that may have broader access characteristics.
- Access can easily be revoked to clients without affecting other clients.

To make things clearer, a simple, but very common example could be as follows. Let's say you, Joe, are a new user of a music streaming service: Sonar. The music streaming service requires users to complete a registration step with valid data, namely: the full name of the user, and a valid e-mail address. To improve user experience, the music streaming service allows users to login with Facebook. Facebook stores all the data that Sonar needs: a valid e-mail address and the full name of the user, so it makes sense for Sonar to allow users to simply use their Facebook accounts to login.

In a legacy scenario involving these players, Joe, Sonar (music service) and Facebook, Sonar could request Joe to input his or her Facebook credentials (e-mail and password), so that Sonar can login to Facebook as Joe and read all the necessary data. As you can imagine, this is a big no-no. What if Sonar reads more than simply Joe's e-mail and full name? What if Sonar posts as Joe? What if Sonar stores Joe's password and uses that data to access Facebook in the future even though Joe decided to stop using the service? What if Sonar breaks-up with his significant other?! These are all very bad scenarios, and in the past, they were commonplace.

![Legacy third-party information exchange](https://cdn.auth0.com/blog/oauth2-mfa/1-legacy-third-party-exchange.png)

OAuth 2.0 was designed to prevent scenarios such as the above, but for that to be possible, there has to be a protocol that all parties, Joe, Sonar, and Facebook, can talk to exchange information. OAuth 2.0 is a framework on top of which such protocol can be implemented. Continuing with the example above, this is how things would look like with OAuth 2.0. First, let's define some terms:

- **Resource owner**: Joe
- **Resource server**: Facebook
- **Protected resource**: Joe's e-mail and full name
- **Client**: Sonar (mobile and/or web app)
- **Authorization server**: Facebook (but it could be a different server entirely)

![OAuth 2.0 authorization for protected resource](https://cdn.auth0.com/blog/oauth2-mfa/2-oauth2-protected-resource-access.png)

So, when Joe, the rightful owner of his personal data on Facebook, decides to open Sonar's mobile client, Sonar's mobile app offers Joe the option to "Login with Facebook". Joe clicks on that and is taken through his web browser to a special Facebook page. The page reads something like:

> "Sonar is requesting access to your personal data (e-mail address and full name), do you want to grant Sonar access to that information?"

If Joe clicks "yes" he will be redirected to the Sonar mobile client. Without Joe seeing it, the Sonar mobile client will have received a special token (known as an access token), that allows Sonar to request Joe's personal information from Facebook directly. This token is very special:

- It is not related in any way to Joe's Facebook credentials. Sonar never sees this information at any point in the process.
- It can only access the information that Joe authorized Facebook to share with Sonar, namely his e-mail address and his full name. Nothing more.
- It has an expiration time. Regardless of Sonar using the token or not, it will expire and a new request will have to be made by Sonar to get a new, valid, access token.

Note that in this scenario we have not talked about authentication. Joe is already authenticated at Facebook (there is an existing session for him) so he only needs to grant Sonar access to the requested data. OAuth 2.0 defines a generic way to perform authorization operations. Although these operations can be used for authentication, OAuth 2.0 does not specifically define a means for that. It is for this reason that [OpenID Connect](), a related specification, was developed on top of OAuth 2.0: to define a simple identity layer on top of OAuth 2.0 that can be used for authentication. To learn more about OpenID Connect take a look at the [introduction in its specification](http://openid.net/specs/openid-connect-core-1_0.html#Introduction). 

### Multi-Factor Authentication
Common authentication solutions usually rely on a single piece of information to validate the identity of a user. In other words, if a malicious party gets access to this secret information, they can impersonate the user. We have seen this happen many times in the wild: stolen passwords, stolen credit cards, stolen social security numbers, stolen tokens, etc. Knowing this, the natural way of increasing the difficulty of impersonating a user is to simply add another authentication step.

Although it would be possible to require users to input separate passwords, this would not make much sense. If a malicious user was able to get one password, it is very likely they will be able to get a second, or even a third password! A different solution is required. This is where it makes sense to start talking about "factors". We call "factors" to different "ways" (i.e. authentication mechanisms) to validate the identity of a user. Each new "way" to authenticate a user, in the same authentication process, needs to be of a different type. There are essentially three types of authentication mechanisms, or factors: knowledge, possession, and inherence.

Passwords are of the *knowledge* type (i.e. something the subject *knows*). A *possession* factor, for example, could be a hardware authentication token that generates one-time codes. In contrast, an *inherence* factor would be a biometric marker, such as a user's fingerprint.

By adding a secondary factor, i.e. by combining different factors into a single authentication operation, the security of the system is improved. Even if our malicious user manages to get hold of a user's password, it is unlikely they will also manage to steal the user's fingerprint, or the user's hardware one-time-code-generating device.

### MFA In The Wild
The increasing security requirements for safeguarding sensitive information on the Internet have made multi-factor authentication a requirement for many use cases. Even in cases where it is not strictly necessary to enable MFA, it is still a good idea. Most service providers allow users to enable at least a second factor. Most of the time, this second factor is a mobile device, such as a smartphone or hardware token, but it can also be an e-mail, an SMS, a fingerprint, etc. Common examples of companies that *allow* users to enable MFA in their accounts are Facebook, Google, Apple, Twitter, Instagram. Examples of companies that *require* MFA are banks, security companies, and even government institutions.

However, one of the bigger problems in the authentication and authorization space is that of interoperability. OAuth 2.0, and other standards such as [SAML](), take steps to improve this, but they don't say much about MFA. In fact, all players in the identity space have developed their own proprietary solutions to integrate MFA with their architectures.

For this reason, we decided to implement two extensions to OAuth 2.0 that can handle all modern MFA scenarios: [OAuth 2.0 Multi-Factor Authorization]() and [OAuth 2.0 Multi-Factor Authenticator Association](). Please note that these specifications are drafts.

## Two Proposals for MFA in OAuth 2.0
The two extensions to OAuth 2.0 proposed in this post attempt to fulfil the following needs:

- To provide a way for OAuth 2.0 resource owners to require, remove, or change a strong authorization grant (that may imply multi-factor authorization) for certain resources.
- To provide a way for OAuth 2.0 clients to receive details about the strong authorization requirements of a resource.
- To provide a way to start and process a strong authorization grant operation.
- To allow support for different types of MFA solutions.

These proposals are conformant to the requirements specified in [OAuth 2.0's Extension Grants section](https://tools.ietf.org/html/rfc6749#section-4.5). We will first take a look at the [OAuth 2.0 Multi-Factor Authorization draft]() draft.

### OAuth 2.0 Multi-Factor Authorization
This proposal extends one OAuth 2.0 endpoint with more functionality (the `token` endpoint) and adds a new endpoint (the `challenge` endpoint).

The `token` endpoint in OAuth 2.0 is used to exchange `authorization grants` or `refresh tokens` for `access tokens`. In the case of the new `strong authorization grant` introduced by the proposal, the behavior remains the same: an access token is returned if the grant is deemed valid. In other words, the proposal simply adds a new type of grant that is handled by the `token` endpoint. It also changes the error response to indicate when a strong authorization grant is required. When it is, this endpoint also returns a `mfa_token` value. This value can be used with the new `challenge` endpoint to obtain a `strong authorization grant`. Additional parameters are required according to the MFA mechanism in place.

The new `challenge` endpoint is a bit more complicated. This endpoint can be used by clients to obtain a `strong authorization challenge`. This challenge is a special type of value that can be used to interact with the authentication factor to obtain the final `strong authorization grant`. The challenge endpoint gives clients, authorization servers, and resource owners the flexibility to support different types of authentication factors, and to negotiate an authentication factor that is supported by all. This endpoint may return additional data, in the form of additional parameters in the response body, that is required by the authentication factor to validate the request. This changes according to the authentication factor type. Additionally, this endpoint takes the `mfa_token` value returned by the `token` endpoint as input. This ensures all requests to these endpoints are linked in a single authorization session.

#### Time-Based One-Time Password Grant
![OAuth 2.0 TOTP Authorization](https://cdn.auth0.com/blog/oauth2-mfa/3-oauth2-totp-authorization.png)

#### Out-of-Band Verification Code Grant
![OAuth 2.0 OOB Authorization]()

### OAuth 2.0 Multi-Factor Authenticator Association
This proposal adds a new endpoint: the `associate` endpoint. This endpoint allows resource owners to manage authentication factors. It allows adding, removing or listing authentication factors. This endpoint is authenticated and requires an appropriate access token to use it.

A key aspect of this endpoint is that it allows for different types of authentication factors. The `authenticator_types` parameter describes three different types of authenticators:

- `otp`: One-time password authenticator
- `oob`: Out-of-band authenticator. An authenticator that can communicate in an unspecified way with the authorization server and the client (such as push notifications or SMS).
- `recovery-code`: A recovery-code that is issued by the authorization server at the moment of association. These codes can be used in case the authentication factor is unavailable.

In addition to these types of authenticators, the specification defines a series of common out-of-band authenticators. These can be specified in the `oob_channels` parameter: `sms`, `tel`, `email`, `auth0`, `duo`. Of course, authorization servers may support additional OOB channels other than the ones defined in the specification.

![OAuth 2.0 MFA Authenticator Association]()

## Auth0's Current Implementation
At Auth0 we have partially implemented the proposals. Our current implementation is ready for public testing, so, if you are interested in trying it out, you can request *early access* through a customer support ticket.

{% include tweet_quote.html quote_text="Auth0's implementation of the OAuth 2.0 MFA proposal is ready to test today!" %}

For now, we are only supporting the `resource owner password credentials grant` with an added `strong authorization grant`. This means that when MFA is enabled and an authentication factor is associated, a `resource owner password credential grant` request through the `token` endpoint will return an `mfa_required` error code just like the draft specs say. To continue with the authorization process, a `strong authorization grant` will need to be provided by accessing the `challenge` endpoint to pick a factor supported by both the client and the authorization server. After the MFA process is complete, the `strong authorization grant` along with the `resource owner password credentials grant` can be sent to the `token` endpoint to exchange them for an access token.

> Remember that in Auth0 these paths are relative to your user's domain (example: `https://speyrott.auth0.com/oauth/token`)

It is also important to note that one of the endpoints from the proposals has a different name in our implementation. The `associate` endpoint is called `authenticators` for now. Another implementation detail is that `challenge` and `authenticators` are located behind the `mfa` path on Auth0. In other words, the `challenge` endpoint, for example, is located at `/mfa/challenge`.

For now, we are not supporting the `strong authorization grant` in combination with grants other than the `resource owner password credentials grant`. This means that the `authorization code grant`, `implicit grant`, and the `client credentials grant` do not return the `mfa_required` error code even if there are associated authenticators. Note that this does not mean MFA is not supported for these grants, the usual proprietary MFA mechanism from Auth0 will work just as it always has.

To get a better grasp of how it all works together, let's take a look at how OAuth 2.0 MFA looks with Auth0 with two examples. For these examples we assume an Auth0 account with early access enabled for these features.

### Mobile Client
### CLI Client
### Working With Multiple Secondary Factors
An interesting aspect of the generic way in which MFA is implemented in these proposals is that it is possible to use multiple authenticators. This practice is rather uncommon in current proprietary solutions. A good example where this would make sense is in the case of a lost factor. For example, if the user chose to use a time-based one-time password solution with a mobile application such as [Google Authenticator](), they could use a different MFA solution in case the smartphone is lost or stolen.

Multiple authenticators also make sense in the context of stricter security requirements. An enterprise may require certain assets to be protected with a stronger authentication factor, such as a hardware token that generates one time codes. For other assets, where convenience is more important than stricter security, it may make sense to have an e-mail address as a second factor, while keeping the hardware token as a fallback mechanism.

![Multiple Authenticators]()

The `associate` endpoint also opens up the possibility of resource owners managing authenticators themselves. An authorization server may provide an interface to easily list, add, update, or remove authentication factors and associated protected resources. So, for example, a user may require a stronger authenticator for risky operations, such as payments, while other operations may be served by a more convenient MFA method such as e-mail.

## Conclusion
The proposals for OAuth 2.0 MFA provide a convenient path for implementing multi-factor authorization and authentication in a way that remains flexible and interoperable with existing solutions. They also provide additional benefits like the possibility of using multiple authentication factors or allowing resource owners to manage them from a client. Auth0's partial implementation provides a way for testing these ideas today. Check it out and let us know what you think in the comments or through our support system. Cheers!
