---
layout: post
title: "Keep API backward compatibility with Express Gateway"
description: "Express Gateway is an API gateway that sits at the heart of any microservices architecture, securing your microservices and exposing them through APIs."
longdescription: "Express Gateway is an API gateway that sits at the heart of any microservices architecture (regardless of what language or platform is being used), securing microservices and exposing them through APIs. In this tutorial, I'll show you how an API gateway help you keeping backward compatibility with your old API while evolginv into a new one"
date: 2018-08-01 10:00
category: Technical Guide, Backend, NodeJS
author:
  name: "Vincenzo Chianese"
  url: "https://twitter.com/d3dvincent"
  mail: "vincenzo@express-gateway.io"
  avatar: "https://pbs.twimg.com/profile_images/932249086333464576/DacF9HCu_400x400.jpg"
design:
  image: https://cdn.auth0.com/blog/express-gateway/logo.png
  image_bg_color: "#205868"
  bg_color: "#00728E"
tags:
- javascript
- nodejs
- authentication
- auth
- api
- rest
- apigateway
related:
- 2018-01-11-apigateway-microservices-superglue
- 2017-07-14-getting-a-competitive-edge-with-a-microservices-based-architecture
- 2017-11-15-api-less-scary-approach

---

**TL;DR:** In this article, I'll show you how an API gateway can help you retaining API Compatibility with **old** clients while _evoling_ the product according to the new needs of your business [the code example in this GitHub repository](https://github.com/XVincentX/apigateway-playground/tree/gateway-request-response-modification).

---

## Introduction

Systems evolve continously, and so do their WebAPIs. As they represent the interface for external clients to interact with your system, they're the first line **reflecting changes** in your organisation.

Such API changes can happen for a number of reasons. Technological advancements, change in the line of business, important bug fixes and so on.

Chances are you could introduce **breaking** changes in your WebAPI, which in turns means **breaking your clients** that, in order to be operational again, will need to make code changes in their applications and redeploy them so they can use the new API and get back to business.

Some times, changes are **inevitable** and you need to deal with it in a way or in another. However, there's an entire class of problems that can be handled in a different way rather than breaking your API.

Among the possible solutions, we need to cite:

1. An [Hypermedia API](https://medium.com/unexpected-token/how-your-api-could-benefit-from-hypermedia-b62780771ccb) that, with the forewords of putting the understanding in the runtime instead of sharing it ahead of the time, is prepared by definition to handle changes. Clients, if correctly coded, can handle such intrisinc changes in a non-breaking way and adjusting the user experience accordingly.

2. Employ an [API Gateway][express-gateway] to retain the old compatibility while rolling out the new changes. This is a simple yet effetive way to mask the internal changes of your services while keeping the same interface. In such way, you can extend the runaway of your API while evolving your services. You can think about it as the WebAPI version of the [adapter pattern](https://en.wikipedia.org/wiki/Adapter_pattern)

In this article, we're going to explore the second approach. However, Hypermedia APIs are a thing and big companies have been employing such approach for ages.

## Express Gateway to help

It turns out [Express Gateway][express-gateway] is a **perfect** candidate for such task. In this example, we're going to show how we can change the shape of a request's body coming into a service as well as modyfing the response body to keep the same interface exposed to the clients.

### Set up our scenario

Let's imagine a simple use case where keeping API Compatibility with the clients is important.
In case you're interested and you want to try this out on your own, the source code of this example is [on Github](https://github.com/XVincentX/apigateway-playground/tree/gateway-request-response-modification)


Suppose you have a service, coded by your internal development team, exposing an API that's able to return a customer by its ID through a `GET` request:

### `GET /customers`

```json
{
  "customerId": "123456789",
  "name": "Clark",
  "surname": "Kent"
}
```

…and create a new customer with a `POST` request using the following payload:

### `POST /customers`

```json
{
  "name": "Clark",
  "surname": "Kent"
}
```

Which returns the created customer with a generated `customerId` and the operator that created such user:

```json
{
  "customerId": "123456",
  "createdBy": "vncz"
}
```

Suppose now that given your business is growing you decide that it makes sense to **replace your homemade Customer service** with a thirthy party cloud service that's offering better Customer management capabilities that perfectly fit for your company.

Most likely, the offered API, as well as provided features, will differ in multiple parts. For example, the URL space is going to be different as well as the accepted and returned payload.

In this example, let's suppose the new service has an endpoint on `/v1/cust` (instead of `/customers`) and, instead of accepting a `name` and `surname` properties, it requires an unique `fullname` property. Also — as it's an external service, it does not include any `createdBy` property, as it's a property that exists exclusively in your system.

While these changes most likely make sense for your internal clients because of business requirements and so on, maybe your existing thirty party clients do not care that much of this change and, while willing to migrate at a certain point in the future, flipping directly the switch might not be an option.

### Keeping the legacy API intact using Express Gateway

It turns out that an [API Gateway][express-gateway] can solve this problem. Being an intermediate layer between the public interface **AND** the internal services it can manipulate the requests and the responses during their journey.

Here's what we're going to do:

- Configure the [proxy][proxy] policy so that the request to the old endpoint get routed to the new, correct internal services
- Configure the [bodyModifier][bodyModifier] policy to modify the request's body so that the new Customer service will be able to consume it. In the same way, we'll use the same policy this time to modify the response object to make sure the `createdBy` property is correctly added.

### Installing Express Gateway

For the sake of this article, we'll install and use a different Express Gateway version. This version will most likely land in the master (thus as an official version) soon; as we're still in the process of discussing some internal requirements, we haven't been able to make it happen officially yet.

`npm install expressgateway/express-gateway#feat/proxy-events`

### Set up two pipelines to proxy the objects back to the new service

The first thing we're going to do is to set up two pipelines that will proxy the requests to the new `/cust/v1` endpoint:

```yaml
apiEndpoints:
  customers:
    path: '/customers*'
serviceEndpoints:
  v1Cust:
    url: 'https://cool.Cloud.service/v1/cust'
policies:
  - proxy
  - bodyModifier
pipelines:
  customers:
    apiEndpoints:
      - customers
    policies:
      - proxy:
        - action:
            serviceEndpoint: v1Cust
```

### Using Express Gateway to change the request and respone body

We can now use the `bodyModifier` policy to modify request/response payloads so they conforms to the new service API.

```yaml
      - bodyModifier:
        - action:
            request:
              add:
                - name: fullname
                  value: "req.body.name + ' ' + req.body.surname"
              remove:
                - name: name
                - name: surname
            response:
              add:
                - name: createdBy
                  value: "req.user.id"
```

It shuold be easy to understand what's going on here: We're concatenating the `name` and `surname` properties from the current request body and forming a new `fullname` property out of it. Once that's done, we're removing these properties as they're not required by the new service.

Then we're doing king od the same thing for the response, where we're readding back the `createdBy` property grabbing it from the current user registered in the gateway.

Let's now put our system under test with a couple of http requests to test the system is working correctly:

`curl -X POST http://localhost:9876/customers/ -H "Content-Type: application/json" -d '{"name":"Clark", "surname": "Kent"}'`

The system, despite the code changes in the internal service, should still be working and more importantly responding in the same way it did before.

## Conclusions

This approach is keeping the whole object in memory and taking the burden of parsing it. In case of huge payloads (several MBs), a more efficient way would be to parse the content as a stream, using [JSONStream](https://github.com/dominictarr/JSONStream) for example. We'll not explore this approach here, but it should be the way to go in case you're expecting huge JSON objects. For small payloads the JSON parsing, although sync, does not take more than 1ms.

{% include asides/express-gateway.markdown %}

[express-gateway]: https://express-gateway.io
[proxy]: https://express-gateway.io/docs/policies/proxy
[bodyModifier]: https://express-gateway.io/docs/policies/bodyModifier
