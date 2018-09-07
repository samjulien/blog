---
layout: post
title: "Black Hat Training: Achieving Security Awareness Through Social Engineering Attacks"
metatitle: "Top 10 Takeaways - Black Hat - Security Awareness Through Social Engineering"
description: "Let’s cover the top 10 cybersecurity takeaways of my social engineering training at Black Hat."
metadescription: "The Top 10 Takeaways of a social engineering course from Black Hat, a course which covered policies, security awareness programs, and much more!"
date: 2018-08-27 10:00
category: Technical Guide, Auth0 Engineering, Identity
author:
  name: "Annybell Villarroel"
  url: "https://www.linkedin.com/in/annybell-villarroel-60281189/"
  mail: "annybell.villarroel@auth0.com"
  avatar: "https://cdn.auth0.com/blog/auziros/Annybell-Villarroel.png"
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

<br />
<div style="display: flex; justify-content: center;">
  <blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">“Achieving Security Awareness Through Social Engineering Attacks” <a href="https://twitter.com/hashtag/BHUSA?src=hash&amp;ref_src=twsrc%5Etfw">#BHUSA</a> Training taught by <a href="https://twitter.com/jaysonstreet?ref_src=twsrc%5Etfw">@jaysonstreet</a> &amp; <a href="https://twitter.com/aprilwright?ref_src=twsrc%5Etfw">@aprilwright</a> will use current Red Team strategies to develop a better understanding of how attackers use SE <a href="https://t.co/yuojeClInS">https://t.co/yuojeClInS</a></p>&mdash; Black Hat (@BlackHatEvents) <a href="https://twitter.com/BlackHatEvents/status/1002976909268045827?ref_src=twsrc%5Etfw">June 2, 2018</a></blockquote>
  <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>
<br />

It was eye-opening, tremendously interesting, and fun! It was facilitated by [Jayson Street](https://twitter.com/jaysonstreet) and [April Wright](https://twitter.com/aprilwright). Jayson gets paid by companies to break into their own facilities through [Social Engineering](<https://en.wikipedia.org/wiki/Social_engineering_(security)>). He shared many crazy stories, like the time he [gained full access to a bank in Beirut in two and a half minutes](https://www.youtube.com/watch?v=UpX70KxGiVo&feature=youtu.be&t=434).

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/achieving-security-awareness-through-social-engineering-attacks/corgi-social-engineering-meme.jpg" alt="Corgi dog meme, coding on computer">
</p>

[Source](https://imgflip.com/meme/38390688/corgi-hacker?sort=latest)

Here’s a summary of what we discussed in the training, along with key takeaways:

## OSINT and Social Media

> “Information doesn’t have to be secret to the valuable” ~ CIA

One of the key elements of Social Engineering is [Open-source Intelligence (OSINT)](https://en.wikipedia.org/wiki/Open-source_intelligence), which is insight produced from data collected from publicly available sources. **If you don’t have proper privacy settings in your social media accounts, the information you put there is public**.

In class, we discussed the case of a guy named Travis who put pictures of his badge, passport, plane tickets, job title, workplace and even emails on Instagram.

We analyzed how someone that overposts on social media could be targeted, and it’s not a surprise that it’s relatively simple. We also talked about tools and techniques to get and find relevant information.

There was an exercise about drafting (not sending) a spear phishing email in 1 hour targeted at someone in our organization using OSINT. Nobody used their own workplace and nobody said where they worked, but we completed the task with good results.

**Takeaway #1:** Review your privacy settings and don’t post private information on social media.

{% include tweet_quote.html quote_text="Review your privacy settings and don’t post private information on social media. Open-source Intelligence tools could be used to mine your data and create phishing opportunities." %}

## WiFi Pineapple and Bash Bunny

As part of the training, they gave us [some interesting gadgets from Hak5](https://www.hak5.org/) including a [WiFi Pineapple](https://www.wifipineapple.com/) and a [Bash Bunny](https://wiki.bashbunny.com/#!index.md). They are tools meant to be used for penetration tests, and they have many pranks that can help with Security Awareness programs by showcasing their associated dangers in safe and controlled setups.

> We also got a [Packet Squirrel](https://www.hak5.org/gear/packet-squirrel) as an extra gift!

### WiFi Pineapple

The WiFi Pineapple is a [Wireless Auditing tool](https://www.tutorialspoint.com/wireless_security/wireless_security_tools.htm) that can work as a [Man-in-the-middle platform](https://en.wikipedia.org/wiki/Man-in-the-middle_attack). Among others, it allows the owner to intercept an open WiFi connection and inspect and modify HTTP traffic, redirect the user to a malicious site, or associate with past public WiFi connections and “pretend” to be one of them.

For example, if you’re near a Pineapple while your phone has WiFi turned on and is actively looking for connections, all of the sudden you may connect to the airport network you used 6 months ago and a site may ask you to pay for the service. They mention it on the [Silicon Valley TV Show](https://www.youtube.com/watch?v=9FckHMPBs_Q).

This is the picture of a WiFi Pineapple Tower because… Black Hat.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/achieving-security-awareness-through-social-engineering-attacks/wifi-pineapple-tower.jpg" alt="WiFi Pineapple Tower at Black Hat Conference">
</p>

**Takeaway #2:** Avoid open or public networks as much as possible, especially in crowded spaces. If you’re not in a trusted space, turn on WiFi only when you really need it.

{% include tweet_quote.html quote_text="Avoid open or public networks as much as possible, especially in crowded spaces. If you’re not in a trusted space, turn on WiFi only when you really need it." %}

### Bash Bunny

The Bash Bunny is a USB attack platform that can emulate trusted USB devices like Gigabit Ethernet, serial, flash storage and keyboards.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/achieving-security-awareness-through-social-engineering-attacks/bash-bunny.png" alt="Bash Bunny USB platform.">
</p>

We did a couple of experiments in the class: First, we used a “prank” payload that [rickrolls](https://en.wikipedia.org/wiki/Rickrolling) the target at a specific date and time. It took less than 20 seconds to deliver this payload.

Then we tested a “recon” payload and we could get the full terminal history, clipboard content, system users, [`ifconfig`](https://en.wikipedia.org/wiki/Ifconfig), WAN IP, and all installed applications. This took a little bit longer, but it was still fast and the computer was in sleep mode.

**Takeaway #3:** Don’t plug in random USB drives and be cautious when working on public spaces.

{% include tweet_quote.html quote_text="Don’t plug in random USB drives and be cautious when working on public spaces." %}

## Conclusion and Other Takeaways

We talked about other topics such as policies, security awareness programs, memes and the importance of repetition during training. These are the top 10 Takeaways of the experience:

1.  Review your privacy settings and don’t post private information on social media.

2.  Avoid open or public networks as much as possible, especially in crowded spaces. If you’re not in a trusted space, turn on WiFi only when you really need it.

3.  Don’t plug in random USB drives and be cautious when working on public spaces.

4.  Clickbait is widely used in social engineering, don’t trust it.

5.  Before running phishing campaigns, there should be policies and formal training in place.

6.  Although potentially controversial, hard to spot spear phishing emails create a more impactful “teachable moment” (as Jayson says).

7.  Certain topics of Security Awareness training should be tailored by role. An organization should have a site that groups all this information and internal security-focused newsletters could be useful as well.

8.  Controlled live demos with tools like the WiFi Pineapple and the Bash Bunny help raise security awareness.

9.  Prizes and gamification support these efforts.

10. It is important to always explain the purpose of the training, demo or campaign. We don’t ever want you to fail, we want to empower you and help make you one of our strongest lines of defense:

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/achieving-security-awareness-through-social-engineering-attacks/teammate-empowerment.jpg" alt="Security training at Black Hat Conference">
</p>

{% include tweet_quote.html quote_text="Security training and awareness campaigns make people the best line of cybersecurity defense" %}

{% include profile_card.html picture="https://cdn.auth0.com/blog/auziros/Annybell-Villarroel.png" name="Annybell Villarroel" title="Security Operations Manager" team="Security Team" location="Madrid, Spain" body="What I like the most about Security Awareness and Social Engineering training is that it allows us to grow a security mindset and culture. This is relevant to everyone in an organization and should be a top priority. Whether our role is technical or not, we can all be part of that effort." %}

{% include asides/about-auth0.markdown %}
