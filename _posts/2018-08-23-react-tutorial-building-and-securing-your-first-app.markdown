---
layout: post
title: "React Tutorial: Building and Securing Your First App"
description: "Learn how React works and create and secure your first React app in no time."
date: 2018-08-23 08:30
category: Technical Guide, First Application, React
author:
  name: "Bruno Krebs"
  url: "https://twitter.com/brunoskrebs"
  mail: "bruno.krebs@gmail.com"
  avatar: "https://cdn.auth0.com/blog/profile-picture/bruno-krebs.png"
design:
  bg_color: "#1A1A1A"
  image: https://cdn.auth0.com/blog/logos/react.png
tags:
- react
- tutorial
- development
- authentication
- auth0
- security
- spa
- auth0
related:
- 2017-11-28-redux-practical-tutorial
- 2018-08-14-react-context-api-managing-state-with-ease
---

**TL;DR:** In this article, you will learn the basic concepts of React. After that, you will have the chance to use React in action while creating a simple Q&A (Questions & Answers) app that relies on a backend API. If needed, you can check [this GitHub repository to check the code that supports this article](https://github.com/auth0-blog/react-tutorial). Have fun!

## Prerequisites

Although not mandatory, you should know a few things about JavaScript, HTML, and CSS before diving in in this tutorial. If you do not have previous experience with these technologies, you might not have an easy time following the instructions in this article and it might be a good idea to step back and learn about them first. If you do have previous experience with web development, then stick around and enjoy the article.

Also, you will need to have Node.js and NPM installed in your development machine. If you don't have these tools yet, please, [read and follow the instructions on the official documentation to install Node.js](https://nodejs.org/en/download/). NPM, which stands for Node Package Manager, comes bundled into the default Node.js installation.

Lastly, you will have to have access to a terminal in your operating system. If you are using MacOS X or Linux, you are good to go. If you are on Windows, you will probably be able to use [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) without problems.

## React Introduction

[React](https://reactjs.org/) is a JavaScript library that Facebook created to facilitate the development of [Single-Page Applications (a.k.a. SPAs)](https://en.wikipedia.org/wiki/Single-page_application). Since Facebook open-sourced and announced React, this library became extremely popular all around the world and gained mass adoption by the developer community. Nowadays, although still mainly maintained by Facebook, other big companies (like [Airbnb](https://www.airbnb.com/), [Auth0](https://auth0.com/), and [Netflix](http://netflix.com/)) embraced this library and are using it to build their products. If you check [this page, you will find a list with more than a hundred companies that use React](https://github.com/facebook/react/wiki/Sites-Using-React).

In this section, you will learn about some basic concepts that are important to keep in mind while developing apps with React. However, you have to be aware that the goal here is not to give you a complete explanation of these topics. The goal is to give you enough context so you can understand what is going on while creating your first React application.

For more information on each topic, you can always consult [the official React documentation](https://reactjs.org/).

### React and the JSX Syntax

First and foremost, you need to know that React uses a funny syntax called JSX. JSX, which stands for JavaScript XML, is a syntax extension to JavaScript that enables developers to use XML (and, as such, HTML) to define their applications. This section won't get into the details of how JSX really works. The idea here is to give you a heads up so you don't get surprised when you see this syntax in the next sections.

So, when it comes to JSX, it is perfectly normal to see things like this:

```js
function showRecipe(recipe) {
  if (!recipe) {
    return <p>Recipe not found!</p>;
  }
  return (
    <div>
      <h1>{recipe.title}</h1>
      <p>{recipe.description}</h1>
    </div>
  );
}
```

In this case, the `showRecipe` function is using the JSX syntax to show the details of a `recipe` (i.e., if the recipe is available) or a message saying that the recipe was not found. If you are not familiar with this syntax, don't worry. You will get used to it quite soon. Then, if you are wondering why React uses JSX, you can read [their official explanation here](https://reactjs.org/docs/introducing-jsx.html).

> "React embraces the fact that rendering logic is inherently coupled with other UI logic: how events are handled, how the state changes over time, and how the data is prepared for display." - [Introducing JSX](https://reactjs.org/docs/introducing-jsx.html)

### React Components

Components in React are the most important pieces of code. Everything you can interact with in a React application is (or is part of) a component. For example, when you load a React application, the whole thing will be handled by a root component that is usually called `App`. Then, if this application contains a navigation bar, you can bet that this bar is defined inside a component called `NavBar` or similar. Also, if this bar contains a form where you can input a value to trigger a search, you are probably dealing with another component that handles this form.

The biggest advantage of using components to define your application is that this approach lets you encapsulate different parts of your user interface into independent, reusable pieces. Having each part on its own component facilitates reasoning about each piece in particular, testing each piece, and reusing them whenever applicable. When you start finding your bearings with this approach, you will see that having a tree of components (that's what you get when you divide everything into components) also facilitates state propagation.

### Defining Components in React

Now that you learned that React applications are nothing more than a tree of components, you have to learn how to create components in React. So, basically, there are two types of React components that you can create: [_Functional Components_ and _Class Components_](https://reactjs.org/docs/components-and-props.html#functional-and-class-components).

The difference between these two types is that functional components are simply "dumb" components that do not hold any internal state, and class components are more complex components that can hold internal state. For example, if you are creating a component that will only show the profile of the user that is authenticated, you can create a functional component as follows:

```js
function UserProfile(props) {
  return (
    <div className="user-profile">
      <img src={props.userProfile.picture} />
      <p>{props.userProfile.name}</p>
    </div>
  );
}
```

There is nothing particularly interesting about the component defined above as no internal state is handled. As you can see, this component simply uses a `userProfile` that was passed to it to define a `div` element that shows the user's picture (the `img` element) and their name (inside the `p` element).

However, if you are going to create a component to handle things that need to hold some state and perform more complex tasks, like a subscription form, you will need a class component. To create a class component in React, you would proceed as follows:

```js
class SubscriptionForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      acceptedTerms: false,
      email: '',
    };
  }

  updateCheckbox(checked) {
    this.setState({
      acceptedTerms: checked,
    });
  }

  updateEmail(value) {
    this.setState({
      email: value,
    });
  }

  submit() {
    // ... use email and acceptedTerms in an ajax request or similar ...
  }

  render() {
    return (
      <form>
        <input
          type="email"
          onChange={(event) => {this.updateEmail(event.target.value)}}
          value={this.state.email}
        />
        <input
            type="checkbox"
            checked={this.state.acceptedTerms}
            onChange={(event) => {this.updateCheckbox(event.target.checked)}}
          />
        <button onClick={() => {this.submit()}}>Submit</button>
      </form>
    )
  }
}
```

As you can see, this new component is handling way more stuff than the other one. For starters, this component is defining three input elements (actually, two `input` tags and one `button`, but the button is also considered an input element). The first one enables users to input their email addresses. The second one is a checkbox where users can define if they agree or not to some arbitrary terms. The third one is a button that users will have to click to end the subscription process.

Also, you will notice that this component is defining an internal state (`this.state`) with two fields: `acceptedTerms` and `email`. In this case, the form uses the `acceptedTerms` field to represent the choice of the users in relation to the fictitious terms and the `email` field to hold their email addresses. Then, when users click on the submit button, this form would use its internal state to issue an [AJAX request](https://www.w3schools.com/xml/ajax_xmlhttprequest_send.asp).

So, basically speaking, if you need a component to handle dynamic things that depend on a internal state, like user input, you will need a class component. However, if you need a component that won't perform any logic internally that relies on a internal state, you can stick with a function component.

> **Note:** This is just a brief explanation about the different components and how they behave. In fact, the last component created in this section, `SubscriptionForm`, could be easily transformed into a functional component too. In this case, you would have to move its internal state up in the component tree and pass to it these values and functions to trigger state change. To learn more about React components, please, [check this article](https://reactjs.org/docs/components-and-props.html#functional-and-class-components).

### Re-Rendering React Components

Another very important concept that you have to understand is how and when React re-renders components. Luckily, this is an easy concept to learn. There are only two things that can trigger a re-render in a React component, a change to the `props` that the component receives or a change to its internal state.

Although the previous section didn't get into the details about how to change the internal state of a component, it did show how to achieve this. Whenever you use a stateful component (i.e., a class component), you can trigger a re-render on it by changing its state through the `setState` method. What is important to keep in mind is that you cannot change the `state` field directly. You **have to** call the `setState` method with the new desired state:

```js
// this won't trigger a re-render:
updateCheckbox(checked) {
  this.state.acceptedTerms = checked;
}

// this will
this.setState({
  acceptedTerms: checked,
});
```

In other words, you have to treat `this.state` as if it were immutable.

> **Note:** To achieve a better performance, React does not guarantee that `setState()` will update `this.state` immediately. The library may wait for a better opportunity when there are more things to update. So, it is not reliable to read `this.state` right after calling `setState()`. For more information, [check the official documentation on `setState()`](https://reactjs.org/docs/react-component.html#setstate).

Now, when it comes to a stateless component (i.e., a functional component), the only way to trigger a re-render is to change the `props` that are passed to it. In the last section, you didn't have the chance to see the whole context of how a functional component is used nor what `props` really are. Luckily again, this is another easy topic to grasp. In React, `props` are nothing more than the properties (thus its name) passed to a component.

So, in the `UserProfile` component defined in the last section, there was only one property being passed/used: `userProfile`. In that section, however, there was a missing piece that was responsible for passing properties (`props`) to this component. In that case, the missing piece was where and how you use that component. To do so, you just have to use your component as if it were an HTML element (this is a nice feature of JSX) as shown here:

```js
import React from 'react';
import UserProfile from './UserProfile';

class App extends () {
  constructor(props) {
    super(props);
    this.state = {
      user: {
        name: 'Bruno Krebs',
        picture: 'https://cdn.auth0.com/blog/profile-picture/bruno-krebs.png',
      },
    };
  }

  render() {
    return (
      <div>
        <UserProfile userProfile={this.state.user} />
      </div>
    );
  }
}
```

That's it. This is how you define and pass `props` to a child component. Now, if you change the `user` in the parent component (`App`), this will trigger a re-render in the whole component and, subsequently, it will change the `props` being passed to `UserProfile` triggering a re-render on it as well.

> **Note:** React will also re-render class components if their `props` are changed. This is not a particular behavior of functional components.

## What You Will Build with React

All right! With the concepts describe in the last section in mind, you are ready to start developing your first React application. In the following sections, you will build a simple Q&A (Question & Answer) app that will allow users to interact with each other asking and answering question. To make the whole process more realistic, you will use Node.js and Express to create a rough backend API. Don't worry if you don't feel confident about developing backend apps with Node.js. This is going to be a very straightforward process and you will be up and running in no time.

In the end of this tutorial, you will have a React app supported by a Node.js backend that looks like this:

![React Tutorial: Building and Securing Your First App](https://cdn.auth0.com/blog/react-tutorial/q-and-a-app.png)

## Developing a Backend API with Node.js and Express

Before diving into React, you will quickly build a backend API to support your Q&A app. In this section, you will use Express alongside with Node.js to create this API. If you don't know what Express is or how it works, don't worry, you don't need to get into its details now. [Express](https://expressjs.com/), as stated by its official web page, is an unopinionated, minimalist web framework for Node.js. With this library, as you will see here, you can quickly build apps to run on servers (i.e. backend apps).

So, to get things started, open a terminal in your operating system, move to a directory where you create your projects, and issue the following commands:

```bash
# create a directory for your Express API
mkdir qa-api

# move into it
cd qa-api

# use NPM to start the project
npm init -y
```

The last command will create a file called `package.json` inside your `qa-api` directory. This file will hold the details (like the dependencies) of your backend API. Then, after these commands, run the following one:

```bash
npm i body-parser cors express helmet morgan
```

This command will install five dependencies in your project:

- [`body-parser`](https://github.com/expressjs/body-parser): This is a library that you will use to convert the body of incoming requests into JSON objects.
- [`cors`](https://github.com/expressjs/cors): This is a library that you will use to configure Express to add headers stating that your API accepts requests coming from other origins. This is also known as [Cross-Origin Resource Sharing (CORS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS).
- [`express`](https://github.com/expressjs/express): This is Express itself.
- [`helmet`](https://github.com/helmetjs/helmet): This is a library that helps securing Express apps with various HTTP headers.
- [`morgan`](https://github.com/expressjs/morgan): This is a library that adds some logging capabilities to your Express app.

> **Note:** As the goal of this article is to help you develop your first React application, the list above contains a very brief explanation of what each library brings to the table. You can always refer to the official web pages of these libraries to learn more about their capabilities.

After installing these libraries, you will be able to see that NPM changed your `package.json` file to include them in the `dependencies` property. Also, you will see a new file called `package-lock.json`. NPM uses this file to make sure that anyone else using your project (or even yourself in other environments) [will always get versions compatible with those that you are installing now](https://docs.npmjs.com/files/package-lock.json).

Then, the last thing you will need to do is to develop the backend source code. So, create a directory called `src` inside your `qa-api` directory and create a file called `index.js` inside this new directory. In this file, you can add the following code:

```js
//import dependencies
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

// define the Express app
const app = express();

// the database
const questions = [];

// enhance your app security with Helmet
app.use(helmet());

// use bodyParser to parse application/json content-type
app.use(bodyParser.json());

// enable all CORS requests
app.use(cors());

// log HTTP requests
app.use(morgan('combined'));

// retrieve all questions
app.get('/', (req, res) => {
  const qs = questions.map(q => ({
    id: q.id,
    title: q.title,
    description: q.description,
    answers: q.answers.length,
  }));
  res.send(qs);
});

// get a specific question
app.get('/:id', (req, res) => {
  const question = questions.filter(q => (q.id === parseInt(req.params.id)));
  if (question.length > 1) return res.status(500).send();
  if (question.length === 0) return res.status(404).send();
  res.send(question[0]);
});

// insert a new question
app.post('/', (req, res) => {
  const {title, description} = req.body;
  const newQuestion = {
    id: questions.length + 1,
    title,
    description,
    answers: [],
  };
  questions.push(newQuestion);
  res.status(200).send();
});

// insert a new answer to a question
app.post('/answer/:id', (req, res) => {
  const {answer} = req.body;

  const question = questions.filter(q => (q.id === parseInt(req.params.id)));
  if (question.length > 1) return res.status(500).send();
  if (question.length === 0) return res.status(404).send();

  console.log(question);
  question[0].answers.push({
    answer,
  });

  res.status(200).send();
});

// start the server
app.listen(8081, () => {
  console.log('listening on port 8081');
});
```

To keep things short, the following list briefly explains how things work in this file (also, be sure to check the comments in the code above):

- Everything starts with five `require` statements. These statements load all libraries you installed with NPM.

- After that, you use Express to define a new app (`const app = express();`).

- Then, you create an array that will act as your database (`const questions = [];`). In a real-world app, you would use a real database like Mongo, PostgreSQL, MySQL, etc.

- Next, you call the `use` method of your Express app four times. Each one to configure the different libraries you installed alongside with Express.

- Right after it, you define your first endpoint (`app.get('/', ...);`). This endpoint is responsible for sending the list of questions back to whoever request it. The only thing to notice here is that instead of sending the `answers` as well, this endpoint compiles them together to send just the number of answers that each question has. You will use this info in your React app.

- After your first endpoint, you define another endpoint. In this case, this new endpoint is responsible for responding to requests with a single question (now, with all the answers).

- After this endpoint, you define your third endpoint. This time you define an endpoint that will be activated whenever someone sends a POST HTTP request to your API. The goal here is to take the message sent in the `body` of the request to insert a `newQuestion` in your database.

- Then, you have the last endpoint in your API. This endpoint is responsible for inserting answers into a specific question. In this case you use a [route parameter](https://expressjs.com/en/guide/routing.html) called `id` to identify in which question you must add the new answer.

- Lastly, you call the `listen` function in your Express app to run your backend API.

With this file in place, you are good to go. To run your app, just issue the following command:

```bash
# from the qa-app directory
node src
```

Then, to test if everything is really working, open a new terminal and issue the following commands:

```bash
# issue an HTTP GET request
curl localhost:8081

# issue a POST request
curl -X POST -H 'Content-Type: application/json' -d '{
  "title": "How to make a sandwich?",
  "description": "I am trying very hard but I do not know how to make a delicious sandwich. Can someone help me?"
}' localhost:8081

# re-issue the GET request
curl localhost:8081
```

The first command will trigger a HTTP GET request that will result in an empty array being printed out (`[]`). Then, the second command will issue a POST request to insert a new question into your API, and the third command will issue another GET request to verify if the question was properly inserted.

## Conclusion

Mention:
- The Virtual DOM
- Lifecycle