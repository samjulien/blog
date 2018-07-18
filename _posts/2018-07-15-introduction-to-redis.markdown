---
layout: post
title: "Introduction to Redis"
description: ""
longdescription: ""
date: 2018-07-18 8:30
category: Technical Guide, Architecture, Backend, Data
design: 
  bg_color: "#1A1A1A"
  image: 
author:
  name: Dan Arias
  url: http://twitter.com/getDanArias
  mail: dan.arias@auth.com
  avatar: https://pbs.twimg.com/profile_images/1002301567490449408/1-tPrAG__400x400.jpg
tags: 
  - redis
  - database
  - store
  - introduction
  - quickstart
  - backend
  - data
  - architecture
  - caching
  - session-storage
  - authentication
related:
  - 
---

## What's Redis?

Redis is an in-memory key-value store that can be used as a database, cache, and message broker. The project is [open source](https://github.com/antirez/redis) and it's currently licensed under the [BSD license](https://github.com/antirez/redis/blob/unstable/COPYING).

[Redis delivers sub-millisecond response times](https://aws.amazon.com/redis/) that enable millions of requests per second to power demanding real-time applications such as games, ad brokers, financial dashboards, and many more!

It supports basic data structures such as strings, lists, sets, sorted sets with range queries, and hashes. More advanced data structures like bitmaps, hyperloglogs, and geospatial indexes with radius queries are also supported.

At Auth0, our Site Reliability Engineering (SRE) Team uses Redis for caching:

[Verlic Quote Pending Insight from Yenkel]

In this blog post, let's explore the basic data structures that come with Redis.

## Installing Redis

The first thing that we need to do is install Redis. If you have it already running in your system, feel free to skip this part of the post.

The [Redis documentation](https://redis.io/topics/quickstart#installing-redis) recommends installing Redis by compiling it from sources as Redis has no dependencies other than a working `GCC compiler` and `libc`. We can either download the latest Redis tarball from [`redis.io`](https://redis.io/), or we can use a special URL that always points to the latest stable Redis version: [`http://download.redis.io/redis-stable.tar.gz`](http://download.redis.io/redis-stable.tar.gz).

> **Windows users**: The Redis project does not officially support Windows. But, if you are running Windows 10, you can [Install the Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to install and run Redis. When you have the Windows Subsystem for Linux up and running, please follow any steps in this post that apply to Linux (when specified) from within your Linux shell.

To compile Redis follow these simple steps:

- Create a `redis` directory and make it the current working directory:

OSX/Linux:

```shell
mkdir redis && cd redis
```

- Fetch the latest redis tarball:

OSX:

```shell
curl -O http://download.redis.io/redis-stable.tar.gz
```

Linux:

```shell
wget http://download.redis.io/redis-stable.tar.gz
```

- Unpack the tarball:

OSX/Linux:

```shell
tar xvzf redis-stable.tar.gz
```

- Make the unpacked `redis-stable` directory the current working directory:

OSX/Linux:

```shell
cd redis-stable
```

- Compile Redis:

OSX/Linux:

```shell
make
```

> If the `make` package is not installed in your system, please follow the instructions provided by the CLI to install it. For a fresh installation of Ubuntu, for example, you may want to run the following commands to update the package manager and install core packages:

Ubuntu:

```shell
sudo apt update
sudo apt upgrade
sudo apt install build-essential
sudo apt-get install tcl8.5
make
```

`tcl` 8.5 or newer is needed to run the Redis test in the next step.

- Test that the build works correctly:

OSX/Linux:

```shell
make test
```

Once the compilation is done, the `src` directory within `redis-stable` is populated with different executables that are part of Redis. The Redis docs explain the [functionality of each Redis exectuble](https://redis.io/topics/quickstart):

- `redis-server`: runs the Redis Server itself.
- `redis-sentinel`: runs [Redis Sentinel](https://redis.io/topics/sentinel), a tool for monitoring and failover.
- `redis-cli`: runs a [command line interface](https://en.wikipedia.org/wiki/Command-line_interface) utility to interact with Redis.
- `redis-benchmark`: checks Redis performance.
- `redis-check-aof` and `redis-check-dump`: used for the rare cases when there are corrupted data files.

We are going to be using the `redis-server` and `redis-cli` executable frequently. For convenience, let's copy both to a location that will let us access them system-wide. This can be done manually by running:

OSX/Linux:

```shell
sudo cp src/redis-server /usr/local/bin/
sudo cp src/redis-cli /usr/local/bin/
```

While having `redis-stable` as the current working directory, this can also be done automatically by running the following command:

OSX/Linux:

```shell
 sudo make install
```

We need to restart our shell for these changes to take effect. Once we do that, we are ready to start running Redis.

## Running Redis

### Starting Redis

The easiest way to start the Redis server is by running the `redis-server` command. In a fresh shell window, type:

```shell
redis-server
```

If everything is working as expected, the shell will receive as outline a giant ASCII Redis logo that shows the Redis version installed, the running mode, the `port` where the server is running and it's `PID` ([process identification number](http://www.linfo.org/pid.html)).

````shell
                _._
           _.-``__ ''-._
      _.-``    `.  `_.  ''-._           Redis 4.0.10 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 22394
  `-._    `-._  `-./  _.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |           http://redis.io
  `-._    `-._`-.__.-'_.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |
  `-._    `-._`-.__.-'_.-'    _.-'
      `-._    `-.__.-'    _.-'
          `-._        _.-'
              `-.__.-'
````

We started Redis without any explicit configuration file; therefore, we'll be using the internal default configuration. This is acceptable for the scope of this blog post: understanding and using the basic Redis data structures.

As a first step, we always need to get the Redis server running as the CLI and other services depend on it to work.

### How to Check if Redis is Working

As noted in the Redis docs, external programs talk to Redis using a [TCP socket and a Redis specific protocol](https://redis.io/topics/quickstart#check-if-redis-is-working). The Redis protocol is implemented by Redis client libraries written in many programming languages, like JavaScript. But we don't need to use a client library directly to interact with Redis. We can use the `redis-cli` to send a command to it directly. To test that Redis is working properly, let's send it the `ping` command. Open a new shell window and execute the following command:

```shell
redis-cli ping
```

If everything is working well, we should get `PONG` as a reply in the shell.

When we issued `redis-cli ping`, we invoked the `redis-cli` executable follow by a command name, `ping`. A command name and its arguments are sent to the Redis instance running on `localhost:6379` for it to be processed and send a reply.

The host and port of the instance can be changed. Use the `--help` option to check all the commands that can be used with `redis-cli`:

```shell
redis-cli --help
```

If we run `redis-cli` without any arguments, the program will start in interactive mode. Similar to the [Read–Eval–Print Loop (REPL)](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) of programming languages like Python, we can type different Redis commands in the shell and get a reply from the Redis instance. What those commands are and what they do is the core learning objective of this post!

Let's start first by learning about the data types present in Redis. After that, we'll start learning some commands that allow us to interact with basic data structures.

## Redis Data Types

Far from being a plain key-value store, Redis is an actual **data structure server** that supports different kinds of values. Traditionally, key-value stores allow us to map a string key to a string value and nothing else. In Redis, the string key can be mapped to more than just a simple string. A varied range of complex data structures can become the value of a string key. Let's look at these types at a high level. We'll explore each type in detail in subsequent sections.

- **Binary-safe strings**

The most basic kind of Redis value. Being "binary-safe" means that the string can contain any type of data represented as a string: PNG images or serialized objects, for example.

- **Lists**

In essence, Redis lists are linked lists. They are collections of string elements that are sorted based on the order that they were inserted.

- **Sets**

They represent collections of unique and unsorted string elements.

- **Sorted sets**

Like sets, they represent a collection of unique string elements; however, each string element is linked to a floating number value, referred to as the element **score**. When querying the sorted set, the elements are always taken sorted by their score, which enables us to consistently present a range of data from the set.

- **Hashes**

These are maps made up of string fields linked to string values.

- **Bit arrays**

Also known as bitmaps. They let us handle string values as if they were an array of bits.

- **HyperLogLogs**

A probabilistic data structure used to estimate the cardinality of a set.

For the scope of this post, we are going to focus on all the Redis types except bitmaps and hyperloglogs that we'll be visiting on a future post handling an advanced Redis use case. Being a data structure server, we can also refer to the data types as data structures.

## Strings

## Lists

## Sets

## Ordered Sets

## Hashes

## Using Redis Session Storage

## Auth0 Aside
