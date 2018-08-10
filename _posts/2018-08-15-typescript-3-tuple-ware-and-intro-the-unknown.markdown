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
