---
layout: post
title: "TypeScript from Top to Bottom - Part 1: Developing an API with Nest.js"
description: "Learn how to use TypeScript to create a full-stack web application with Angular and Nest.js"
date: "2018-06-07 08:30"
category: Technical Guide, Node.js, Nest.js
author:
  name: "Ana Ribeiro"
  url: "https://twitter.com/anacosri"
  mail: "aninhacostaribeiro@gmail.com"
  avatar: "https://cdn.auth0.com/blog/guest-authors/ana-ribeiro.jpg"
design:
  image: https://cdn.auth0.com/blog/nestjs/logo.png
  bg_color: "#090909"
tags:
- typescript
- angular
- nest
- auth0
- full-stack
- frontend
- backend
related:
- 2017-10-05-nestjs-brings-typescript-to-nodejs-and-express
- 2017-10-31-typescript-practical-introduction.markdown
---

**TL;DR:** This is a small series on how to build a full-stack TypeScript application using Angular and Nest.js. In this first part, you are going to learn how to build a simple API with Nest.js. The second part is going to be about the frontend application using Angular.

## What Is Nest.Js and Why Use It with Angular?

[Nest.js](https://docs.nestjs.com/) is a framework for building Node.js web applications. What makes it special is that it addresses a problem that no other framework does: the architecture of a Node.js project. If you have ever tried to build a project using Node.js, you may have realized that you can do a lot with one module (for example, an Express middleware can do everything from authentication to validation) which can lead to unorganized and hard-to-support projects. As you will see through this article, Nest.js helps developers keeping their code organized by providing different classes that specialize on different problems.

Besides that, what makes combining Nest.js and [Angular](https://angular.io/) a good idea is that Nest.js is heavily inspired by Angular. For example, you will find that both frameworks use guards to allow or prevent access to some parts of your apps and that both frameworks provide the `CanActivate` interface to implement these guards. Nevertheless, it is important to notice that, although sharing some similar concepts, both frameworks are independent from each other. That is, in this article, you will build a front-end-agnostic API. So, after building the API, you will be able to use it with other frameworks and libraries like React, Vue.js, and so on.

## The App You Will Build

The app that you are going to create in this tutorial is a simple app for restaurants where users will be able to order items online. There are some business rules for this app:

 * any user can see the items of this menu;
 * only identified users may add items to a shop cart (order food online); 
 * and only admin users may add new items to the menu.  

To keep things simple, you are not going to interact with any external database, nor implement the shop cart functionality.

## Getting Started with Nest.js

To install Nest.js, first you will need to install Node.js (`v.8.9.x` or newer) and NPM. So, go to [the Node.js download website](https://nodejs.org/en/download/) and follow the instructions to download and install Node.js to your operating system (NPM comes with Node.js). When done, you can check if everything went well by running the following commands:

```bash
node -v # v.8.9.0
npm -v # 5.6.0
```

There are a few ways to start a Nest.js project, you may check all of them in [the Nest.js documentation](https://docs.nestjs.com/first-steps). Here, you are going to use `nest-cli` to do so. To install this tool, run the following command:

```bash
npm i -g @nestjs/cli # it will install the nest command
```

Then, you can create a new project by running a single command. This command will trigger some questions about the project, such as version and project name, but you can stick with default options:

```bash
nest new nest-restaurant-api # nest-restaurant-api
```

If everything went well, you will get by the end of this process a directory called `nest-api` with the following structure:

```bash
nest-api
├── README.md
├── nodemon.json
├── package-lock.json
├── package.json
├── src
│   ├── app.controller.spec.ts
│   ├── app.controller.ts
│   ├── app.module.ts
│   ├── app.service.ts
│   ├── main.hmr.ts
│   └── main.ts
├── test
│   ├── app.e2e-spec.ts
│   └── jest-e2e.json
├── tsconfig.json
├── tslint.json
└── webpack.config.js
``` 

Now, you can navigate to this directory and type the following command to start the API:

```bash
# move into the project
cd nest-restaurant-api

# start the development server
npm run start:dev
```

Then, if you head to [`localhost:3000`](localhost:3000) in your browser, you will see a page like the following one:

![Nest.js showing the hello world webpage.](https://cdn.auth0.com/blog/fullstack-typescript/hello-nest.png)

To avoid adding more complexity, this article is not going to teach you how to write automated tests for your API (though you should write them for any production-ready app). As such, you can go ahead and delete the `test` directory and the `src/app.controller.spec.ts` file (which is test relate). After that,the remaining files inside the `src` directory will be:

* `app.controller.ts` and `app.service.ts`: those files are responsible for generating the message _Hello world_ when the endpoint `/` is accessed through the browser. Because this endpoint is not important to this application you may delete these files as well. Soon you are going to learn in more details what **controllers** and **services** are.
* `app.module.ts`: this is a class of the type **module** that is responsible for declaring imports,exports, controllers, and providers to a Nest.js application. Every application has at least one module but you may create more than one module for more complex applications (more details on [Nest.js documentation](https://docs.nestjs.com/modules)). The application of this tutorial will have only one module. 
* `main.ts`: this is the file responsible for starting the server.
* `main.hrm.ts`: is a [Hot Module Replacement](https://webpack.js.org/concepts/hot-module-replacement/) file that installs modules during the server execution and it is useful to speed up the development process.

> **Note:** after removing `app.controller.ts` and `app.service.ts` you won't be able to start your app. Don't worry, you will fix this soon.

## Creating Nest.js Endpoints

The most important endpoint of this app will be `/items` because, from there, users will be able to retrieve the items available and admins will be able to manage these items. So, this is the first endpoint that you are going to implement.

To do so, you will have to create a directory called `items` inside `src`. You will store all files related to the `/items` endpoint in this new directory.

### Creating a controller

In Nest, like in many other web frameworks out there, [Controllers](https://docs.nestjs.com/controllers) are responsible for mapping endpoints to functionalities. To create a controller in Nest, you can use the `@Controller` decorator, as follows: `@Controller(${ENDPOINT})`. Then, to map different HTTP methods like GET and POST, you would use decorators like: `@Get`, `@Post`, `@Delete`, etc.

So, as in your case you need to create a controller that returns items available on a restaurant and that admins can use to manage these items, you can create a file called `items.controller.ts` and add the following code to it:


```typescript
import {
  Get,
  Post,
  Controller,
} from '@nestjs/common';

@Controller('items')
export class ItemsController {

  @Get()
  async findAll(): Promise<string[]> {
    return ['Pizza', 'Coke'];
  }

  @Post()
  async create() {
    return 'Not yet implemented';
  }
}
```

Then, to make your controller available in your module (and in you app), you will have to update `app.module.ts` as follows:

```typescript
import { Module } from '@nestjs/common';
import { ItemsController } from './items/items.controller';

@Module({
  imports: [],
  controllers: [ItemsController],
  providers: [],
})
export class AppModule {}
```

Now, you can head to [http://localhost:3000/items](http://localhost:3000/items) (you might need to restart your app: npm run start:dev) and you will get an array containing `['Pizza', 'Coke']`. 

### Adding a service

The array returned by the `/items` endpoint is just an static array that is recreated for every request and that cannot be altered. As the handling of structures that persist data should not be addressed by controllers, you will create a service to handle that.

Services, in Nest, are classes marked with the `@Injectable` decorator. As the name states, adding this decorator to classes make them injectable in other components, like controllers.

So, now, you can create a new file called `items.service.ts` in the `./src/items directory`, and add the following code:

```typescript
import { Injectable } from '@nestjs/common';

@Injectable()
export class ItemsService {
  private readonly items: string[] = ["Pizza", "Coke"];

  findAll(): string[] {
    return this.items;
  }

  create(item: string) {
    this.items.push(item);
  }
}
```

Then, you will need to change ItemsController to use this service:

```typescript
import {
    Get,
    Post,
    Body,
    Controller,
  } from '@nestjs/common';
  import { ItemsService } from './items.service';

  @Controller('items')
  export class ItemsController {

  constructor(private readonly itemsService: ItemsService) {}
  
    @Get()
    async findAll(): Promise<string[]> {
      return this.itemsService.findAll();
    }
  
    @Post()
    async create(@Body('item') item: string) {
      this.itemsService.create(item);
    }
  }
```

Note that the create method has a parameter decorated with `@Body('item')` to map data sent through `req.body['item']` to the parameter itself (item in this case).

The class itemsService is injected through `constructor`. The `private readonly` that accompanies the ItemsService declaration makes this instance only visible inside this class and unchangeable.

Now, to make `ItemsService` available in your app, you will need to update `app.modules.ts` as follows:

```typescript
import { Module } from '@nestjs/common';
import { ItemsController } from './items/items.controller';
import { ItemsService } from './items/items.service';

@Module({
  imports: [],
  controllers: [ItemsController],
  providers: [ItemsService],
})
export class AppModule {}
```

With these changes in place, you can issue HTTP POST requests to the menu:

```bash
curl \
-H 'content-type: application/json'\
-d '{item:salad}' \
localhost:3000/items
```

After that, you will be able to see this new item in your menu by issuing the following GET request or by heading to [http://localhost:3000/items](http://localhost:3000/items) in your browser:

```bash
curl localhost:3000/items
```


### Creating a simple route for shop cart

Now that you have the first version of your `/items` endpoint, you can start creating the shopping cart feature. As you will see, the process would be similar to the process of creating for `/items`. As such, to keep things shorter, this feature will only acknowledge with an OK status when triggered.

So, first, create a directory called `shopping-cart` alongside with the items directory. Then, create a new file called `shopping-cart.controller.ts` inside it and add the following code:

```typescript
import {
  Post,
  Controller,
} from '@nestjs/common';

@Controller('shopping-cart')
export class ShopcartController {
  @Post()
  async addItem() {
    return "This is a fake service :D";
  }
}
```

Then, add this controller to your module (`app.modules.ts`):

```typescript
import { Module } from '@nestjs/common';
import { ItemsController } from './items/items.controller';
import { ShopcartController } from './shopping-cart/shopping-cart.controller';
import { ItemsService } from './items/items.service';

@Module({
  imports: [],
  controllers: [ItemsController, ShopcartController],
  providers: [ItemsService],
})
export class AppModule {}
```

Test this endpoint with the following Curl command: 


```bash
curl -X POST localhost:3000/shopping-cart
```

## Adding a typescript interface for items

Back to the items service, imagine that you want to keep more than just the name of the items (for instance, its prices too). Do you agree that an array of strings may not be the most ideal structure to handle this data?

To solve this problem, you could create an array of objects, but it would be hard to keep all items coherent (i.e. with similar structures). As such, the best approach is to create a TypeScript interface to define the structure of your items. To do this, create a new file called item.interface.ts inside the `./src/items` directory and add the following code to it:

```typescript
export class Item {
  readonly name: string;
  readonly price: number;
}
```

Then, change both `items.service.ts` and `items.controller.ts` to use this interface:

```typescript
import { Injectable } from '@nestjs/common';
import { Item } from './item.interface';

@Injectable()
export class ItemsService {
  private readonly items: Item[] = [];

  findAll(): Item[] {
    return this.items;
  }

  create(item: Item) {
    this.items.push(item);
  }
}
```

```typescript
import {
    Get,
    Post,
    Body,
    Controller,
  } from '@nestjs/common';
import { ItemsService } from './items.service';
import { Item } from './item.interface';

@Controller('items')
export class ItemsController {

  constructor(private readonly itemsService: ItemsService) {}
  
  @Get()
    async findAll(): Promise<Item[]> {
      return this.itemsService.findAll();
    }
  
    @Post()
    async create(@Body('item') item: Item) {
      this.itemsService.create(item);
    }
}
```

## Adding validation with DTO and Pipes

Even though you created an interface to define the structure of items, the application won't return an error status if you post any type of data other than the one defined in the interface to /item. For example, the following request should return a 400 (bad request) status, but instead it returns a 200 (all good) status:

```bash
curl \
-H 'Content-Type: application/json' \
-H 'authorization: Bearer ${TOKEN}'\
-d '{
  "name": 3,
  "price": "any"
}' http://localhost:3000/items
```

To solve this problem, we are going to create a [DTO (Data Transfer Object)](https://en.wikipedia.org/wiki/Data_transfer_object) together a Pipe. A DTO, as the name states, is an object that defines how data must be transferred among processes. To create a DTO to your items, add a new file called `create-item.dto.ts` in the `./src/items` directory and add the following code to it:

```typescript
import { IsString, IsInt } from 'class-validator';

export class CreateItemDto {
  @IsString() readonly name: string;

  @IsInt() readonly price: number;
}
```

[Pipe](https://docs.nestjs.com/pipes) are Nest.js components that are useful for validation. For your API, you are going to create a pipe that verifies if the data sent to a method matches its DTO. As pipes can be used by several controllers, you will create a directory called `common` inside `src` and a file called `validation.pipe.ts` that looks like this:

```typescript
import { BadRequestException } from '@nestjs/common';
import {
  PipeTransform,
  Injectable,
  ArgumentMetadata,
  HttpStatus,
} from '@nestjs/common';
import { validate } from 'class-validator';
import { plainToClass } from 'class-transformer';

@Injectable()
export class ValidationPipe implements PipeTransform<any> {
  async transform(value, metadata: ArgumentMetadata) {
    const { metatype } = metadata;
    if (!metatype || !this.toValidate(metatype)) {
      return value;
    }
    const object = plainToClass(metatype, value);
    const errors = await validate(object);
    if (errors.length > 0) {
      throw new BadRequestException('Validation failed');
    }
    return value;
  }

  private toValidate(metatype): boolean {
    const types = [String, Boolean, Number, Array, Object];
    return !types.find(type => metatype === type);
  }
}
``` 
**Note**: You may have to install `class-validator` and `class-transformer` modules, just type `npm install class-validator class-transformer` on the terminal, inside your project's directory and restar the server.

Now you will have to adapt the  `items.controller.ts` file to use this new pipe and the DTO. After doing that, this is how the code of the controller should like:

```typescript
import {
  Get,
  Post,
  Body,
  Controller,
  UsePipes,
} from '@nestjs/common';
import { CreateItemDto } from './create-item.dto';
import { ItemsService } from './items.service';
import { Item } from './item.interface';
import { ValidationPipe } from '../common/validation.pipe';

@Controller('items')
export class ItemsController {
  constructor(private readonly itemsService: ItemsService) {}

  @Get()
  async findAll(): Promise<Item[]> {
    return this.itemsService.findAll();
  }

  @Post()
  @UsePipes(new ValidationPipe())
  async create(@Body() createItemDto: CreateItemDto) {
    this.itemsService.create(createItemDto);
  }
}
```

Now, running your code again, the `/item` endpoint will only accept data as defined in the DTO, such as in the following example:

```bash
curl \
-H 'Content-Type: application/json' \
-d '{
  "name": "Salad",
  "price": 3
}' http://localhost:3000/items
```

## Managing Identity with Auth0

One of the requirements of this project is that only identified users could add something to the shopping carts and only admin users could add a new product. To easily and securely achieve that, you are going to use Auth0

First you have to create a [free Auth0 account](https://auth0.com/signup) if you don't have one yet. Login to your account and head to [the APIs section in your Auth0 dashboard](https://manage.auth0.com/#/apis) and hit the Create API button. Then, in the form that Auth0 shows, add a name to your API (something like Menu), set its identifier to `http://localhost:3000` and hit the Create button. Don't change the signing algorithm (leave it as `RS256`) as it is the best option from the security point of view.

![API configuration](https://i.imgur.com/kl2IpiD.png "API configuration")

Then you should visit the [Applications section](https://manage.auth0.com/#/applications) of your auth0 manager dashboard, and click on the application with the same name of the API you just created.  In this page, go to the Settings section and change the Application Type to `Single Page Application` and add `http://localhost:8080/login` (you are going to use it in the next article) to Allowed Callback URLs. Then, leave this page opened as you will need to copy your _Domain_, _Client ID_, and _Client Secret_ to configure your API.

![Application configuration](https://screenshotscdn.firefoxusercontent.com/images/b15bfdea-b630-4594-8976-968fce721a9b.png "Application configuration")

Now, you can generate an access token with Auth0. You will use this token soon, after securing your API. To do that, first visit the following address with your browser:

```bash
https://${YOUR_DOMAIN}/authorize?audience=http://localhost:3000&scope=SCOPE&response_type=code&client_id=${YOUR_CLIENT_ID}&redirect_uri=http://localhost:8080/login&state=STATE?prompt=none
```
Just don't forget to change your domain and your client id to those retrieved in the past steps. If everything is correct, you should get the following page:

![Auth0 login page](https://screenshotscdn.firefoxusercontent.com/images/c1fcca54-b321-4c1a-9b36-02ff88ee275f.png "Auth0 login page")

Proceed to login as you would do in any Auth0 application (you may create a new account or use your google account, and then you must give your permission to the application to access your account) and then the page will return to the following address: 

```bash 
http://localhost:8080/login?code=${CODE}&state=${SOME_STATE}
```

You will get a white page. From there, copy the value returned in the place of `${CODE}` and do the following in a terminal:

```bash
curl --request POST \
  --url 'https://anaribeiro.auth0.com/oauth/token' \
  -H 'content-type: application/json' \
  -d '{
    "grant_type":"authorization_code",
    "client_id": "${YOUR_CLIENT_ID}",
    "client_secret": "${YOUR_CLIENT_SECRET}",
    "code": "${CODE}",
    "redirect_uri": "http://localhost:8080"
    }'
```

You will get as the answer of this request a JSON object containing the token, the expiration (86400 seconds or 24 hours) and the token type (bearer). Keep this token as soon you are going to create the code to validate it.

### Express/Nest.js Middleware

According to [Auth0 quick start guide page](https://auth0.com/docs/quickstart/backend/nodejs#configure-the-middleware), the recommended way to verify a JWT token issued by Auth0 is through a [express Middleware](http://expressjs.com/pt-br/guide/using-middleware.html) because there is the module `express-jwt` which automates a huge part of the work. 

Nest.js used to give full support to express Middleware until the [v.5 release](https://github.com/nestjs/nest/releases/tag/v5.0.0), when they drop part of the support to express Middleware to find "a middle-ground between portability and express compatibility.". According to Nest.js documentation, the most indicated way to create code to validate a JWT is through guards, but verifying tokens encrypted with `RS256` technology can be tough, there is a  [a tutorial](https://auth0.com/blog/navigating-rs256-and-jwks/) only on that (you may try to create a Nest.js strategy based on that tutorial). 

But taking into consideration that the code into `express-jwt` is a tested piece of code, the best way to verify an Auth0 issued token using Nest.js is still through an express middleware. You should use express code directly inside of Nest. 

First you will need to create a file named `authentication.middleware.ts` inside the directory `common`, then paste the following code inside of it:

```typescript
import { Injectable, NestMiddleware, MiddlewareFunction } from '@nestjs/common';
import * as jwt from 'express-jwt';
import { expressJwtSecret } from 'jwks-rsa';

@Injectable()
export class AuthenticationMiddleware implements NestMiddleware {
  resolve(): MiddlewareFunction {
    return (req, res, next) => {
      jwt({
        secret: expressJwtSecret({
          cache: true,
          rateLimit: true,
          jwksRequestsPerMinute: 5,
          jwksUri: 'https://${DOMAIN}/.well-known/jwks.json',
        }),

        audience: 'http://localhost:3000',
        issuer: 'https://${DOMAIN}/',
        algorithm: 'RS256',
      })(req, res, (err) => {
        if (err) {
          const status = err.status || 500;
          const message = err.message || 'Sorry, we were unable to process your request.';
          return res.status(status).send({
            message,
          });
        }
        next();
      });
    };
  }
}
```
Don't forget to change `${domain}` to the domain found in the app's settings page. You may will have to install `express-jwt` and `jwks-rsa` (type `Node.js install npm install express-jwt jwks-rsa`), restart the server after doing that. 

```typescript
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { AuthenticationMiddleware } from './common/authentication.middleware';
import * as express from 'express';

async function bootstrap() {
  const server = express();
  const auth = new AuthenticationMiddleware().resolve();
  server.post('/items', auth);
  server.post('/shopping-cart', auth);

  const app = await NestFactory.create(AppModule, server);
  await app.listen(3000);
}

bootstrap();
```

Now method post of the routes `/items` and `/shopping-cart` are protected by an Express middleware that verifies if there is a valid Auth0 token together with the call. You may try to do a call like the following:

```bash
curl \
-H 'authorization: Bearer ${TOKEN}'\
-X POST \
http://localhost:3000/shopping-cart
```

## Managing roles with Auth0

In your API, any user that has a verified token can post an item, but only identified users should be able to do so. For solving this problem, you are going to use the functionality `roles` of auth0. 

Go to your Auth0 dashboard, navigate to [the rules section](https://manage.auth0.com/#/rules), hit the button to create a new rule and select "set a new role to an user" as the rule model:

![rule page](https://cdn.auth0.com/blog/mean-series/rule-new.jpg "rule page")

By doing that, you will get a javascript file with a rule template that adds role admin to any user who have an email provided by some domain. You should change a few details in this template to get a functional example, for this example, you may choose to make only your email as admin. You also will need to change were the information about the admin status is being saved, for now it is saved in an identification token (used to provide information about the user) but to access resources in an API, you should use an access token. The code after the changes is the following one:

```javascript
function (user, context, callback) {
  user.app_metadata = user.app_metadata || {};
  // You can add a Role based on what you want
  // In this case I check domain
  var addRolesToUser = function(user, cb) {
    if (user.email && user.email === '${YOUR_EMAIL}') {
      cb(null, ['admin']);
    } else {
      cb(null, ['user']);
    }
  };

  addRolesToUser(user, function(err, roles) {
    if (err) {
      callback(err);
    } else {
      user.app_metadata.roles = roles;
      auth0.users.updateAppMetadata(user.user_id, user.app_metadata)
        .then(function(){
          context.accessToken['http://localhost:3000/roles'] = user.app_metadata.roles;
          callback(null, user, context);
        })
        .catch(function(err){
          callback(err);
        });
    }
  });
}
```

For checking if the token passed to your API has an Admin tag, you should create a Nest.js [guard](https://docs.nestjs.com/guards) inside of the directory `common` (as it can be used by multiple controllers). The code you should place inside the file `admin.guard.ts` is the following one:

```typescript
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';

@Injectable()
export class AdminGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const user = context.args[0].user['http://localhost:3000/roles'];
    if (user.indexOf('admin') > -1) {
      return true;
    } else {
      return false;
    }
  }
}
```
You can redo the login process described in the last topic and if everything went well, you can check if the appropriate role was added to your user account in the [Users section](https://manage.auth0.com/#/users) of your Auth0 dashboard. Find the user you just logged in with and click the name to view details. This user's Metadata section should now look like this:

![user role admin](https://cdn.auth0.com/blog/mean-series/user-metadata.png "user role admin")

Finally you should change the `items.controller.ts` to use this new guard, by marking the method post with the decorator `@guard`:

```typescript
import {
  Get,
  Post,
  Body,
  Controller,
  UsePipes,
  UseGuards,
  ReflectMetadata,
} from '@nestjs/common';
import { CreateItemDto } from './create-item.dto';
import { ItemsService } from './items.service';
import { Item } from './item.interface';
import { ValidationPipe } from '../common/validation.pipe';
import { AdminGuard } from '../common/admin.guard';

@Controller('items')
export class ItemsController {
  constructor(private readonly itemsService: ItemsService) {}

  @Get()
  async findAll(): Promise<Item[]> {
    return this.itemsService.findAll();
  }

  @Post()
  @UseGuards(new AdminGuard())
  @UsePipes(new ValidationPipe())
  async create(@Body() createItemDto: CreateItemDto) {
    this.itemsService.create(createItemDto);
}
```

Recreate a token for the admin user and try to post an item right now, only admin users can do that:

```bash
curl \
-H 'Content-Type: application/json' \
-H 'authorization: Bearer ${TOKEN}'\
-d '{
  "name": "Salad",
  "price": 3
}' http://localhost:3000/items
```

Congratulations: now you have basic knowledges of Nest.js! You learned here what is a _module_, _controller_, _service_, _interface_, _pipe_, _middleware_ and _guard_! Now you can move on to the next article of the series or read more about Nest.js on its [documentation](https://docs.nestjs.com).