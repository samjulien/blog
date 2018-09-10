---
layout: post
title: "How Do Smart Cities Tackle Cybersecurity?"
description: "Use penetration testing and 2FA and educate citizens and employees to better anticipate and avoid cyber threats."
date: 2018-09-10 8:30
category: Security, Cybersecurity, Enterprise
design: 
  bg_color: "#222228"
  image: https://cdn.auth0.com/blog/security-whitepaper/logo.png
author:
  name: Diego Poza
  url: https://twitter.com/diegopoza
  avatar: https://avatars3.githubusercontent.com/u/604869?v=3&s=200
  mail: diego.poza@auth0.com
tags: 
  - security
  - cybersecurity
  - attacks
  - enterprise
  - social-engineering
  - malware
  - vulnerabilties
  - wannacry
  - phishing
  - usb-traps
  - mobile
  - mobile-attacks
related:
  - 2018-04-12-common-threats-in-web-app-security
---

On April 7, 2017, at a quarter to midnight, the city of Dallas was hacked.

The perpetrators accessed the City of Dallas's emergency management system and set off 156 blaring alarms—alarms intended to warn people in case of a tornado or hurricane.

It took over an hour and a half for city administrators to understand what had gone wrong and shut the sirens down.

Amid the ongoing digitization of our urban areas, the Dallas incident highlights one of the main dangers that a smart city—for all the good it can do—brings.

Without the right precautions, and without the right security, our smart cities can be just as vulnerable to hacking as our computers and mobile devices.

What happened in Dallas may have been the first high-profile incident of “city hacking,” but it certainly won't be the last.

## Why Security Is a Problem For Smart Cities

The rise of smart cities is intimately linked to the rise in production of Internet of Things (IoT) devices—as are its inherent security problems.

Your average IoT device is relatively cheaply produced. It's not built with the kind of security features you get on a Mac or Windows laptop or tablet or in a mobile phone. It is, however, connected to the internet.

These three factors have made IoT devices incredibly fertile cybercrime targets over the last decade or so.

In 2015, millions of children's names, genders, ages, photos, and parents' records (including home addresses) were compromised through a device known as the InnoTab—a kind of WiFi-enabled tablet for kids.

IoT devices are often trivially easy to access remotely because they're already connected to the internet and not built with cybersecurity in mind. Hackers don't even need to pull information from them. They can simply sit on the device and wait for it to gather information, or even requisition it for use in a distributed denial of service (DDoS) attack or botnet.

Cybersecurity researchers have found vulnerabilities in IoT devices in smart cities, too. Aside from the Dallas incident, significant issues have occurred in smart traffic signals and smart electricity meters. The number of attacks on infrastructure in the U.S. alone went from not even 200 in 2012 to 300 in 2015.

Today, advocates of smart cities are looking much more closely into the security of smart cities and how to build devices that can ensure our cities stay safe and protected—even as they get smarter. According to Gartner, 2.3 billion connected items were used in U.S cities throughout 2017. That number is only going to get bigger and bigger.

## Ensure Security For Critical Facilities

The most vulnerable locations in any smart city are the centers of utilities and power—power plants, water processing plants, and so on.

In Kiev in 2016, hackers shut down 20% of the city's power by hacking into an electrical substation.

Penetration testing is a common method that cities and municipalities use to test for vulnerabilities with their utilities. A security firm is hired to attempt to break in and gain access to the system. Afterward, they produce a report with their findings and give [recommendations for how to avoid the a real attack](https://www.redteamsecure.com/business-insider-rides-shotgun-as-redteam-security-hacks-the-power-grid/).

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/smart-cities-security/gaining-physical-access-to-facility.png" alt="A person trying to gain physical access to a facility">
</p>

Pen testing isn't just about lurking around a facility late at night and trying to gain physical access. It might also mean dropping a USB key, loaded with a virus, in the parking lot to see whether an employee happens to pick it up and stick it in their laptop; if they do, the key can be formatted to sit on the device as a keylogger, attempt to gain remote access, or send out phishing emails.

It's about social engineering—still one of the most effective ways of gaining access anywhere.

And it means, of course, more straightforward network and application penetration testing—trying to get in by remotely compromising the system itself.

## Two-Factor Authentication

Facilities that provide critical utilities, such as power and water, need to be made absolutely secure, but so does other essential infrastructure in smart cities—like subway transportation, street lights, and security cameras.

The essential technology of any smart city must employ cryptography to protect data. Otherwise, video feeds of your citizenry can wind up being streamed on the internet, or your street lights can end up flashing on and off for hours on end.

Data should be encrypted both at rest and in transit. Any systems that allow access from any parties must accept a username and a password and should go a step forward and enable two-factor authentication. Two-factor authentication is the easiest and most effective step you can take to prevent unauthorized access because it immediately cuts out the most obvious and available attack vectors.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/smart-cities-security/two-factor-authentication-using-smartphone.png" alt="Two-factor authentication demonstration using a smartphone to grant access">
</p>

[Two-factor authentication](https://auth0.com/learn/two-factor-authentication/), at root, is about ensuring that anyone accessing your systems has two methods of proving their identity. That might mean a username, password, and something like a biometric key or a one-time password delivered through an app on their phone, like [Auth0 Guardian](https://auth0.com/docs/multifactor-authentication/guardian) or Google Authenticator.

## Education For Citizens and Leaders

Ultimately, the best way to prevent most cyberattacks (on cities or anything else) from succeeding, or at least to mitigate the damages, is education.

Emails that look like they're from a C-suite executive at your company but have an odd-looking From: address, or USB drives that look like they've been forgotten in your office's parking lot: These are highly visible red flags that indicate that some person or group has gotten access to your systems or is trying to. They're also some of the most commonly successful attacks out there because many people don't recognize the signs for what they are.

When one person falls for a phishing email, it can cause huge ripple effects down the line as their contacts are emailed en masse and compromised as well.

Educating denizens about the common forms of cyberattacks and the ways to prevent falling victim to them is the number one way that cities—if they cannot prevent attacks from happening—can ensure that the effects of malicious acts do not ripple out and cause wider damage.

## The Future of Urban Cybersecurity

The cybersecurity challenges of the future are going to look bigger and much different than many of those we have today.

As smart devices proliferate and security vulnerabilities loom larger and larger, it's on all of us to make sure that the cities we are building—no matter how smart—are secure as well.

{% include asides/about-auth0.markdown %}
