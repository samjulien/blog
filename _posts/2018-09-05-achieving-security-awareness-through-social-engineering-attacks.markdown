---
layout: post
title: "Blackhat Training: Achieving Security Awareness Through Social Engineering Attacks"
metatitle: "Achieving Security Awareness Through Social Engineering Attacks"
description: ""
date: 2018-09-05 10:00
category: Identity, Auth0 Engineering
author:
  name: "Anny Villarroel"
  url: ""
  mail: "annybell.villarroel@auth0.com"
  avatar: ""
design:
  bg_color: "#000000"
  image: https://cdn.auth0.com/blog/logos/black-hat-logo.png
tags:
  - training
  - security
  - social-engineering
  - identity
  - awareness
  - social-media
  - phishing
  - blackhat
related:
  - 2018-07-06-strong-emphasis-on-customer-identity-at-identiverse-2018
  - 2017-05-29-the-firewall-of-the-future-is-identity
  - 2017-12-08-how-poor-identity-access-management-equals-security-breaches
---

I took the ["Achieving Security Awareness Through Social Engineering Attacks"](https://www.blackhat.com/us-18/training/achieving-security-awareness-through-social-engineering-attacks.html) course at [Black Hat this year](https://www.blackhat.com/us-18/)!

It was eye-opening, tremendously interesting, and fun! It was facilitated by [Jayson Street](https://twitter.com/jaysonstreet) and [April Wright](https://twitter.com/aprilwright). Jayson gets paid by companies to break into their own facilities through [Social Engineering](<https://en.wikipedia.org/wiki/Social_engineering_(security)>). He shared many crazy stories, like the time he [gained full access to a bank in Beirut in two and a half minutes](https://www.youtube.com/watch?v=UpX70KxGiVo&feature=youtu.be&t=434).

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/achieving-security-awareness-through-social-engineering-attacks/corgi-social-engineering-meme.jpg" alt="Hacking 101: Social Engineering. A corgi dog passes as a human.">
</p>

[Source](https://imgflip.com/meme/38390688/corgi-hacker?sort=latest)

Here’s a summary of what we discussed in the training, along with key takeaways:

## OSINT and Social Media

> “Information doesn’t have to be secret to the valuable” ~ CIA

One of the key elements of Social Engineering is [Open-source Intelligence (OSINT)](https://en.wikipedia.org/wiki/Open-source_intelligence), which is insight produced from data collected from publicly available sources. **If you don’t have proper privacy settings in your social media accounts, the information you put there is public**.

We discussed a case in class of a guy named Travis who put pictures of his badge, passport, plane tickets, job title, workplace and even emails on Instagram. Really.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/achieving-security-awareness-through-social-engineering-attacks/private-data-exposed-in-instragram.jpg" alt="Private data exposed on Instagram.">
</p>

April contacted him and he removed some of it, but you can still find the badge on Instagram.

We analyzed how someone that overposts on social media could be targeted, and it’s not a surprise that it’s relatively simple. We also talked about tools and techniques to get and find relevant information.

There was an exercise about drafting (not sending) a spear phishing email in 1 hour targeted at someone in our organization using OSINT. Nobody used their own workplace and nobody said where they worked, but we completed the task with good results.

**Takeaway #1:** Review your privacy settings and don’t post private information on social media.

{% include tweet_quote.html quote_text="Review your privacy settings and don’t post private information on social media. Open-source Intelligence tools could be used to mine your data and create phishing opportunities." %}

## WiFi Pineapple and Bash Bunny

How do they come up with these names?

As part of the training they gave us a [WiFi Pineapple](https://www.wifipineapple.com/), a [Bash Bunny](https://wiki.bashbunny.com/#!index.md) and a [Packet Squirrel](https://www.hak5.org/gear/packet-squirrel). They are tools meant to be used for penetration tests, and they have many pranks that can help with Security Awareness programs by showcasing their associated dangers in safe and controlled setups.

### WiFi Pineapple

The WiFi Pineapple is a [Wireless Auditing tool](https://www.tutorialspoint.com/wireless_security/wireless_security_tools.htm) that can work as a [Man-in-the-middle platform](https://en.wikipedia.org/wiki/Man-in-the-middle_attack). Among others, it allows the owner to intercept an open WiFi connection and inspect and modify HTTP traffic, redirect the user to a malicious site, or associate with past public WiFis and “pretend” to be those.

For example, if you’re near a Pineapple while your phone has WiFi turned on and is actively looking for connections, all of the sudden you may connect to the Airport you went 6 months ago and a site may ask you to pay for the service. They mention it on the [Silicon Valley TV Show](https://www.youtube.com/watch?v=9FckHMPBs_Q).

This is the picture of a WiFi Pineapple Tower because… Black Hat.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/achieving-security-awareness-through-social-engineering-attacks/wifi-pineapple-tower.jpg" alt="WiFi Pineapple Tower">
</p>

**Takeaway #2:** Avoid open or public networks as much as possible, especially in crowded spaces. If you’re not in a trusted space, turn on WiFi only when you really need it.

{% include tweet_quote.html quote_text="Avoid open or public networks as much as possible, especially in crowded spaces. If you’re not in a trusted space, turn on WiFi only when you really need it." %}
