---
layout: post
title: "React Tutorial: Building and Securing Your First App"
description: "Learn how React works and create and secure your first React app in no time."
date: 2018-07-03 08:30
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

## Conclusion

Mention:
- The Virtual DOM