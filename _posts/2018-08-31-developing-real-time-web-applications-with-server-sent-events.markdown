---
layout: post
title: "Developing Real-Time Web Applications with Server-Sent Events"
description: "Learn how to create real-time web applications by using the Server-Sent Events specification."
date: 2018-08-31 08:30
category: Technical Guide, Backend
author:
  name: "Andrea Chiarelli"
  url: "https://twitter.com/andychiare"
  mail: "andrea.chiarelli.ac@gmail.com"
  avatar: "https://pbs.twimg.com/profile_images/827888770510880769/nnvUxzSd_400x400.jpg"
design:
  image: https://cdn.auth0.com/blog/api-introduction/logo.png
  bg_color: "#202226"
tags:
- real-time
- backend
- node-js
- react
- server-sent-events
- sse
- javascript
related:
- 2018-06-12-real-time-charts-using-angular-d3-and-socket-io
- 2017-11-21-developing-real-time-apps-with-meteor
---

**TL;DR:** [Server-Sent Events (SSE)](https://html.spec.whatwg.org/multipage/server-sent-events.html) is a standard that enables Web servers to push data in real time to clients. In this article, we will learn how to use this standard by building a flight timetable demo application with React and Node.js. However, the concepts you will learn following this tutorial are applicable to any programming language and technology. [You can find the final code of the application in this GitHub repository](https://github.com/andychiare/server-sent-events).

## Introducing on Server-Sent Events

The [typical interactions between browsers and servers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Session) consist on browsers requesting resources and servers providing responses. But, can we make our servers send data to clients at any time without explicit requests?

The answer is _yes_! We can achieve that by using [Server-Sent Events (which is also known as *SSE* or *Event Source*)](https://html.spec.whatwg.org/multipage/server-sent-events.html), a W3C standard that allows servers to push data to clients asynchronously. This may suggest using that annoying polling we'd implement to get the progress status from a long server processing but, thanks to SSE, we don't have to implement polling to wait for a response from the server. We don't even need any complex and strange protocol. That is, we can continue to use the standard HTTP protocol.

So, let's take a look at how to use Server-Sent Events in a realistic application.

## Building a Real-Time App with Server-Sent Events

In order to learn how to use Server-Sent Events, we are going to develop a simple flight timetable application (similar to those flight trackers you can find at any airport). The timetable app will consist of a simple web page showing a list of flights as shown in the following picture:

![Real-time flights tracker timetable](./xxx-images/flights-timetable.png)

Through this real-time app, we can find the flight arrival timetable and, after implementing Server-Sent Events, we will see automatically updates when the state of flights change. In our demo application, we are going to simulate the flight state changes using scheduled events. However, one can easily replace this mechanism with more realistic ones on production-ready applications.

So, let's start coding and discover how the Server-Sent Events standard works.

### Scaffolding a React Application

As the first step, let's scaffold our React client application. To make things simple, we will use [`create-react-app`](https://github.com/facebook/create-react-app) to set up our React-based client. So, [let's make sure that we have Node.js installed](https://nodejs.org/en/download/) on our machine and let's type the following command in a terminal window:

```shell
# installing create-react-app globally
npm install -g create-react-app
```

After installing `create-react-app` in our development machine, let's create the basic template of a React application by typing:

```shell
create-react-app real-time-sse-app
```

After a few seconds, we will get a new directory called `real-time-sse-app` with all the files we need inside it. In particular, the `src` subdirectory contains the source code of our brand-new React application. Our goal is to change the code of this basic React application and replace it with our flight timetable frontend application.

Since our application will show data in a tabular form, we will install a React component that simplifies the task of rendering data into tables: [_React Table_](https://react-table.js.org). To add this component to our application, we will type the following commands in our terminal:

```shell
# make sure we are on the React app project root
cd real-time-sse-app

# then install the React Table dependency
npm install react-table
```

Now, we are ready to start changing the application code. So, let's open the `App.js` file (which resides inside the `src` directory) and let's replace its content with the following one:

```javascript
// src/App.js

import React, { Component } from 'react';
import ReactTable from 'react-table';
import 'react-table/react-table.css';
import { getInitialFlightData } from './DataProvider';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: getInitialFlightData()
    };

    this.columns = [{
      Header: 'Origin',
      accessor: 'origin'
    }, {
      Header: 'Flight',
      accessor: 'flight'
    }, {
      Header: 'Arrival',
      accessor: 'arrival'
    }, {
      Header: 'State',
      accessor: 'state'
    }];
  }

  render() {
    return (
      <div className="App">
        <ReactTable
          data={this.state.data}
          columns={this.columns}
        />
      </div>
    );
  }
}

export default App;
```

Here, we are importing the stuff we need to set up the flight timetable. In particular, in addition to standard React basic elements, we are importing the `ReactTable` component with its basic stylesheets and a method called `getInitialFlightData` from a module called `DataProvider`. We haven't defined this module yet but we will, quite soon. The goal of this function will be to provide our application with flight data that is used to initialize the `App` component's `state`.

In the constructor, we also define the table's structure by mapping flight properties to table columns. As we can see, this mapping consists of an array of objects like the following:

```javascript
this.columns = [{
    Header: 'Origin',
    accessor: 'origin'
  }, {
    Header: 'Flight',
    accessor: 'flight'
  }, {
    Header: 'Arrival',
    accessor: 'arrival'
  }, {
    Header: 'State',
    accessor: 'state'
  }];
```

As defined above, each flight object contains a `Header` property (representing the column's header) and an `accessor` property (representing the flight property whose value will be shown in that column). _React Table_ has many other options to define the table's structure, but `Header` and `accessor` are sufficient for our goal.

Finally, within the `render` method of `App` component, we include the `ReactTable` element and pass to it the flight data and the columns as props.

Now, within the `src` folder, let's create a file named `DataProvider.js` and populate it with the following code:

```javascript
// src/DataProvider.js

export function getInitialFlightData() {
  return [{
    origin: 'London',
    flight: 'A123',
    arrival: '08:15',
    state: ''
  }, {
    origin: 'Berlin',
    flight: 'D654',
    arrival: '08:45',
    state: ''
  }, {
    origin: 'New York',
    flight: 'U213',
    arrival: '09:05',
    state: ''
  }, {
    origin: 'Buenos Aires',
    flight: 'A987',
    arrival: '09:30',
    state: ''
  }, {
    origin: 'Rome',
    flight: 'I768',
    arrival: '10:10',
    state: ''
  }, {
    origin: 'Tokyo',
    flight: 'G119',
    arrival: '10:35',
    state: ''
  }];
}
```

The module above exports the `getInitialFlightData` function that simply returns a static array of flight data. In a real application, the function would request data from a server. However, for the purpose of this article, the current implementation is enough. 

So far, our application presents the flight data in tabular form. Let's check it out in a web browser! To run the app, type the following command in the terminal:

```shell
# from the real-time-sse-app, start the React app
npm start
```

After a few seconds, we should see in the browser the list of flights as shown in the picture above. If the browser doesn't open automatically, please open it and go to [`http://localhost:3000`](http://localhost:3000).

> **Note:** For some unknown reason, the application fails to start, issuing `npm i` from the `real-time-sse-app` directory might solve the problem.
