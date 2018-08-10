---
layout: post
title: "TypeScript 3: Tuple Ware and Intro the Unknown"
description: ""
date: 2018-08-08 8:30
category: 
design: 
  bg_color: "#003A60"
  image: https://pbs.twimg.com/profile_images/743155381661143040/bynNY5dJ_400x400.jpg
author:
  name: Dan Arias
  url: http://twitter.com/getDanArias
  mail: dan.arias@auth.com
  avatar: https://pbs.twimg.com/profile_images/1002301567490449408/1-tPrAG__400x400.jpg
tags: 
  - 
related:
  - 
---

TypeScript 3.0 is out!

## TypeScript Quick Setup

If you want to follow along the example in this post, you can follow these quick steps to get a TypeScript 3.0 project up and running.

If you prefer to test Typescript 3.0 on a sandbox environment, you can use the [TypeScript playground](https://www.typescriptlang.org/play/) instead to follow along.

### Install Typescript

In order for TypeScript to work correctly with code editors and IDE's it's necessary to [install TypeScript globally](https://www.typescriptlang.org/index.html#download-links):

```shell
npm install -g typescript
```

This command will install the newest version of TypeScript in your system. To verify that the installation was successful, run the following command:

```shell
tsc --version
// Version 3.0.1
```

The version that comes up should be `3.0.0` or higher.

### Setting Up a TypeScript Project

In any directory of your choice, create a `ts3` directory and make it your current directory:

```shell
mkdir ts3
cd ts3
```

Once `ts3` is the current working directory, initalize a [Node.js](https://nodejs.org/) with default values:

```shell
npm init -y
```

Next, install core packages that are needed to compile and monitor changes in TypeScript files:

```shell
npm i typescript nodemon ts-node --save-dev
```

A TypeScript project needs a `tsconfig.json` file. Since `typescript` is installed locally this can be done through `npm` by using the `npx` command that is available in `npm >= 5.2`:

```shell
npx tsc --init
```

Here, npx executes the local `typescript` package that has been installed.

If you prefer to do so using the global package that is installed, you can run the following:

```shell
tsc --init
```

You will see the following message in the command line once's that done:

```shell
Successfully created a tsconfig.json file.
```

You will also have a `tsconfig.json` file with sensible started defaults enabled. For the scope of this tutorial, those configuration settings are more than enough.

### Compiling, Running, and Watching TypeScript

In a development world where everything build related is now automated, an easy way to compile, run, and watch TypeScript files is needed. This can be done through `nodemon` and `ts-node`:

- [`nodemon`](https://github.com/remy/nodemon): It's a tool that monitors for any changes in a Node.js application and automatically restart the server.

- [`ts-node`](https://github.com/TypeStrong/ts-node): It's a TypeScript execution and REPL for Node.js, with source map support. Works with `typescript@>=2.0`.

The executables of these two packages need to be run together through an `npm` script. In your code editor or IDE, update the `package.json` as follows:

```json
{
  "name": "ts3",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "watch": "npx nodemon --watch 'src/**/*.ts' --exec 'ts-node' src/index.ts"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "nodemon": "^1.18.3",
    "ts-node": "^7.0.0",
    "typescript": "^3.0.1"
  }
}
```

The `watch` script is doing a lot of hard work:

```shell
nodemon --watch 'src/**/*.ts' --exec 'ts-node' src/index.ts
```

The `nodemon` executable takes a `--watch`. The `--watch` option is followed by a string that specifed the directors that need to be watched and follows the [glob pattern](https://en.wikipedia.org/wiki/Glob_(programming).

Next, the `--exec` option is passed. The [`--exec`](https://github.com/remy/nodemon#running-non-node-scripts) option is used to run non-node scripts. `nodemon` will read the file extension of the script being run and monitor that extension instead of `.js`. In this case, `--exec` runs `ts-node`.

`ts-node` execute any passed TypeScript files as `node` + `tsc`. In this case, it receives and executes `src/index.ts`.

> In some other setups, two different shells may be used: One to compile and watch the TypeScript files and another one to run resultant JavaScript file through `node` or `nodemon`.

Finally, create a `src` folder under the project directory, `ts3`, and create `index.ts` within it.

### Running a TypeScript Project

With everything dependencies installed and scripts set up, you are ready to run the project. Execute the following command in the shell:

```shell
npm run watch
```

Messages about `nodemon` will come up. Since `index.ts` is empty as of now, there's no other output in the shell.

You are all set up! Now join me in exploring what new features come with TypeScript 3.

## TupleWare

### What Are Tuples?

TypeScript 3 comes with a couple of changes to how tuples can be used. Therefore, let's quickly review the [basics of TypeScript tuples].

A tuple is a TypeScript that let works like an array with a some special considerations:

- The number of elements of the array is fixed.
- The type of the elements of is known.
- The type of the elements of the array need not be the same.

For example, through a tuple, we can represent a value as a pair of a string and a boolean. Let's head to `index.ts` and populate it with the following code:

```typescript
// Declare the tuple
let option: [string, boolean];

// Correctly initialize it
option = ["uppercase", true];
```

If we change value of `option` to `[true, "uppercase"]`, we'll get an error:

```typescript
// Declare the tuple
let option: [string, boolean];

// Correctly initialize it
option = ["uppercase", true];

// Incorrect value order
option = [true, "uppercase"];
```

```shell
src/index.ts(8,11): error TS2322: Type 'true' is not assignable to type 'string'.
src/index.ts(8,17): error TS2322: Type 'string' is not assignable to type 'boolean'.
```

Let's delete the incorrect example from our code and move forward with the understanding that, with tuples, the order of values is critical. Relying on order can make code difficult to read, maintain, and use. For that reason, it's a good idea to use tuples with data that is related to each other in a sequential manner. That way, accessing the elements in order is part of a predictable and expect pattern.

The coordinates of a point are examples of data that is sequential. A three-dimensional coordinate always comes in a three-number pattern: `(x, y, z)`. On a cartesian plane, the order of the points will always be sequential. We could represent this three-dimensional coordinate as the following tuple:

```typescript
type Point3D = [number, number, number];
```

Therefore, `Point3D[0]`, `Point3D[1]`, and `Point3D[2]` would be logically digestable and easier to map than other disjointed data.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/typescript-3/coordinate-system.svg" alt="3D coordinate system">
</p>

[Source](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/3D_coordinate_system.svg/2000px-3D_coordinate_system.svg.png)

On the other hand, associated data that is loosely tied is not beneficial. For example, we could have three pieces of `customerData` that are `email`, `phoneNumber`, and `dateOfBirth`. `customerData[0]`, `customerData[1]`, and `customerData[2]` say nothing about what type of data each represents. We would need to trace the code or read documentation to find out how the data is being mapped. This is not an ideal scenario and using an `interface` would be much better.

That's it for tuples! They provide us with a fixed size container that can store all values of all kinds of types. Now, let's see what TypeScript changes about using tuples in version `3.0` of the language.

### Using TypeScript Tuples in Rest Parameters

In JavaScript, the [rest parameter](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters) syntax allows us to "represent an indefinite number of arguments as an array."

However as we reviewed earlier, in TypeScript, tuples are special arrays that can contain elements of different types.

With TypeScript 3, the rest paramater syntax allow us to represent a finite number of arguments of different types as a tuple. The rest parameter expands the elements of the tuple into discrete parameters.

Let's look at the following function signature as an example:

```typescript
declare function example(...args: [string, boolean, number]): void;
```

Here, the `args` parameter is a tuple type that contains three elemenets of type `string,`boolean`, and`number`. Using the rest parameter syntax, (`...`),`args` is expanded in a way that makes the function signature above equivalent to this one:

```typescript
declare function example(args_0: string, args_1: boolean, args_2: number): void;
```

To access `args_0`, `args_1`, and `args_2` within the body of a function we would use array notation: `args[0]`, args[1]`, and`args[2]`.

The goal of the rest parameter syntax is to collect "argument overflow" into a single structure: an array or a tuple.

In action, we could call the `example` function as follows:

```typescript
example("TypeScript example", true, 100);
```

TypeScript will pack that into the following tuple since `example`, as first defined, only takes one parameter:

```typescript
["TypeScript example", true, 100];
```

Then the rest parameter syntax unpacks it within the parameter list and makes it easily accessible to the body of the function based on array index notation with the same of the rest parameter as the name of the tuple, `args[0]`.

Using our `Point3D` tuple example, we could have a function like this one:

```typescript
declare function draw(...point3D: [number, number, number]): void;
```

As before, we would access each point coordinate as follows: `point3D[0]` for `x`, `point3D[1]` for `y`, and `point3D[2]` for `z`.

How is this different from just passing an array? An array would allow us to pass only one number, the first element of `point3D` that maps to the `x` coordinate. It would not force us to pass a number for `y` and `z`. A tuple will throw an error if we are not passing exactly 3 numbers to the `draw` function.

### Spread Expressions with TypeScript Tuples

The rest parameter syntax looks very familiar to the spread operator; however, they are very different. As we learned earlier, the rest parameter syntax collects parameter into a single variable and then expands them under its variable name. The spread operator expands the elements of an array or object. With TypeScript 3.0, the spread operator can also expand the elements of a tuple.

Let's see this in action using our `Point3D` tuple:

```typescript
type Point3D = [number, number, number];

const draw = (...point3D: Point3D) => {
  console.log(point3D);
};

const xyzCoordinate: Point3D = [10, 20, 10];

draw(10, 20, 10);
draw(xyzCoordinate[0], xyzCoordinate[1], xyzCoordinate[2]);
draw(...xyzCoordinate);
```

We create a `Point3D` to represent the `(10, 20, 10)` coordinate and store it in the `xyzCoordinate` constant. Notice that we have three ways to pass point to the `draw` function:

- Passing the values as literals:

```typescript
draw(10, 20, 10);
```

- Passing indexes to the corresponding `xyzCoordinate` tuple:

```typescript
draw(xyzCoordinate[0], xyzCoordinate[1], xyzCoordinate[2]);
```

- Using the spread operator to pass the full `xyzCoordinate` tuple:

```typescript
draw(...xyzCoordinate);
```

As we can see, using the spread operator is a fast and clean option to passing tuple as arguments.

### Optional Tuple Elements

With TypeScript 3.0, our tuples can have optional elements that are specified using the `?` postfix.

We could create a generic `Point` tuple that could become two or three-dimensional depending on how many tuple elements are specified:

```typescript
type Point = [number, number?, number?];

const x: Point = [10];
const xy: Point = [10, 20];
const xyz: Point = [10, 20, 10];
```

We could determine what kind of point is being represented by the constant by checking the `length` of the tuple:

```typescript
type Point = [number, number?, number?];

const x: Point = [10];
const xy: Point = [10, 20];
const xyz: Point = [10, 20, 10];

console.log(x.length);
console.log(xy.length);
console.log(xyz.length);
```

The code above outputs the following in the console:

```shell
1
2
3
```

Notice that the length of each `Point` tuples varies by the number of elements the tuple has. The `length` property of a tuple with optional elements is the "union of the numeric literal types representing the possible lengths" as states in the [TypeScript release](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-0.html).

The type of the length property in the `Point` tuple type [number, number?, number?] is `1 | 2 | 3`.

As a rule, if we need to list multiple optional elements, they have to be listed with the postfix `?` modifier on its type at the end of the tuple. An optional element cannot have required elements to its right but it can have as many optional elements as desired.

The following code would result in an error:

```
type Point = [number, number?, number];
```

```shell
error TS1257: A required element cannot follow an optional element.
```

In `--strictNullChecks mode`, using the `?` modifier automatically includes `undefined` in the tuple element type. This behavior is similar to what TypeScript does with optional parameters.

<p style="text-align: center;">
  <img src="https://cdn.auth0.com/blog/typescript-3/tupleware.png" alt="Tuples are like Tupperware containers.">
</p>

[Source](http://www.tupperware.com/media/catalog/product/cache/1/image/600x/9df78eab33525d08d6e5fb8d27136e95/l/u/lunchits_2018_mid_july-1.jpg)

> Tuples are like Tupperware containers that let you store different types of food on each container. We can collect and bundle the containers and we can disperse them. At the same time, we can make it optional to fill a container. However, it would be a good idea to keep the containers with uncertain content at the bottom of the stack to make the containers with guaranteed content both easy to find and predictable.

### Rest Elements In Tuple Types

In TypeScript 3.0, the last element of a tuple can be a rest element, `...element`. The one restriction for this rest element is that it has to be an array type. This structure is useful when we want to create open-ended tuples that may have zero or more additional elements. It's a boost over the optional `?` postfix as it allows us to specify a variable number of optional elements with the one condition that they have to be of the same type.

For example, `[string, ...number[]]` represents a tuple with a string element followed by any amount of `number` elements. This tuple could represent a student name followed by test scores:

```typescript
type TestScores = [string, ...number[]];

const thaliaTestScore = ["Thalia", ...[100, 98, 99, 100]];
const davidTestScore = ["David", ...[100, 98, 100]];

console.log(thaliaTestScore);
console.log(davidTestScore);
```

Output:

```shell
[ 'Thalia', 100, 98, 99, 100 ]
[ 'David', 100, 98, 100 ]
```

Don't forget to add the `...` operator to the `array`. Otherwise, the tuple could get the array as it second element and nothing else. The `array` elements won't spread out into the tuple:

```typescript
type TestScores = [string, ...number[]];

const thaliaTestScore = ["Thalia", ...[100, 98, 99, 100]];
const davidTestScore = ["David", ...[100, 98, 100]];

console.log(thaliaTestScore);
console.log(davidTestScore);
```

Output:

```shell
[ 'Thalia', [ 100, 98, 99, 100 ] ]
[ 'David', [ 100, 98, 100 ] ]
```
