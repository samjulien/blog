---
layout: post
title: "Developing Well-Organized APIs with Node.js, Joi, and Mongo"
description: "In this article, you will learn how to create well-organized APIs with Node.js, Restify, Joi, and MongoDB."
date: 2018-04-03 08:30
category: Technical Guide, Backend, NodeJS
author:
  name: "Biodun Chris"
  url: "https://twitter.com/biodunch"
  avatar: "https://cdn.auth0.com/blog/guest-author/biodun-chris.jpeg"
design:
  bg_color: "#333333"
  image: https://cdn.auth0.com/blog/logos/node.png
tags:
- nodejs
- mongo
- joi
- restify
related:
- 2018-05-02-nodejs-10-new-changes-deprecations
- 2018-03-29-vuejs-kanban-board-the-development-process
---

**TL;DR:** This article covers building an api with [Restify](https://restify.com), using [joi](https://github.com/hapijs/joi) to validate request and [mongodb](https://mongodb.org) as the database. The projects fully implements Dependency Injection technology. The full code can be found on [github](https://github.com/biodunch/birthdates-api.git).

## Developing Well-Organized APIs with Node.js

In this article, you will build a birthdates API that lets you register and query birthdays from the people you know.

Structuring Node.js APIs has been a pain most beginner Node.js developers have been through. So, in the next sections, you will learn how to properly structure and organise a RESTful Node.js API with some cool tools like Restify, Joi and MongoDB. 

## What Tools Will You Use

As mentioned, you will use tools like Restify, Joi, and MongoDB. This section provides a brief overview about these tools.

### Restify

[Restify](http://restify.com/) is a Node.js web service framework optimized for building semantically-correct RESTful web services ready for production. If you check their official web page, you will see that big companies like Netflix and Pinterest use Restify in their applications.

### Joi

You will use [Joi](https://github.com/hapijs/joi) to validate `params`, `queries`, and the `body` of requests. Joi, seating at the route level, basically check for correctness of the requests sent to the API. Only requests that are semantically correct reach the controllers of your application.

### MongoDB

MongoDB is a cross-platform and open-source document-oriented database (also known as a NoSQL database). You will use MongoDB to persist and retrieve the data (birthdates) managed by the API that you will build throughout the article.

## Building the Birthdates API

Firstly, you will need to check if you have Node.js, NPM, and a MongoDB instance installed in your development machine:

```bash
node --version
npm --version
mongo --version
```

If you don't have Node.js and NPM, go [grab them from this URL](https://nodejs.org/en/download/). If you don't have MongoDB, you can find instructions on [how to install it in this URL](https://docs.mongodb.com/manual/installation/).

### Birthdates API Endpoints

After checking the dependencies, you can start building your application. In the end, you will have an API with the following endpoints:

* `POST` `/users`: An endpoint to create new users.
* `GET` `/users/{username}`: An endpoint to retrieve users by their usernames. 
* `POST` `/birthdates`: And endpoint to register new birthdates.
* `POST` `/birthdates/{username}`: An endpoint to retrieve the birthdate of a certain user.

### Setup the Project Structure

You will start the creation of your app from scratch. So, create a new directory called `birthdates-api` (this will be referenced as the project root) and execute the following commands:


```bash
# if you haven't yet, create the project root
mkdir birthdates-api

# move the terminal into it
cd birthdates-api

# create subdirectories
mkdir -p app/configs app/controllers app/lib app/middlewares \
  app/models app/routes app/services app/validations
```

Next, you will need to initialize the project with `npm` so you get a `package.json` file to describe your project and manage its dependencies. So, execute the command below in the project root and follow the prompt (set the `entry point` to `server.js`):

```bash
# answer all questions asked by NPM
npm init
```

### Installing Dependencies

After initialising your project with NPM, you can install its dependencies:


```bash
npm install --save mongoose restify joi http-status restify-errors restify-url-semver winston@next dotenv
```

The list below provides a brief explanation of what these libraries do:

* `mongoose` is a MongoDB object modeling tool designed to work in an asynchronous environment.
* `http-status` is a utility to interact with HTTP status code.
* `restify-errors` is a library that contains sets of error contructors to create new error objects with their default status codes.
* `restify-url-semver` is a library used for versioning the Restify API.
* `winston` is a universal logging library with support for multiple transports.
* `dotenv` is a tiny package that loads environment variables from `.env` file into `process.env`.

### Creating app configuration

Storing app config in the environment is one of the methodologies in [12 factor app](https://12factor.net/) techniques which defines specifications for building software-as-a-service apps in modern era.
An app’s config is everything that is likely to vary between deploys, using environment variables makes it easy to change values of configs depending on the environment without having to change any code.


Let's create app configuration and store in `.env` file in the root directory of our project.

```sh
# .env

NODE_PATH=.
APPLICATION_ENV=development

APP_NAME=birthdate-api
APP_PORT=5000
LOG_PATH=logs/birthdate-api.log
LOG_ENABLE_CONSOLE=true

DB_PORT=27017
DB_HOST=localhost
DB_NAME=birthdates
```

Next is to load the variables in `config.js` file

Inside `app/configs`, create `configs.js` and add the code below:

```js
// app/configs/configs.js

'use strict';

module.exports = () => ({
    app: {
        name: process.env.APP_NAME,
        port: process.env.APP_PORT || 8000,
        environment: process.env.APPLICATION_ENV,
        logpath: process.env.LOG_PATH,
    },
    mongo: {
        port: process.env.DB_PORT,
        host: process.env.DB_HOST,
        name: process.env.DB_NAME
    },
    application_logging: {
        file: process.env.LOG_PATH,
        level: process.env.LOG_LEVEL || 'info',
        console: process.env.LOG_ENABLE_CONSOLE || true
    }
});
```
Node.js environment variables are always loaded into `process.env`. So to access any variable declared in `.env` file, all we do is `process.env.VAR_NAME`. So if we want to change a variable due to change in environment, we don't need to modify the `config` file, we modify the `.env` file.

### Setting up Restify Server

#### Create a formatter to be used by restify for json responses
Inside `lib` directory, create `jsend.js`:

```js
// app/lib/jsend.js

'use strict';
/**
 * JSON formatter.
 * @public
 * @function formatJSON
 * @param    {Object} req  the request object
 * @param    {Object} res  the response object
 * @param    {Object} body response body
 * @returns  {String}
 */
function formatJSend(req, res, body) {
    function formatError(res, body) {
        const isClientError = res.statusCode >= 400 && res.statusCode < 500;
        if (isClientError) {
            return {
                status: 'error',
                message: body.message,
                code: body.code
            };
        } else {
            const inDebugMode = process.env.NODE_ENV === 'development';

            return {
                status: 'error',
                message: inDebugMode ? body.message : 'Internal Server Error',
                code: inDebugMode ? body.code : 'INTERNAL_SERVER_ERROR',
                data: inDebugMode ? body.stack : undefined
            };
        }
    }

    function formatSuccess(res, body) {
        if (body.data && body.pagination) {
            return {
                status: 'success',
                data: body.data,
                pagination: body.pagination,
            };
        }

        return {
            status: 'success',
            data: body
        };
    }

    let response;
    if (body instanceof Error) {
        response = formatError(res, body);
    } else {
        response = formatSuccess(res, body);
    }

    response = JSON.stringify(response);
    res.header('Content-Length', Buffer.byteLength(response));
    res.header('Content-Type', 'application/json');

    return response;
}

module.exports = formatJSend;
```
Let's analyze it:

The function checks the body of the response if it's an error type, in that case it calls the `formatError` function that construct a `jsend` compliant error response with the http status code. Otherwise, the `formatSuccess` is called for every successful request transaction and formatted following the `jsend` json response specification.

Our formatter overrides the default restify formatter for `content-type` of `application/json`


Let's create a `server.js` file in the root directory of the project to start the restify server and require our `jsend` formatter.

```js
// server.js

'use strict';

require('dotenv').config()
const config = require('app/configs/configs')();
const restify = require('restify');
const versioning = require('restify-url-semver');

// Initialize and configure restify server
const server = restify.createServer({
    name: config.app.name,
    versions: ['1.0.0'],
    formatters: {
        'application/json': require('app/lib/jsend')
    }
});

// Set API versioning and allow trailing slashes
server.pre(restify.pre.sanitizePath());
server.pre(versioning({ prefix: '/' }));

// Set request handling and parsing
server.use(restify.plugins.acceptParser(server.acceptable));
server.use(restify.plugins.queryParser());
server.use(
    restify.plugins.bodyParser({
        mapParams: false
    })
);

// start server
server.listen(config.app.port, () => {
    console.log(`${config.app.name} Server is running on port - 
    ${config.app.port}`);
});
```

First thing we did was to load the variables in `.env` file into `process.env` once the app starts up. We proceed to importing dependencies and creating server with the configuration we created previously.

__NOTE: Unix users would need this command: 
`export $(cat .env | sed -e /^$/d -e /^#/d | xargs)` in the root directory - `birthdates-api/` to load the .env variables to shell environment.__

Inside the project root directory, start the server with this command:

```sh
$ node server.js
```
If it was successful, you should see this in your console:

![Server is Running](https://i.imgur.com/yk47VG9.png)

### Setting up Logger

Let's create a wrapper for `winston` to format the output of the logs and create transport based on the environment.
Create `logger.js` inside `app/lib/`

```js
// app/lib/logger.js

"use strict";

const { createLogger, format, transports } = require('winston');
const { combine, timestamp, label, prettyPrint } = format;

/**
    * Creates transports based on config values
    * @returns {array} the created transports
    */
const createTransports = function(config) {
    const customTransports = [];

    // setup the file transport
    if (config.file) {

        // setup the log transport
        customTransports.push(
            new transports.File({
                filename: config.file,
                level: config.level
            })
        );
    }

    // if config.console is set to true, a console logger will be included.
    if (config.console) {
        customTransports.push(
            new transports.Console({
                level: config.level
            })
        );
    }

    return customTransports;
};

module.exports = {
    /**
        * Creates a new logger instance using the config provided.
        * @param  {object} config The config used to setup the logger transports.
        * @return {logger} Returns a new instance of the winston logger.
        */
    create: function (config) {
        return new createLogger({
            transports: createTransports(config),
            format: combine(
                    label({ label: 'Birthdates API' }),
                    timestamp(),
                    prettyPrint()
                )
        });
    }
};
```
For a quickstart on how to create winston logger, have a look at the [documentation](http://github.com/winstonjs/winston). 

For this tutorial, we created two transports; `console` and `file`. Both transports use the log level we set in our environment variable which can be overrid in the code with `logger.log_level(...)` e.g. `logger.info(...)` instead of `logger.log(...)` which uses the default log level in our `.env` file. 

Based on the environment you can set the value of console logging to false or true in `.env` file. Again, for this tutorial we enabled logging to the console so we can see all our logs in the console without having to tail a log file. However, logging to the console is not advisable in a production environment.

### Setting up Dependency injection
Instead of having your objects creating a dependency, you pass the needed dependencies in to the object externally, and you make it somebody else's problem. To achieve this, we can use an object higher up in the dependency graph or a dependency injector (library) to pass the dependencies. 

For this tutorial, we will use a custom library, `service_locator` to inject dependencies to the objects that needs to hold a reference to them.

Create `service_locator.js` inside `app/lib/`

```js
// app/lib/service_locator.js

'use strict';

/**
 * A Service Locator.
 *
 * Used to register and resolve dependency in a recursive mannner.
 * @class ServiceLocator
 * @constructor
 */
function ServiceLocator() {
    this.dependencyMap = {};
    this.dependencyCache = {};
}

/**
 * Adds a dependency to the container.
 *
 * @method register
 * @param  {String}   dependencyName The dependency name
 * @param  {Function} constructor    The function used for initially instantiating the dependency.
 * @return {void}
 */
ServiceLocator.prototype.register = function(dependencyName, constructor) {
    if (typeof constructor !== 'function') {
        throw new Error(dependencyName + ': Dependency constructor is not a function');
    }

    if (!dependencyName) {
        throw new Error('Invalid depdendency name provided');
    }

    this.dependencyMap[dependencyName] = constructor;
};

ServiceLocator.prototype.get = function(dependencyName) {
    if (this.dependencyMap[dependencyName] === undefined) {
        throw new Error(dependencyName + ': Attempting to retrieve unknown dependency');
    }

    if (typeof this.dependencyMap[dependencyName] !== 'function') {
        throw new Error(dependencyName + ': Dependency constructor is not a function');
    }

    if (this.dependencyCache[dependencyName] === undefined) {
        const dependencyConstructor = this.dependencyMap[dependencyName];
        const dependency = dependencyConstructor(this);
        if (dependency) {
            this.dependencyCache[dependencyName] = dependency;
        }
    }

    return this.dependencyCache[dependencyName];
};

/**
 * Clears all the dependencies from this container and from the cache.
 * @method clear
 * @return {void}
 */
ServiceLocator.prototype.clear = function() {
    this.dependencyCache = {};
    this.dependencyMap = {};
};

module.exports = new ServiceLocator();

```
Let's analyze it:

* `register` method takes in the dependency name and its constructor, then proceeds to add it to the `dependencyMap` object initialized in our `ServiceLocator` constructor.

* `get` method retrieves a dependency from the `dependencyMap` that matches the name passed in as the function argument. If the requested dependency is not in the cache, it initializes the dependency and adds it to the cache then returns it.

* `clear` basically just removes all dependencies from the map and cache

We will use the serviceLocator object to manage our app dependencies.

Let's proceed to create `di.js` file inside `app/configs/` where we will initialize all our app dependencies.


```js
// app/configs/di.js

'use strict';

const serviceLocator = require('app/lib/service_locator');
const config = require('app/configs/configs')();

serviceLocator.register('logger', () => {
    const logger = require('app/lib/logger').create(config.application_logging);

    return logger;
});

serviceLocator.register('httpStatus', () => {
    return require('http-status');
});

serviceLocator.register('mongoose', () => {
    const mongoose = require('mongoose');

    return mongoose;
});

serviceLocator.register('errs', () => {
    return require('restify-errors');
});

module.exports = serviceLocator;
```

Calling the  `register` method adds a dependency to the dependency graph and can be retrieved by calling the `get` method with the `dependencyName`.

### Setup our database
Before we proceed, let's start mongodb server in a separate terminal window and leave it running:

```sh
$ mongod
```

If the command above fails, checkout their [documentation](https://docs.mongodb.com/manual/tutorial/) on how to start the server for your OS.

Create `database.js` inside `app/configs/`

```js
// app/configs/database.js

'use strict';

const serviceLocator = require('app/lib/service_locator');
const logger = serviceLocator.get('logger');

class Database {
    constructor(port, host, name) {
        this.mongoose = serviceLocator.get('mongoose');
        this._connect(port, host, name);
    }

    _connect(port, host, name) {
        this.mongoose.Promise = global.Promise;
        this.mongoose.connect(`mongodb://${host}:${port}/${name}`);
        const { connection } = this.mongoose;
        connection.on('connected', () =>
            logger.info('Database Connection was Successful')
        );
        connection.on('error', (err) =>
            logger.info('Database Connection Failed' + err)
        );
        connection.on('disconnected', () =>
            logger.info('Database Connection Disconnected')
        );
        process.on('SIGINT', () => {
            connection.close();
            logger.info(
                'Database Connection closed due to NodeJs process termination'
            );
            process.exit(0);
        });

        // initialize Model
        require('app/models/Users');
    }
}

module.exports = Database;
```
Our Database class has just a single method that connects to the running mongodb server. We added some listeners for series of events that might occur in the server lifecycle. Lastly in the `_connect()` method we initialize our `users` model which we will create in the next section.

For our Birthdates api, we need to define a model, `Users` and a submodel, `Birthdates`. The `Users` model would hold the properties of the user using the api e.g. `username`, `birthdate` and lastly `birthdates`. The `birthdates` submodel would define the `fullname` and `birthdates` of our friends and we will embed it as an array inside the `Users` model.

Create `Users.js` inside `app/models/`

```js
// app/models/Users.js

'use strict';

const config = require('app/configs/configs');
const serviceLocator = require('app/lib/service_locator');
const mongoose = serviceLocator.get('mongoose');

const birthdatesSchema = new mongoose.Schema({
    fullname: {
        type: String,
        trim: true,
        required: true
    },
    birthdate: {
        type: Date,
        required: true
    }
});

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        trim: true,
        required: true,
        unique: true,
        lowercase: true
    },
    birthdate: {
        type: Date,
        required: true
    },
    birthdates: [birthdatesSchema]
},
{
    timestamps: true
});

module.exports = mongoose.model('Users', userSchema);
```

We defined two schemas:

* `birthdatesSchema`: This used as a subdocument in the users model defining the `fullname` of the person whose birthdates we want to save and the `birthdates` properties.

* `userSchema`: We defined `username` of the user, their `birthdate` and array of `birthdates` from the `birthdatesSchema`. We also enabled `timestamp` which automatically adds `created_at` and `updated_at` properties to every document.

### Add API Specific code
Next is to setup `services`, `controllers` and `routers` to handle requests. Inside `app/services`, we will create `user` service to handle business related to the `users` such as creating user, fetching user, etc. 

```js
// app/services/user.js

'use strict';

class UserService {
    constructor(log, mongoose, httpStatus, errs) {
        this.log = log;
        this.mongoose = mongoose;
        this.httpStatus = httpStatus;
        this.errs = errs;
    }

    async createUser(body) {
        const Users = this.mongoose.model('Users');
        const { username } = body;
        const user = await Users.findOne({ username });

        if (user) {
            const err = new this.errs.InvalidArgumentError(
                'User with username already exists'
            );
            return err;
        }

        let newUser = new Users(body);
        newUser.birthdate = new Date(body.birthdate);
        newUser = await newUser.save();

        this.log.info('User Created Successfully');
        return newUser;
    }

    async getUser(username) {
        const Users = this.mongoose.model('Users');
        const user = await Users.findOne({ username });

        if (!user) {
            const err = new this.errs.NotFoundError(
                `User with username - ${username} does not exists`
            );
            return err;
        }

        this.log.info('User fetched Successfully');
        return user;
    }
}

module.exports = UserService;
```
Let's analyze it:

* `constructor` initalizes all the dependencies passed to it from our dependency injection file when creating the object.

* `createUser` method checks if the user with the username in the request body exist then throws an error that 'User with username already exists' already exists otherwise it proceeds to save the user and returns the result to the controller.

* `getUser` method fetches the user that matches the `username` provided and returns the result to the controller.

Now we have the chunks of code to create a user and get a specified user. Let's proceed to create the controller to implement this service. 

Noticed how we were able to recieve and initialize the dependencies of the `user service` inside it's constructor? The dependency injection makes that possible, we will get to that part soon.

Inside `app/controllers/`, create `user.js`:

```js
// app/controllers/user.js

'use strict';

class UserController {
    constructor(log, userService, httpSatus) {
        this.log = log;
        this.userService = userService;
        this.httpSatus = httpSatus;
    }

    async create(req, res) {
        try {
            const { body } = req;
            const result = await this.userService.createUser(body);
            
            res.send(result);
        } catch (err) {
            this.log.error(err.message);
            res.send(err);
        }
    }

    async get(req, res) {
        try{
            const { username } = req.params;
            const result = await this.userService.getUser(username);
            
            res.send(result);
        } catch (err) {
            this.log.error(err.message);
            res.send(err);
        }
    }

}

module.exports = UserController;
```
The controller basically calls the services to perform particular action and sends response back to the client. 

Now, let's create birthdate service and controller to save and fetch birthdates. Inside `app/services`, create `birthdates.js`.

```js
// app/services/birthdates.js

'use strict';

class BirthdateService {
    constructor(log, mongoose, httpStatus, errs) {
        this.log = log;
        this.mongoose = mongoose;
        this.httpStatus = httpStatus;
        this.errs = errs;
    }

    async createBirthdate(username, body) {
        const Users = this.mongoose.model('Users');
        const user = await Users.findOne({ username });
        const { birthdate, fullname } = body;

        if (!user) {
            const err = new this.errs.NotFoundError(
                `User with username - ${username} does not exists`
            );
            return err;
        }

        user.birthdates.push({
            birthdate: this.formatBirthdate(birthdate),
            fullname
        });

        return user.save();
    }

    formatBirthdate(date) {
        return new Date(date);
    }

    async getBirthdates(username) {
        const Users = this.mongoose.model('Users');
        const user = await Users.findOne({ username });

        if (!user) {
            const err = new this.errs.NotFoundError(
                `User with username - ${username} does not exists`
            );
            return err;
        }

        return user.birthdates;
    }
}

module.exports = BirthdateService;

```
Let's analyze it:

* `constructor` initalizes all the dependencies passed to it from our dependency injection file when creating the object.

* `createBirthdate` method fetches the user that made the request, then saves the `birthdates` with the `fullname` and returns the result to the Birthdate controller which completes the request. 

* `getBirthdates` method gets all the `birthdates` of the user that made the request and returns the result to the Birthdate controller which completes the request.

Let's proceed to create the controller for our `birthdates service`.

Inside `app/controllers/`, create `birthdates.js`:

```js
// app/controllers/birthdates

'use strict';

const serviceLocator = require('app/lib/service_locator');

class BirthdateController {
    constructor(log, birthdateService, httpSatus) {
        this.log = log;
        this.birthdateService = birthdateService;
        this.httpSatus = httpSatus;
    }

    async create(req, res) {
        try {
            const { body } = req;
            const { username } = req.params;
            const result = await this.birthdateService.createBirthdate(
                username,
                body
            );
            if(result instanceof Error) 
                res.send(result);
            else res.send(`${body.fullname}'s birthdate saved successfully!`)
        } catch (err) {
            this.log.error(err.message);
            res.send(err);
        }
    }

    async listAll(req, res) {
        try {
            const { username } = req.params;
            const result = await this.birthdateService.getBirthdates(username);
            res.send(result);
        } catch (err) {
            this.log.error(err.message);
            res.send(err);
        }
    }
}

module.exports = BirthdateController;
```
We need to register the services and controllers we just created with our `serviceLocator` so we can inject their dependencies with ease.
Open up `app/configs/di.js` and add the code below:

```js
// app/configs/di.js

...

serviceLocator.register('birthdateService', (serviceLocator) => {
    const log = serviceLocator.get('logger');
    const mongoose = serviceLocator.get('mongoose');
    const httpStatus = serviceLocator.get('httpStatus');
    const errs = serviceLocator.get('errs');
    const BirthdateService = require('app/services/birthdates');

    return new BirthdateService(log, mongoose, httpStatus, errs);
});

serviceLocator.register('userService', (serviceLocator) => {
    const log = serviceLocator.get('logger');
    const mongoose = serviceLocator.get('mongoose');
    const httpStatus = serviceLocator.get('httpStatus');
    const errs = serviceLocator.get('errs');
    const UserService = require('app/services/user');

    return new UserService(log, mongoose, httpStatus, errs);
});

serviceLocator.register('birthdateController', (serviceLocator) => {
    const log = serviceLocator.get('logger');
    const httpStatus = serviceLocator.get('httpStatus');
    const birthdateService = serviceLocator.get('birthdateService');
    const BirthdateController = require('app/controllers/birthdates');

    return new BirthdateController(log, birthdateService, httpStatus);
});

serviceLocator.register('userController', (serviceLocator) => {
    const log = serviceLocator.get('logger');
    const httpStatus = serviceLocator.get('httpStatus');
    const userService = serviceLocator.get('userService');
    const UserController = require('app/controllers/user');

    return new UserController(log, userService, httpStatus);
});
```
We are almost ready to take this baby for a spin!!! :grin: But lastly, we have to setup routes and request validation with `joi`.

### Setting up validation with `joi`
If you are not familiar with `joi`, checkout the github [repo](https://github.com/hapijs/joi#example) for a quickstart. 

To use `joi`, we create blueprints or schemas for JavaScript objects (an object that stores information) to ensure validation of key information. `joi` runs validation against the rule we declared in the schemas for all requests.

Let's have a look at the schema defining rules to validate the endpoints for creating users.

Inside `app/validations/`, create `create_user.js`:

```js
// app/validations/create_user.js

'use strict';

const joi = require('joi');

module.exports = joi.object().keys({
    username: joi.string().alphanum().min(4).max(15).required(),
    birthdate: joi.date().required()
}).required();
```
The above schema defines the following constraints:

* username
    * a required string
    * must contain only alphanumeric characters
    * at least 4 characters long but no more than 15

* birthdate
    * a required date field

Now that you know how `joi` works, let's create validations for the remaining endpoints.

```js
// app/validations/create_birthdates.js

'use strict';

const joi = require('joi');

module.exports = joi.object().keys({
    fullname: joi.string().min(5).max(60).required(),
    birthdate: joi.date()
}).required();
```

```js
// app/validations/get_birthdates-user.js

'use strict';

const joi = require('joi');

module.exports = {
    username: joi.string().alphanum().min(4).max(30).required()
};

```
Now that we have the schema defining the validation rules, let's create a tiny library to run the validation everytime request is made.

Inside `app/lib/`, create `validator.js`:

```js
// app/lib/validator.js

'use strict';

let httpStatus              = require('http-status');
let errors                  = require('restify-errors');

/**
 * Route Parameter validation middleware
 *
 * @param log an instance of the console logger
 * @param joi an instance of the joi schema validator
 * @returns {Function}
 */
module.exports.paramValidation = function(log, joi) {

    return function(req, res, next) {

        // always allow validation to allow unknown fields by default.
        let options = {
            allowUnknown: true
        };

        let validation = req.route.spec.validation; //validation object in route
        if (!validation) {
            return next(); // skip validation if not set
        }

        let validProperties = ['body', 'query', 'params'];

        for (let i in validation) {
            if (validProperties.indexOf(i) < 0) {
                log.debug('Route contains unsupported validation key');
                throw new Error('An unsupported validation key was set in route');

            } else {
                if (req[i] === undefined) {
                    log.debug('Empty request ' + i + ' was sent');

                    res.send(
                        httpStatus.BAD_REQUEST,
                        new errors.InvalidArgumentError('Missing request ' + i)
                    );
                    return;
                }

                let result = joi.validate(req[i], validation[i], options);

                if (result.error) {
                    log.debug('validation error - %s', result.error.message);

                    res.send(
                        httpStatus.BAD_REQUEST,
                        new errors.InvalidArgumentError(
                            'Invalid request ' + i + ' - ' + result.error.details[0].message
                        )
                    );
                    return;

                } else {
                    log.info('successfully validated request parameters');
                }
            }
        }

        next();
    };
};
```
Firstly, the function retrieves the `validation` property defined in the route `spec`. We proceed to check if the `request` object contains a valid `validation property` key e.g. `body`, `query` or `params`. 


If it does, we validate the value obtained from the `request` object  with the predefined set of rules (schema) for the request path. If the input is invalid, the result will be an Error object.

Now, let's define the routes and provide the validation rules for all the paths.

Inside `app/routes/`, create `routes.js`:

```js
// app/routes/routes.js

'use strict';

module.exports.register = (server, serviceLocator) => {

    server.post(
        {
            path: '/users',
            name: 'Create User',
            version: '1.0.0',
            validation: {
                body: require('app/validations/create_user')
            }
        },
        (req, res, next) =>
            serviceLocator.get('userController').create(req, res, next)
    );

    server.get(
        {
            path: '/users/:username',
            name: 'Get User',
            version: '1.0.0',
            validation: {
                params: require('app/validations/get_birthdates-user.js')
            }
        },
        (req, res, next) =>
            serviceLocator.get('userController').get(req, res, next)
    );

    server.get(
        {
            path: '/birthdates/:username',
            name: 'Get Birthdates',
            version: '1.0.0',
            validation: {
                params: require('app/validations/get_birthdates-user.js')
            }
        },
        (req, res, next) =>
            serviceLocator.get('birthdateController').listAll(req, res, next)
    );

    server.post(
        {
            path: '/birthdates/:username',
            name: 'Create Birthdate',
            version: '1.0.0',
            validation: {
                body: require('app/validations/create_birthdates')
            }
        },
        (req, res, next) =>
            serviceLocator.get('birthdateController').create(req, res, next)
    );
};
```
We now have four endpoints defined, POST - `/users`, GET - `/users/{username}`, GET - `/birthdates/{username}`, POST - `/birthdates/{username}`. 

After defining the route spefication in the first arguments, we specify the controller to handle the request to that particular path.

### Handling restify errors
Restify has built in error event listener that get fired when Error is encountered by restify as part of a next(error) statement. Let's proceed to add handlers for possible errors we want to listen for.

Inside `app/lib/`, create `error_handler.js`:

```js
// app/lib/error_handler.js 

'use strict';

/**
 * Allows us to register the restify server handlers.
 *
 * @param  {server} server An instance of the restify server
 */
module.exports.register = (server) => {
    var httpStatusCodes = require('http-status');

    server.on('NotFound', (req, res) => {
        res.send(
            httpStatusCodes.NOT_FOUND,
            new Error('Method not Implemented', 'METHOD_NOT_IMPLEMENTED')
        );
    });

    server.on('VersionNotAllowed', (req, res) => {
        res.send(
            httpStatusCodes.NOT_FOUND,
            new Error('Unsupported API version requested', 'INVALID_VERSION')
        );
    });

    server.on('InvalidVersion', (req, res) => {
        res.send(
            httpStatusCodes.NOT_FOUND,
            new Error('Unsupported API version requested', 'INVALID_VERSION')
        );
    });

    server.on('MethodNotAllowed', (req, res) => {
        res.send(
            httpStatusCodes.METHOD_NOT_ALLOWED,
            new Error('Method not Implemented', 'METHOD_NOT_ALLOWED')
        );
    });

    server.on('restifyError', (req, res) => {
        res.send(httpStatusCodes.INTERNAL_SERVER_ERROR, err);
    });
};
```
Whenever error is encountered in our application, the appropriate error handler is called. If an error not defined above should occur, the last handler we declared, `restifyError` would catch such a `error`.

### Finishing up
Let's update the `server.js` file to initialize the route and our request validator.

```js
// server.js

...

const serviceLocator = require("app/configs/di");
const validator = require("app/lib/validator");
const handler = require("app/routes/error_handler");
const routes = require("app/routes/routes");
const joi = require("joi");
const logger = serviceLocator.get("logger");

const server = restify.createServer({
    ...
});

// Initialize the database
const Database = require("app/configs/database");
new Database(config.mongo.port, config.mongo.host, config.mongo.name);

...

// initialize validator for all requests
server.use(validator.paramValidation(logger, joi));

// Setup Error Event Handling
handler.register(server);

// Setup route Handling
routes.register(server, serviceLocator);

server.listen(config.app.port, () => {
    ...
});

```

### Conclusion 
That's it!!! We have just built a well organised api with Restify.
Let's take our baby for a spin, shall we ?

First we create a `User`:

```sh
$ curl -H "Content-Type: application/json" -X POST -d '{"username":"biodunch","birthdate":"12/2/2000"}' localhost:5000/v1/users
```

Response:

```json
{
   "status":"success",
   "data":{
      "_id":"5adbb4819b09be4ea8da5902",
      "username":"biodunch",
      "birthdate":"2000-12-01T23:00:00.000Z",
      "birthdates":[],
      "createdAt":"2018-04-21T22:00:33.838Z",
      "updatedAt":"2018-04-21T22:00:33.838Z",
      "__v":0
   }
}
```
Now, let's create birthdate for the created user:

```sh
$ curl -H "Content-Type: application/json" -X POST -d '{"fullname":"Falomo Olumide","birthdate":"10/3/2000"}' localhost:5000/v1/birthdates/biodunch
```
Response:

```json
{
   "status":"success",
   "data":"Falomo Olumide's birthdate saved successfully!"
}
```

Now, let's fetch the birthdates saved by `biodunch` :)

```sh
$ curl localhost:5000/v1/birthdates/biodunch
```
Response:

```json
{
   "status":"success",
   "data":[
      {
         "_id":"5adbb5e59b09be4ea8da5903",
         "birthdate":"2000-10-02T23:00:00.000Z",
         "fullname":"Falomo Olumide"
      }
   ]
}
```
