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
  "title": "How do I make a sandwich?",
  "description": "I am trying very hard but I do not know how to make a delicious sandwich. Can someone help me?"
}' localhost:8081

curl -X POST -H 'Content-Type: application/json' -d '{
  "title": "What is React?",
  "description": "I have been hearing a lot about React. What is it?"
}' localhost:8081

# re-issue the GET request
curl localhost:8081
```

The first command will trigger a HTTP GET request that will result in an empty array being printed out (`[]`). Then, the second and the third commands will issue POST requests to insert two questions into your API, and the fourth command will issue another GET request to verify if these questions were properly inserted.

If you manage to get the expected results, leave your server running and move on to the next section.

## Developing Applications with React

With your backend API up and running, you are finally ready to start developing your React application. Not that long ago, developers willing to create apps with React would have a hard time setting up all the tools needed (e.g., [webpack](https://webpack.js.org/)) to scaffold a React application. However (and luckily), the scenario has changed drastically after Facebook published a tool called [_Create React App_](https://github.com/facebook/create-react-app).

With this tool, you can scaffold a new React application with just one command. As such, to create your React app, open a new terminal and go to the same directory you created the `qa-api` one. From there, issue the following command:

```bash
npx create-react-app qa-react
```

This will make NPM download and run `create-react-app` in a single command, passing to it `qa-react` as the desired directory for your new application. The process involved in scaffolding a new application, as you will see after running the command above, is not that simple. The tool even need a bunch of seconds (or a couple of minutes depending on your internet connection) to create the whole thing. However, when this tool finishes, you can issue the following commands to run your React app:

```bash
# move into the new directory
cd qa-react

# start your React app
npm start
```

The last command issued above will start a development server that listens on port `3000` and will open the new app in your default web browser.

![Welcome to React](https://cdn.auth0.com/blog/react-tutorial/welcome-to-react.png)

After seeing your app, you can stop the server by hitting `Ctrl` + `c` so you can install a couple dependencies that you will need in your application. So, back in your terminal and after stopping the server, run the following command:

```bash
npm i react-router react-router-dom
```

This command will install two libraries to help you handle the navigation in your app. The first one, `react-router`, is the main library that enables seamless navigation. The second one, `react-router-dom`, is an extension to the web.

> **Note:** If you were using [React Native](https://facebook.github.io/react-native/) to develop an app to mobile devices, you would install `react-router-native` instead.

Then, after installing these libraries, you can open your React project in your preferred IDE so you can start the real work.

### Cleaning Up your React App

Well, actually, before start developing your app, you can remove a few files from it and clean up its code a little bit. For starter, you can remove the `./src/App.test.js` file because you won't create automated tests in this tutorial. Although this is an important topic, you will skip it for now so you can focus on learning React.

> **Note:** After learning about React, you might get interested into learning about how to add automated tests to your app. A good resource to help you on that matter is [the _Testing React Applications with Jest_ blog post](https://auth0.com/blog/testing-react-applications-with-jest/).

Besides that, you can also remove two other files as you won't use them: `./src/logo.svg` and `./src/App.css`. Then, after removing these files, open the `./src/App.js` file and replace its code with this:

```js
import React, { Component } from 'react';

class App extends Component {
  render() {
    return (
      <div>
        <p>Work in progress.</p>
      </div>
    );
  }
}

export default App;
```

You won't really use the new version of your `App` component as you will soon replace the contents of this file again. However, to avoid having code that won't compile, it is a good idea to refactor your `App` component.

### Configuring the React Router in Your App

After cleaning things up, you will need to configure React Router in your app. This will be a pretty simple step, as you will see. However, keep in mind that to master React Router you would need to read _at least_ one other article that specifically introduces the subject and all its features.

The thing is, React Router is a very complete solution and, in your first React app, you will touch only the tip of the iceberg. If you do want [to learn more about React Router, please, head to the official documentation](https://reacttraining.com/react-router/).

Having that in mind, open the `./src/index.js` file and replace its contents with this:

```js
import React from 'react';
import ReactDOM from 'react-dom';
import {BrowserRouter} from 'react-router-dom';
import './index.css';
import App from './App';
import registerServiceWorker from './registerServiceWorker';

ReactDOM.render(
  <BrowserRouter>
    <App/>
  </BrowserRouter>,
  document.getElementById('root')
);
registerServiceWorker();
```

In the new version of this file, you are just importing `BrowserRouter` from the `react-router-dom` library, and encapsulating your `App` component inside this router. That's all you need to start using React Router.

> **Note:** If you haven't seen this file before, this is the piece of logic that makes your React app to be rendered. More specifically, the `document.getElementById('root')` defines on what HTML element React must render your app. You can find this `root` element inside the `./public/index.html` file.

### Configuring Bootstrap in Your React App

To make your React app more appealing from the User Interface (UI) point of view, you are going configure [Bootstrap](https://getbootstrap.com/) on it. If you don't know Bootstrap, this is a extremely popular library that helps developers create good-looking, responsive web apps with ease.

There are multiple ways to integrate React and Bootstrap together. However, as the requirements for your first application will be quite simple and as you won't need any of [its interactive components](https://getbootstrap.com/docs/4.1/components) (i.e., you are just interested into the basic styles that this library provides), you are going to follow the easiest strategy available. That is, you are simply going to open your `./public/index.html` file and update it as follows:

{% highlight html %}
{% raw %}
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- ... tags above the title stay untouched ... -->
    <title>Q&App</title>
    <link rel="stylesheet" href="https://bootswatch.com/4/flatly/bootstrap.min.css">
  </head>
  <!-- ... body definition stays untouched ... -->
</html>
{% endraw %}
{% endhighlight %}

In this case you are actually doing two things: you are changing the `title` of your React app to _Q&App_; and you are making your app load a variation of Bootstrap called `flatly`. If you are interested, you can use any variation available at [_Bootswatch_](https://bootswatch.com), or you can also use the default flavor of Bootstrap. However, you will probably find the variations over _Bootswatch_ more appealing.

### Creating a Navigation Bar in Your React App

Now that you have configured your app to use Bootstrap, you are ready to create your first React component. In this section, you will create a component called `NavBar` (which stands for Navigation Bar) and you will add it to your React app.

To do so, create a new directory called `NavBar` inside the `src` directory of your application and insert a new file called `NavBar.js` inside it. In this file, input the following code:

```js
import React from 'react';
import {Link} from 'react-router-dom';

function NavBar() {
  return (
    <nav className="navbar navbar-dark bg-primary fixed-top">
      <Link className="navbar-brand" to="/">
        Q&App
      </Link>
    </nav>
  );
}

export default NavBar;
```

As you can see, the navigation bar component that you are creating is a functional component. You can create it like a stateless (i.e., functional) component because you don't really need to hold any internal state.

Now, to use your new component, you can open your `./src/App.js` file and update it as follows:

```js
import React, { Component } from 'react';
import NavBar from './NavBar/NavBar';

class App extends Component {
  render() {
    return (
      <div>
        <NavBar/>
        <p>Work in progress.</p>
      </div>
    );
  }
}

export default App;
```

Then, if you run your app by issuing `npm start` from a terminal, you will see the navigation bar at the top of it. However, what you won't see is the "work in progress" message that your `App` component contains. The problem here is that the navigation bar that you created is using a CSS class (`fixed-top`) provided by Bootstrap that makes it fixed to the top. This means that this component is not taking the default vertical space as it would if it were a normal `div` element.

To fix this situation, open the `./src/index.css` file and add a `margin-top` rule, as shown here:

```css
body {
  margin: 0;
  padding: 0;
  font-family: sans-serif;
  margin-top: 100px;
}
```

Now, if you check your app again, you will see your navigation bar and the "work in progress" message.

![React application with a navigation bar created with the help of Bootstrap.](https://cdn.auth0.com/blog/react-tutorial/react-app-with-navbar.png)

### Creating a Class Component with React

After creating the navigation bar, what you can do next is to create a stateful component (a class component) to fetch questions from your backend and to show it to your users. To fetch these questions, you will need the help of another library, [Axios](https://github.com/axios/axios). In a few words, Axios is a promise based HTTP client for the browser and for Node.js. In this tutorial, you will only use it in the browser (i.e., in your React app).

To install Axios, stop the React development server and issue the following command:

```bash
npm i axios
```

Then, create a new directory called `Questions` inside `src` and a new file called `Questions.js` inside it. In this file, you can insert the following code:

```js
import React, {Component} from 'react';
import {Link} from 'react-router-dom';
import axios from 'axios';

class Questions extends Component {
  constructor(props) {
    super(props);

    this.state = {
      questions: null,
    };
  }

  async componentDidMount() {
    const questions = (await axios.get('http://localhost:8081/')).data;
    this.setState({
      questions,
    });
  }

  render() {
    return (
      <div className="container">
        <div className="row">
          {this.state.questions === null && <p>Loading questions...</p>}
          {
            this.state.questions && this.state.questions.map(question => (
              <div key={question.id} className="col-sm-12 col-md-4 col-lg-3">
                <Link to={`/question/${question.id}`}>
                  <div className="card text-white bg-success mb-3">
                    <div className="card-header">Answers: {question.answers}</div>
                    <div className="card-body">
                      <h4 className="card-title">{question.title}</h4>
                      <p className="card-text">{question.description}</p>
                    </div>
                  </div>
                </Link>
              </div>
            ))
          }
        </div>
      </div>
    )
  }
}

export default Questions;
```

There are a few important things going on in this file. First, as mentioned before, you are creating a stateful component that will hold the questions available in your backend API. So, to do it properly, you are starting your component with the `questions` property set to `null` and, when React finishes mounting your component (which triggers the `componentDidMount` method), you are issuing a GET request (through the `axios.get` call) to your backend. In the meanwhile between your request and the answer from the backend, React renders your component with a message saying "loading questions..." (it does so because you instructed it to behave like that by adding `this.state.questions === null &&` before the message).

> **Note:** This component is touching a topic that was not addressed in this article, [the Lifecycle of React Components](https://reactjs.org/docs/react-component.html#the-component-lifecycle). In this case, you are just using one of the extension points provided by React, the `componentDidMount` method. You don't really need to understand how this works to follow this tutorial but, after finishing it, make sure you learn about this topic.

Then, whenever Axios gets a response from the backend, you put the `data` returned inside a constant called `questions` and you update the state of the component (`this.setState`) with it. This update, as you already learned, triggers a re-render and makes React show all the questions retrieved.

Now, regarding of how your questions are showed, you are using a bunch of `div` elements with CSS classes provided by Bootstrap to create a nice [_Card_ component](https://getbootstrap.com/docs/4.1/components/card/). If you want to tweak how this card is shown, make sure to check the docs.

Besides that, note that you are using a component called `Link` (from `react-router-dom`) to make this redirect users to the following path when clicked: `/question/${question.id}`. In the next section, you will create a component to the answers to a question chosen by the user.

So, as you already understand how your component behaves, the next thing you will need to do is to update the code of your `App` component to use your new component:

```js
import React, { Component } from 'react';
import NavBar from './NavBar/NavBar';
import Questions from './Questions/Questions';

class App extends Component {
  render() {
    return (
      <div>
        <NavBar/>
        <Questions/>
      </div>
    );
  }
}

export default App;
```

Then, if you run your app again (`npm start`), you will see this nice page:

![React app using Axios to fetch data from a backend API.](https://cdn.auth0.com/blog/react-tutorial/react-app-showing-questions.png)

### Routing Users with React Router

With all these features in place, one important step that you have to learn about is how to handle routing in your React app. In this section, you will learn about this topic while creating a component that shows the details of the questions available in your backend.

For starters, you can create a new directory called `Question` (singular now) and a file called `Question.js` (also singular) inside it. Then, you can insert the following code into this file:

```js
import React, {Component} from 'react';
import axios from 'axios';

class Question extends Component {
  constructor(props) {
    super(props);
    this.state = {
      question: null,
    };
  }

  async componentDidMount() {
    const { match: { params } } = this.props;
    const question = (await axios.get(`http://localhost:8081/${params.questionId}`)).data;
    this.setState({
      question,
    });
  }

  render() {
    const {question} = this.state;
    if (question === null) return <p>Loading ...</p>;
    return (
      <div className="container">
        <div className="row">
          <div className="jumbotron col-12">
            <h1 className="display-3">{question.title}</h1>
            <p className="lead">{question.description}</p>
            <hr className="my-4" />
            <p>Answers:</p>
            <p className="lead">
              {
                question.answers.map((answer, idx) => (
                  <p key={idx}>{answer.answer}</p>
                ))
              }
            </p>
          </div>
        </div>
      </div>
    )
  }
}

export default Question;
```

The way this new component works is actually very similar to the way the `Questions` component works. This is a stateful component that uses Axios to issue a GET request to the endpoint that retrieves the whole details of a question, and that updates the page whenever it gets a response back.

Nothing really new here. What is going to be new is the way this component gets rendered.

So, open the `App.js` file, and replace its contents with this:

```js
import React, { Component } from 'react';
import {Route} from 'react-router-dom';
import NavBar from './NavBar/NavBar';
import Question from './Question/Question';
import Questions from './Questions/Questions';

class App extends Component {
  render() {
    return (
      <div>
        <NavBar/>
        <Route exact path='/' component={Questions}/>
        <Route exact path='/question/:questionId' component={Question}/>
      </div>
    );
  }
}

export default App;
```

In the new version of your `App` component, you are using two `Route` elements (provide by `react-router-dom`) to tell React when you want the `Questions` component rendered and when you want the `Question` component rendered. More specifically, you are telling React that if your users navigate to `/` (`exact path='/'`) you want them to see `Questions` and, if they navigate to `/question/:questionId`, you want them to see the details of a specific question.

Note that the last route defines a parameter called `questionId`. When you created the `Questions` (plural) component, you added a link that uses the `id` of the question. React Router uses this `id` to form the link and then gives it to your `Question` component (`params.questionId`). With this `id`, your component uses Axios to tell the backend what question exactly is being requested.

If you check your application now, you will be able to see all your questions in the home page and you will be able to navigate to a specific question. However, you probably won't see any answer in your new component because your never added one. For now, to add answers to your questions, you can issue requests similar to the following one:

```bash
curl -X POST -H 'Content-Type: application/json' -d '{
  "answer": "Just spread butter on the bread and that is it."
}' localhost:8081/answer/1
```

After that, if you reload your app and go to [`http://localhost:3000/question/1`](http://localhost:3000/question/1), you will see a page similar to this:

![React app configured with React Router](https://cdn.auth0.com/blog/react-tutorial/react-app-with-react-router.png)

## Securing your React App

Your application has reached a state where it has almost everything it needs for prime time. There are just a few features missing. For example, right now, your users have no means of creating questions nor answering them through your app. Another example is that there is no way to log in into your application. Besides that, the questions and answers do not provide information about their authors.

In this section, you will learn how to implement all these features with ease. You will start by subscribing to [Auth0](https://auth0.com) to help you with the authentication feature, then you will secure your backend and, to wrap things up, you will secure your React app and refactor the `Question` component so that authenticated users can answer questions.

### Configuring an Auth0 Account

For starters, you will need to sign up to Auth0 so you can integrate it in your application. If you already have an existing account, you can use it without a problem. If you do not have one, now is a good time to <a href="https://auth0.com/signup" data-amp-replace="CLIENT_ID" data-amp-addparams="anonId=CLIENT_ID(cid-scope-cookie-fallback-name)">sign up for a free Auth0 account</a>. With your free account, you will have access to the following features:

- [Passwordless authentication](https://auth0.com/passwordless)
- [Lock for Web, iOS & Android](https://auth0.com/docs/libraries/lock/v11)
- [Up to 2 social identity providers (like Twitter and Facebook)](https://auth0.com/learn/social-login/)
- [Unlimited Serverless Rules](https://auth0.com/docs/rules/current)
- [Community Support](http://community.auth0.com/)

After signing up, you will have to create an [Auth0 Application](https://auth0.com/docs/applications) to represent your app. So, in your dashboard, click on [the Applications section](https://manage.auth0.com/#/applications) on the vertical menu and then click on _Create Application_.

On the dialog shown, you will have to insert a name for your application (for example, "Q&App") and then you will have to choose _Single Page Application_ as its type. Then, when you click on the _Create_ button, Auth0 will create your Application and redirect you to its _Quick Start_ section. From there, you will have to click on the _Settings_ tab to change a configuration on your Auth0 Application and to copy some values from it.

![Creating a React application on Auth0.](https://cdn.auth0.com/blog/react-tutorial/creating-a-react-application-at-auth0.png)

So, after heading to the _Settings_ tab, search for the _Allowed Callback URLs_ field and insert `http://localhost:3000/callback` on it.

You are probably wondering what this URL means and why you need it. The reason why you need this URL is because, while authenticating through Auth0, your users will be redirected to its Universal Login Page and, after the authentication process (successful or not), they will be redirected back to your application. For security reasons, Auth0 will redirect your users only to URLs registered on this field.

With this value in place, you can click on the _Save_ button and leave this page open.

### Securing your Backend API with Auth0

To secure your Node.js API with Auth0, you will have to install and configure only two libraries:

- [`express-jwt`](https://github.com/auth0/express-jwt): A middleware that validates a Json Web Token (JWT) and set the `req.user` with its attributes.
- [`jwks-rsa`](https://github.com/auth0/node-jwks-rsa): A library to retrieve RSA public keys from a JWKS (JSON Web Key Set) endpoint.

To install these libraries, stop your backend API by hitting `Ctrl` + `c` and issue the following command:

```bash
# from the qa-api directory
npm i express-jwt jwks-rsa
```

After that, open its `./src/index.js` file and import these libraries as follows:

```js
// ... other require statements ...
const jwt = require('express-jwt');
const jwksRsa = require('jwks-rsa');
```

Then, still on this file, create the following constant right before the first POST endpoint (`app.post`):

```js
// ... require statements ...

// ... app definitions ...

// ... app.get endpoints ...

const checkJwt = jwt({
  secret: jwksRsa.expressJwtSecret({
    cache: true,
    rateLimit: true,
    jwksRequestsPerMinute: 5,
    jwksUri: `https://<YOUR_AUTH0_DOMAIN>/.well-known/jwks.json`
  }),

  // Validate the audience and the issuer.
  audience: '<YOUR_AUTH0_CLIENT_ID>',
  issuer: `https://<YOUR_AUTH0_DOMAIN>/`,
  algorithms: ['RS256']
});

// ... app.post endpoints ...

// ... app.listen ...
```

This constant is actually a Express middleware that will validate [ID tokens](https://auth0.com/docs/tokens/id-token). Note that, to make it work, you will have to replace the `<YOUR_AUTH0_CLIENT_ID>` placeholder with the value presented in the _Client ID_ field of your Auth0 Application. Also, you will have to replace `<YOUR_AUTH0_DOMAIN>` with the value presented in the _Domain_ field (e.g. `bk-tmp.auth0.com`).

Then, you will have to make your two POST endpoints use the `checkJwt` middleware. To do this, replace these endpoints with this:

```js
// insert a new question
app.post('/', checkJwt, (req, res) => {
  const {title, description} = req.body;
  const newQuestion = {
    id: questions.length + 1,
    title,
    description,
    answers: [],
    author: req.user.name,
  };
  questions.push(newQuestion);
  res.status(200).send();
});

// insert a new answer to a question
app.post('/answer/:id', checkJwt, (req, res) => {
  const {answer} = req.body;

  const question = questions.filter(q => (q.id === parseInt(req.params.id)));
  if (question.length > 1) return res.status(500).send();
  if (question.length === 0) return res.status(404).send();

  question[0].answers.push({
    answer,
    author: req.user.name,
  });

  res.status(200).send();
});
```

Both endpoints introduce only two changes. First, both of them declare that they want to use `checkJwt`, which make them unavailable to unauthenticated users. Second, both add a new property called `author` on questions and answers. These new properties receive the name (`req.user.name`) of the users issuing requests.

With these changes in place, you can start your backend API again (`node src`) and start refactoring your React application.

> **Note:** You are not adding the `checkJwt` middleware to your GET endpoints because you want them to be publicly accessible. That is, you want unauthenticated users to be able to see questions and answers, but you don't want them to create new questions nor to answer existing ones.

### Securing your React App with Auth0

To secure your React application with Auth0, you will have to install only one library: [`auth0-js`](https://github.com/auth0/auth0.js). This is the official library provided by Auth0 to secure SPAs like yours. To install it, stop the development server and issue this command:

```bash
# from the qa-react directory
npm install auth0-js
```

After that, you can create a class to help you in the authentication workflow. For that, create a new file called `Auth.js` inside the `src` directory, and insert the following code:

```javascript
import auth0 from 'auth0-js';

class Auth {
  constructor() {
    this.auth0 = new auth0.WebAuth({
      // the following three lines MUST be updated
      domain: '<YOUR_AUTH0_DOMAIN>',
      audience: 'https://<YOUR_AUTH0_DOMAIN>/userinfo',
      clientID: '<YOUR_AUTH0_CLIENT_ID>',
      redirectUri: 'http://localhost:3000/callback',
      responseType: 'token id_token',
      scope: 'openid profile'
    });

    this.getProfile = this.getProfile.bind(this);
    this.handleAuthentication = this.handleAuthentication.bind(this);
    this.isAuthenticated = this.isAuthenticated.bind(this);
    this.signIn = this.signIn.bind(this);
    this.signOut = this.signOut.bind(this);
    this.setSession = this.setSession.bind(this);
  }

  getProfile() {
    return this.profile;
  }

  getIdToken() {
    return this.idToken;
  }

  handleAuthentication() {
    return new Promise((resolve, reject) => {
      this.auth0.parseHash((err, authResult) => {
        if (err) return reject(err);
        if (!authResult || !authResult.idToken) {
          return reject(err);
        }
        this.idToken = authResult.idToken;
        this.profile = authResult.idTokenPayload;
        // set the time that the id token will expire at
        this.expiresAt = authResult.expiresIn * 1000 + new Date().getTime();
        resolve();
      });
    })
  }

  isAuthenticated() {
    return new Date().getTime() < this.expiresAt;
  }

  signIn() {
    this.auth0.authorize();
  }

  signOut() {
    // clear id token, profile, and expiration
    this.idToken = null;
    this.profile = null;
    this.expiresAt = null;
  }
}

const auth0Client = new Auth();

export default auth0Client;
```

> **Note:** Just like before, you will have to replace `<YOUR_AUTH0_CLIENT_ID>` and `<YOUR_AUTH0_DOMAIN>` with the values extracted from your Auth0 Application.

As you can see, in this file, you are creating a module that defines the `Auth` class with seven methods:

- `constructor`: Here, you create an instance of `auth0.WebAuth` with your Auth0 values and define some other important configurations. For example, you are defining that Auth0 will redirect users (`redirectUri`) to the `http://localhost:3000/callback` URL (the same one you inserted in the _Allowed Callback URLs_ field previously).
- `getProfile`: This method returns the profile of the authenticated user, if any.
- `getIdToken`: This method returns the `idToken` generated by Auth0 for the current user. This is what you will use while issuing requests to your POST endpoints.
- `handleAuthentication`: This is the method that your app will call right after the user is redirected from Auth0. This method simply reads the hash segment of the URL to fetch the user details and the id token.
- `isAuthenticated`: This method returns if there is an user authenticated or not.
- `signIn`: This method initializes the authentication process. In other words, this method sends your users to the Auth0 login page.
- `signOut`: This method signs a user out by removing variables like `profile`, `id_token`, and `expiresAt`.

Lastly, this module creates an instance of the `Auth` class and exposes it to the world. That is, in your app, you won't have more than one instance of the `Auth` class.

## Conclusion

Mention:
- The Virtual DOM
- Lifecycle