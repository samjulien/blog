---
layout: post
title: "Real-Time Charts using Angular, D3, and Socket.IO"
description: "Learn how to use Angular, D3, and Socket.IO to build an application that provides real-time charts to its users."
longdescription: "In this article, you will learn how to use Angular, D3, and Socket.IO to build an application that provides real-time charts to its users. You will start from scratch so you get the opportunity to grasp the whole process."
date: "2018-06-02 08:30"
author:
  name: "Ravi Kiran"
  url: "sravi_kiran"
  mail: "yuvakiran2009@gmail.com"
  avatar: "https://cdn.auth0.com/blog/guest-author/ravi_kiran.jpeg"
design:
  bg_color: "#012C6C"
  image: https://cdn.auth0.com/blog/angular5/logo.png
tags:
- angular
- d3
- real-time
- socketio
- frontend
- guest-author
related:
- 2018-05-07-whats-new-in-angular6
- 2018-04-30-whats-new-in-rxjs-6
---

**TL;DR:** Charts create some of the most catchy sections on any business applications. A chart that updates in real time is even more catchy/useful and adds huge value for users. Here, you will see how to create real-time charts using Angular, D3, and Socket.IO. You can find the final code produced throughout this article in [this GitHub repository](https://github.com/auth0-blog/angular-d3-socketio).

## Introduction

With evolution of the web, needs of users are also increasing. The capabilities of the web in the present era can be used to build very rich interfaces. The interfaces may include widgets in the dashboards, huge tables with incrementally loading data, different types of charts and anything that you can think of. Thanks to the technologies like WebSockets, users want to see the UI updated as early as possible. This is a good problem for you to know how to dael with.

In this article, you will build a virtual market application that shows a D3 multi-line chart. That chart will consume data from a Node.js backend consisting of an Express API and a SocketIO instance to get this data in real time.

## Creating a Virtual Market Server

The demo app you are going to build consists of two parts. One is a Node.js server that provides market data and the other is an Angular application consuming this data. As stated, the server will consist of an Express API and a SocketIO endpoint to serve the data continuously.

So, to create this server and this Angular application, you will a directory to hold the source code. As such, create a new directory called `virtual-market` and, inside this folder, create a sub-directory called `server`. In a terminal (e.g. Bash or PowerShell), you can move into the `server` directory and run the following command:

```bash
# move into the server directory
cd virtual-market/server/

# initialise it as a NPM project
npm init -y
```

This command will generate the `package.json` file with some default properties. After initialising this directory as a NPM project, run the following command to install some dependencies of the server:

```bash
npm install express moment socket.io
```

Once they are installed, you can start building your server.

### Building the Express API

First, create a new file called `market.js` inside the `server` directory. This file will be used like a utility. It will contain the data of a virtual market and it will contain a method to update the data. For now, you will add the data alone and the method will be added while creating the Socket.IO endpoint. So, add the following code to this file:

```js
const marketPositions = [
  {"date": "10-05-2012", "close": 68.55, "open": 74.55},
  {"date": "09-05-2012", "close": 74.55, "open": 69.55},
  {"date": "08-05-2012", "close": 69.55, "open": 62.55},
  {"date": "07-05-2012", "close": 62.55, "open": 56.55},
  {"date": "06-05-2012", "close": 56.55, "open": 59.55},
  {"date": "05-05-2012", "close": 59.86, "open": 65.86},
  {"date": "04-05-2012", "close": 62.62, "open": 65.62},
  {"date": "03-05-2012", "close": 64.48, "open": 60.48},
  {"date": "02-05-2012", "close": 60.98, "open": 55.98},
  {"date": "01-05-2012", "close": 58.13, "open": 53.13},
  {"date": "30-04-2012", "close": 68.55, "open": 74.55},
  {"date": "29-04-2012", "close": 74.55, "open": 69.55},
  {"date": "28-04-2012", "close": 69.55, "open": 62.55},
  {"date": "27-04-2012", "close": 62.55, "open": 56.55},
  {"date": "26-04-2012", "close": 56.55, "open": 59.55},
  {"date": "25-04-2012", "close": 59.86, "open": 65.86},
  {"date": "24-04-2012", "close": 62.62, "open": 65.62},
  {"date": "23-04-2012", "close": 64.48, "open": 60.48},
  {"date": "22-04-2012", "close": 60.98, "open": 55.98},
  {"date": "21-04-2012", "close": 58.13, "open": 53.13}
];

module.exports = {
  marketPositions,
};
```

Now, add another file and name it `index.js`. This file will do all the Node.js work required. For now, you will add the code to create an Express REST API to serve the data. So, add the following code to the file `index.js`:

```js
const app = require('express')();
const http = require('http').Server(app);
const market = require('./market');

const port = 3000;

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});

app.get('/api/market', (req, res) => {
  res.send(market.marketPositions);
});

http.listen(port, () => {
  console.log(`Listening on *:${port}`);
});
```

After saving this file, you can check if everything is going well. Run the following command to start your Express REST API:

```bash
# from the server directory, run the server
node index.js
```

As this command starts your Node.js server on port `3000`, you can visit the [`http://localhost:3000/api/market`](http://localhost:3000/api/market) URL to see the market updates on last few days.

![Fake market data to show on real-time Angular application.](https://cdn.auth0.com/blog/angular-d3-socketio/market-data-v2.png)

### Adding Socket.IO to Serve Data in Real Time

To show a real-time chart, you will need to simulate a real-time market data by updating it every 5 seconds. For this, you will add a new method to the `market.js` file. This method will be called from a Socket.IO endpoint that you will add to your `index.js` file. So, open the file `market.js` and add the following code to it:

```js
// const marketPositions ...

let counter = 0;

function updateMarket() {
  const diff = Math.floor(Math.random() * 1000) / 100;
  const lastDay = moment(marketPositions[0].date, 'DD-MM-YYYY').add(1, 'days');
  let open;
  let close;

  if (counter % 2 === 0) {
    open = marketPositions[0].open + diff;
    close = marketPositions[0].close + diff;
  } else {
    open = Math.abs(marketPositions[0].open - diff);
    close = Math.abs(marketPositions[0].close - diff);
  }

  marketPositions.unshift({
    date: lastDay.format('DD-MM-YYYY'),
    open,
    close
  });
  counter++;
}

module.exports = {
  marketPositions,
  updateMarket,
};
```

The `updateMarket` method generates a random number every time it is called and adds it to (or subtracts it from) the last market value to generate some randomness in the figures. Then, it adds this entry to the `marketPositions` array.

Now, open the `index.js` file, so you can create a Socket.IO connection to it. This connection will call the `updateMarket` method after every 5 seconds to update the market data and will emit an update on the Socket.IO endpoint to update the latest data for all listeners. In this file, make the following changes:

```js
// ... other import statements ...
const io = require('socket.io')(http);

// ... app.use and app.get ...

setInterval(function () {
  market.updateMarket();
  io.sockets.emit('market', market.marketPositions[0]);
}, 5000);

io.on('connection', function (socket) {
  console.log('a user connected');
});

// http.listen(3000, ...
```

With these changes in place, you can start building the Angular client to use this. To keep the server running, issue the command `node index.js`, if you haven't done it yet.

## Building the Angular Application

To generate your Angular application, you can use Angular CLI. There are two ways to do it. One is to install a local copy of the CLI globally in your machine and the other is to use a tool that comes with NPM that is called `npx`. Using `npx` is better because it avoids the need to install the package locally and because you always get the latest version. If you want to use `npx`, make sure that you have npm 5.2 or above installed.

Then, go back to the main directory of your whole project (i.e. the `virtual-market` directory) and run the following command to generate the Angular project:

```bash
npx @angular/cli new angular-d3-chart
```

Once the project is generated, you need to install both the D3 and Socket.IO NPM libraries. So, move to the `angular-d3-chart` directory and run the following command to install these libraries:

```bash
npm install d3 socket.io-client
```

As you will use these libraries with TypeScript, it is good to have their typings installed. So, run the following command to install the typings:

```bash
npm i @types/d3 @types/socket.io-client -D
```

Now that the setup process is done, you can run the application to see if everything is fine:

```bash
# from the angular-d3-chart directory
npm start
```

To see the default Angular application, just point your browser to the [`http://localhost:4200`](http://localhost:4200) URL.

### Building a component to display multi-line chart
Now that the application setup is ready, let's add the required code to it. We will be adding a component to display a multiline d3 chart and the chart will use the data served by the Node.js server. As first thing, let's create a service to fetch the data. For now, the service will consume the REST API to get the stock data. We will consume realtime data from the socket.io endpoint later. Run the following command to add a file for this service:

```bash
npx ng generate service market-status
```

Or you could use the shorter form of this command:

```bash
npx ng g s market-status
```

To consume the REST APIs, we need the `HttpClient` service from the module `HttpClientModule`. The module `HttpClientModule` has to be imported into the application's module for this. Open the file `app.module.ts` and change it as shown below:

```typescript
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

The changes made in this file are marked with numbered comments. The `HttpClientModule` is imported and it is added to the `imports` section of the module.


Open the file `market-status.service.ts` on your editor and add the following code to it:

```typescript
import { Injectable } from  '@angular/core';
import { HttpClient } from  '@angular/common/http';
import { Subject, Observable } from  'rxjs';

import  *  as socketio from  'socket.io-client';

import { MarketPrice } from  './market-price';

@Injectable({
  providedIn: 'root'
})
export class MarketStatusService {
  
  private baseUrl =  'http://localhost:3000';
  constructor(private httpClient: HttpClient) { }

  getInitialMarketStatus() {
    return this.httpClient.get<MarketPrice[]>(`${this.baseUrl}/api/market`);
  }
}
```

The variable `socketio` imported in the above file will be used later to fetch data from the Socket IO endpoint.

The `MarketStatusService` uses the class `MarketPrice` for the structure of the data received from the API. Let's create this class now. Add a new file named `market-price.ts` to the `app` folder and add the following code to it:

```typescript
export  class MarketPrice {
  open: number;
  close: number;
  date: string | Date;
}
```

Add a new component to the application, this will show the multi-line d3 chart. The following command adds this component:

```bash
npx ng g c market-chart
```

Open the file `market-chart.component.html` and replace the default content in this file with the following:

```html
<div #chart></div>
```

The d3 chart will be rendered inside this div element. As you see, we created a local variable for the div element, it will be used to get the reference of the element in the component class. This component will not use the `MarketStatusService` to fetch data. Instead, it will accept the data as input. This is done to make the `market-chart` component reusable. For this, the component will have an `Input` field and the value to this field will be passed from the `app-root` component. The component will use the `ngOnChanges` lifecycle hook to render the chart whenever there is change in the data and it will use the `OnPush` change detection strategy to ensure that the chart is re-rendered only when the input changes.

Open the file `market-chart.component.ts` and add the following code to it:

```typescript
import { Component, OnChanges, Input, ElementRef, ChangeDetectionStrategy, ViewChild } from '@angular/core';
import * as d3 from 'd3';

import { MarketPrice } from '../market-price';

@Component({
  selector: 'app-market-chart',
  templateUrl: './market-chart.component.html',
  styleUrls: ['./market-chart.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class MarketChartComponent implements OnChanges {
  @ViewChild('chart')
  chartElement: ElementRef;

  parseDate = d3.timeParse('%d-%m-%Y');

  @Input()
  marketStatus: MarketPrice[];

  private svgElement: HTMLElement;
  private chartProps: any;

  constructor() { }

  ngOnChanges() { }

  formatDate() {
    this.marketStatus.forEach(ms => {
      if (typeof ms.date === 'string') {
        ms.date = this.parseDate(ms.date);
      }
    });
  }
}
```

Now the `MarketChartComponent` class has everything required to render the chart. In addition to the local variable for the div and the lifecycle hook, the class has a few fields that will be used while rendering the chart. The `parseDate` method converts string value to date. It is used by the `formatData` method. The private fields `svgElement` and `chartProps` will be used to hold reference of the SVG element and the properties of the chart respectively. These fields would be quite useful to re-render the chart.

Add the following method to the `MarketChartComponent` to build the chart:

```typescript
 buildChart() {
  this.chartProps = {};
  this.formatDate();

  // Set the dimensions of the canvas / graph
  var margin = { top: 30, right: 20, bottom: 30, left: 50 },
    width = 600 - margin.left - margin.right,
    height = 270 - margin.top - margin.bottom;

  // Set the ranges
  this.chartProps.x = d3.scaleTime().range([0, width]);
  this.chartProps.y = d3.scaleLinear().range([height, 0]);

  // Define the axes
  var xAxis = d3.axisBottom(this.chartProps.x);
  var yAxis = d3.axisLeft(this.chartProps.y).ticks(5);

  let _this = this;

  // Define the line
  var valueline = d3.line<MarketPrice>()
    .x(function (d) {
      if (d.date instanceof Date) {
        return _this.chartProps.x(d.date.getTime());
      }
    })
    .y(function (d) { console.log('Close market'); return _this.chartProps.y(d.close); });

  // Define the line
  var valueline2 = d3.line<MarketPrice>()
    .x(function (d) {
      if (d.date instanceof Date) {
        return _this.chartProps.x(d.date.getTime());
      }
    })
    .y(function (d) { console.log('Open market'); return _this.chartProps.y(d.open); });

  var svg = d3.select(this.chartElement.nativeElement)
    .append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g')
    .attr('transform', `translate(${margin.left},${margin.top})`);

  // Scale the range of the data
  this.chartProps.x.domain(
    d3.extent(_this.marketStatus, function (d) {
      if (d.date instanceof Date)
        return (d.date as Date).getTime();
    }));
  this.chartProps.y.domain([0, d3.max(this.marketStatus, function (d) {
    return Math.max(d.close, d.open);
  })]);

  // Add the valueline2 path.
  svg.append('path')
    .attr('class', 'line line2')
    .style('stroke', 'green')
    .style('fill', 'none')
    .attr('d', valueline2(_this.marketStatus));

  // Add the valueline path.
  svg.append('path')
    .attr('class', 'line line1')
    .style('stroke', 'black')
    .style('fill', 'none')
    .attr('d', valueline(_this.marketStatus));


  // Add the X Axis
  svg.append('g')
    .attr('class', 'x axis')
    .attr('transform', `translate(0,${height})`)
    .call(xAxis);

  // Add the Y Axis
  svg.append('g')
    .attr('class', 'y axis')
    .call(yAxis);

  // Setting the required objects in chartProps so they could be used to update the chart
  this.chartProps.svg = svg;
  this.chartProps.valueline = valueline;
  this.chartProps.valueline2 = valueline2;
  this.chartProps.xAxis = xAxis;
  this.chartProps.yAxis = yAxis;
}
```

Refer to the comments added before every section in the above method to understand what it does. It has to be called from the `ngOnChanges` lifecycle hook. Change code in this method as follows:

```typescript
ngOnChanges() {
  if (this.marketStatus) {
    this.buildChart();
  }
}
```

Now we need to use this component in the `app-root` component to see the chart. Open the file `app.component.html` and place the following code in it:

```html
<app-market-chart [marketStatus]="marketStatusToPlot"></app-market-chart>
```

And replace content of the file `app.component.ts` with the following code:

```typescript
import { Component } from  '@angular/core';
import { MarketStatusService } from  './market-status.service';
import { Observable } from  'rxjs/Observable';
import { MarketPrice } from  './market-price';

@Component({
selector: 'app-root',
templateUrl: './app.component.html',
styleUrls: ['./app.component.css']
})
export  class AppComponent {
  title =  'app';
  marketStatus: MarketPrice[];
  marketStatusToPlot: MarketPrice[];

  set MarketStatus(status: MarketPrice[]) {
    this.marketStatus = status;
    this.marketStatusToPlot =  this.marketStatus.slice(0, 20);
  }

  constructor(private marketStatusSvc: MarketStatusService) {

  this.marketStatusSvc.getInitialMarketStatus()
    .subscribe(prices => {
      this.MarketStatus = prices;
    });
  }
}
```

Save these changes and run the application using the `ng serve` command. Visit the URL http://localhost:4200, you will see a page with a chart similar to the following image:

[Figure 1 - image of chart]

### Updating the Chart when the Market has an Update
Now that we have the chart rendered on the page, let's receive the market updates from socket.io and update the chart. To receive the updates, we need to add a listener to the socket.io endpoint in the service `market-status.service.ts`. Open this file and add the following method to it:

```typescript
getUpdates() {
  let socket = socketio(this.baseUrl);
  let marketSub =  new Subject<MarketPrice>();
  let marketSubObservable = Observable.from(marketSub);

  socket.on('market', (marketStatus: MarketPrice) => {
    marketSub.next(marketStatus);
  });

  return marketSubObservable;
}
```

The above method does three important things:

 - Creates a manager for the socket.io endpoint at the given URL
 - Creates an RxJS `Subject` and gets the observable from this subject. The observable is returned from this method so that it could be used by the consumer of the service to listen to the updates
 - The call to `on` method on the socket.io manager adds a listener to the `market` event. The callback passed to this method is called whenever the socket.io event publishes something

This method has to be consumed in the `app-root` component. Open the file `app.component.ts` and modify the constructor as shown below:

```typescript
constructor(private marketStatusSvc: MarketStatusService) {
  this.marketStatusSvc.getInitialMarketStatus()
    .subscribe(prices => {
      this.MarketStatus = prices;

      let marketUpdateObservable =  this.marketStatusSvc.getUpdates();  // 1
      marketUpdateObservable.subscribe((latestStatus: MarketPrice) => {  // 2
        this.MarketStatus = [latestStatus].concat(this.marketStatus);  // 3
      });  // 4
    });
}
```

In the above snippet, the statements marked with the numbers are the new lines added to the constructor. Observe the statement labeled with 3. This statement creates a new array instead of updating the field `marketStatus`. This is done to let the consuming `app-market-chart` component know about the change when we have an update.

The last change we need to do to see the chart working is, updating the chart with the new data. Open the file `market-chart.component.ts` and add the following method to it:

```typescript
updateChart() {
  let _this = this;
  this.formatDate();

  // Scale the range of the data again
  this.chartProps.x.domain(d3.extent(this.marketStatus, function (d) {
    if (d.date instanceof Date) {
      return d.date.getTime();
    }
  }));

  this.chartProps.y.domain([0, d3.max(this.marketStatus, function (d) { return Math.max(d.close, d.open); })]);

  // Select the section we want to apply our changes to
  this.chartProps.svg.transition();

  // Make the changes to the line chart
  this.chartProps.svg.select('.line.line1') // update the line
    .attr('d', this.chartProps.valueline(this.marketStatus));

  this.chartProps.svg.select('.line.line2') // update the line
    .attr('d', this.chartProps.valueline2(this.marketStatus));

  this.chartProps.svg.select('.x.axis') // update x axis
    .call(this.chartProps.xAxis);

  this.chartProps.svg.select('.y.axis') // update y axis
    .call(this.chartProps.yAxis);
}
```

The comments added in the snippet explain what we are doing in it. This method has to be called from the `ngOnChanges` method. Change this method as shown below:

```typescript
ngOnChanges() {
  if (this.marketStatus &&  this.chartProps) {
    this.updateChart();
  }
  else if (this.marketStatus) {
    this.buildChart();
  }
}
```

Now if you run the application, you will see an error on the browser console saying `global is not defined`.

[Figure 2 - console error saying global is not defined]

This is because, Angular CLI 6 removed the global object and socket IO uses it. To fix this, add the following statement to the file `polyfills.ts`:

```typescript
(window as any).global = window;
```

With this, all the changes are done. Save the changes and run the application. Now you will see the graph updating once in every 5 seconds.

## Conclusion
As we saw in this tutorial, the web has capabilities to build very rich applications to show realtime updates to the users in a format that gives an immediate impression about the change in data. Let's use these features to build great experiences for our users!