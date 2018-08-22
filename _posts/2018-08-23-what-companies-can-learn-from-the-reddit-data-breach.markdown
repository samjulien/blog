---
layout: post
title: "What Companies Can Learn From The Reddit Data Breach"
metatitle: "What Companies Can Learn From The Reddit Data Breach"
description: "Learn how advanced forms of two-factor authentication and identity management can prevent data breaches."
metadescription: "In July 2018, a copy of Reddit's user data was stolen. Learn how advanced forms of two-factor authentication and identity management can prevent data breaches."
date: 2018-08-23 12:30
category: Security, Breaches
author:
  name: Martin Gontovnikas
  url: http://twitter.com/mgonto
  mail: gonto@auth0.com
  avatar: https://www.gravatar.com/avatar/df6c864847fba9687d962cb80b482764??s=60
design:
  bg_color: "#6B5282"
  image: https://cdn.auth0.com/blog/mitigate/security-measures-main.png
tags:
  - security
  - data
  - breach
  - data-breach
  - reddit
  - enterprise
  - mfa
  - two-factor
  - authentication
  - identity
  - 2fa
related:
  - 2017-11-10-4-security-measures-after-data-breach
  - 2017-12-08-how-poor-identity-access-management-equals-security-breaches
  - 2016-03-17-data-breach-response-planning-for-startups
---

On June 19, [Reddit learned that an attacker had breached several employee accounts](https://www.reddit.com/r/announcements/comments/93qnm5/we_had_a_security_incident_heres_what_you_need_to/?st=jkk18vb3&sh=ad92bacb) via the company's cloud and source-code hosting providers:

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/what-companies-can-learn-from-the-reddit-data-breach/reddit-data-breach-release-note.png" alt="Reddit data breach release note.">
</p>

[[Source](https://www.reddit.com/r/announcements/comments/93qnm5/we_had_a_security_incident_heres_what_you_need_to/?st=jkk18vb3&sh=ad92bacb)]

No Reddit information was altered, and the company quickly moved forward to lock down proprietary data, but it's still caused ripples of concern among Reddit's community of users. The theft contained a complete copy of an old database backup that held personal data from Reddit's early users. This largely included account credentials (username + salted hashed passwords), email addresses, and messages — valuable information that thieves can recycle to access other accounts, such as health or financial records.

This is one of hundreds of breaches this year. According to Statista, [the U.S. has seen 668 data breaches](https://www.statista.com/statistics/273550/data-breaches-recorded-in-the-united-states-by-number-of-breaches-and-records-exposed/) that have exposed more than 22 million personal records.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/what-companies-can-learn-from-the-reddit-data-breach/2018-us-data-breaches-by-the-numbers" alt="2018 US data breaches by the numbers.">
</p>

The pace of break-ins has been steadily rising for over a decade.

How do companies like Reddit protect themselves in an increasingly dangerous environment? This piece digs into key strategies you can use to brace your company against attacks before they happen — and tells you what to do if the unfortunate occurs.

## Why Didn't Two-Factor Authentication Stop Reddit's Data Breach?

Although Reddit employed a [two-factor authentication](https://auth0.com/learn/two-factor-authentication/) (2FA) shield, it was SMS-based, and the main attack occurred via SMS intercept.

All forms of 2FA require a user to provide a second form of identification — over and above a simple password — to gain access to a system. The most common 2FA method sends the user a unique token via SMS/text message.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/what-companies-can-learn-from-the-reddit-data-breach/text-message-two-factor-authentication-code.jpg" alt="Text messaging showing two-factor authentication code.">
</p>

[[Source](https://spriv.com/automated-two-factor-authentication/)]

This is generally a 5- to 10-digit code, which the user types in after the successful entry of their username and password. Many enterprises have opted for this method because [two-factor authentication is user-friendly](https://www.appcues.com/blog/privacy-conscious-consumer) (nearly everyone is familiar with receiving text messages) and is inexpensive to set up.

Yet the method clearly has holes. SMS 2FA is vulnerable to swings in cell-phone connectivity and can be easily intercepted by third parties.

A more secure version is employing software tokens. Software tokens in 2FA have gained popularity in recent years with the rise of smartphones.

The [Microsoft Authenticator](https://docs.microsoft.com/en-us/azure/multi-factor-authentication/end-user/microsoft-authenticator-app-how-to) is an example of a popular software token-based solution, which could have provided Reddit a tighter wall against hackers.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/what-companies-can-learn-from-the-reddit-data-breach/microsoft-authenticator.png" alt="Microsoft Authenticator app in action.">
</p>

The Microsoft Authenticator is one of many similar tools, including the Google Authenticator, Twilio Authenticator, and LastPass Authenticator. They all rely on a time-based one-time password (TOTP) algorithm to generate a short-lived (30 seconds or less) password. The user must [copy the password into the website](https://uk.godaddy.com/blog/how-to-avoid-web-design-mistakes-that-could-sabotage-your-business/)'s or app's required field for verification before it expires.

{% include tweet_quote.html quote_text="SMS 2FA is vulnerable to swings in cell-phone connectivity and can be easily intercepted by third parties. A more secure version is employing software tokens." %}

### Other Forms of 2FA That Could Have Stopped the Reddit Data Breach

Hardware tokens are another method that many enterprises use. They rely on a physical device, such as a key fob or USB dongle, that generates a token for the user.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/what-companies-can-learn-from-the-reddit-data-breach/duo-hardware-authentication-token.png" alt="DUO hardware token for two-factor authentication">
</p>

[[Source](https://guide.duo.com/tokens)]

Unlike SMS and software tokens, hardware tokens don't require cell-phone reception or even Wi-Fi; however, they are costly to set up and maintain. In addition, employees often misplace hardware tokens or confuse them with other personal devices.

Several teams rely on email or phone verification, where the user receives a link or a voice recording with an alphanumeric token. While these options are also relatively inexpensive and easy to set up, they can, like SMS tokens, fail in delivery and are vulnerable to interceptions.

An exciting area of [multifactor authentication (MFA) that is on the rise is biometrics](https://auth0.com/blog/identity-as-a-service-in-2018/). This eliminates additional devices altogether and instead relies on a user's inherent credentials, such as fingerprints, a retina, or even gait.

## Incorporate 2FA as Part of a Larger Identity Strategy to Stop Cyber Theft

Two-factor authentication is a critical component of security for enterprises today — despite [the fact that only 28% of people employ 2FA](http://fortune.com/2017/11/07/cybersecurity-2fa-two-factor-authentication/). While it's important to help all of your users implement 2FA, there are other elements of identity management that companies like Reddit should consider.

For example, identity-management providers like [Auth0 have several Rules](https://auth0.com/docs/rules/current) that its users can turn on quickly to immediately detect fraud within a system and take action against it. A dashboard view also allows system administrators to observe all of the activity that is taking place at a given time.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/what-companies-can-learn-from-the-reddit-data-breach/auth0-dashboard.jpg" alt="Auth0 Dashboard">
</p>

Instead of trying to work with disparate streams of user data (e.g., new sign-ups in one place and historical usage over time in another), a well-constructed dashboard can offer multiple visualizations of this information in the same location. From there, admins can take swift action when they see something is amiss.

With Auth0's [anomaly-detection feature](https://auth0.com/docs/anomaly-detection), you can implement several shields from the dashboard that will block users after a certain number of failed login attempts. In addition, if you know that their information was recently compromised in a major security incident, you can screen for logins from these accounts. For example, if Reddit makes the information available, Auth0 will flag these emails in case the Reddit thieves are using these credentials to impersonate the users.

The more steps you can take to build out your identity management system, the better off you will be as attacks come from multiple angles.

## How to Help Users After a Data Breach Occurs

The most important thing to do when you learn that your system has been compromised is to immediately communicate it and take action.

1.  Report the breach to law enforcement, including any data you have on the number and types of accounts the thieves were able to access.
2.  Test the accounts that you believe might have been compromised by sending emails or otherwise attempting to verify if the account holders are still who they say they are.
3.  Immediately improve your login systems and any current 2FA approaches, and consider [outsourcing more elements of your identity-management system](https://auth0.com/b2e-identity-management-for-employees) to experts.

Reddit quickly [published data breach mitigation steps on its site](https://www.reddit.com/r/announcements/comments/93qnm5/we_had_a_security_incident_heres_what_you_need_to/?st=jkk18vb3&sh=ad92bacb):

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/what-companies-can-learn-from-the-reddit-data-breach/reddit-data-breach-mitigation-steps-notice.png" alt="Reddit data breach mitigation steps notice.">
</p>

Offering immediate, actionable steps accompanied by links to more detailed pages of information is a great way to help your users without overwhelming them with technical information.

{% include tweet_quote.html quote_text="The most important thing to do when you learn that your system has been compromised is to immediately communicate it and take action." %}

Hopefully, you won't have to employ these final tactics; however, given today's challenging threat environment, particularly for teams with large user bases, it's critical to stay up to date on the latest solutions and security strategies to avoid a worst-case scenario.

{% include asides/about-auth0.markdown %}
