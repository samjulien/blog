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

Let start first by learning how to manipulate data in Redis using commands!

## Write, Read, Update, and Delete Data in Redis

As we learned earlier, Redis is a key-value store that let us put some data called a **value** into a **key**. We can later retrieve the stored data if we know the _exact_ key that was used to store it.

In case that you haven't done so already, run the Redis CLI in interactive mode by executing the following command:

```shell
redis-cli
```

We'll know the interactive CLI is working when we see the Redis instance host and port in the shell prompt:

```shell
127.0.0.1:6379>
```

Once there, we are ready to issue commands.

### Reading Data

To store a value in Redis, we can use the [`SET` command](https://redis.io/commands/set) which has the following signature:

```shell
SET key value
```

In English, it reads like "set key to hold value." It's important to note that if the key already holds a value, `SET` will overwrite it no matter what.

Let's look at an example. In the interactive shell type:

```shell
SET service "auth0"
```

> Notice how, as you type, the interactive shell suggests the required and optional arguments for the Redis command.

[IMG: Redis Shell Syntax Suggestion]

Press `enter` to send the command. Once Redis stores `"auth0"` as the value of `service`, it replies with `OK`, letting us know that everything went well. Thank you, Redis!

### Writing Data

We can use the [`GET` command](https://redis.io/commands/get) to ask Redis for the value of a key:

```shell
GET key
```

Let's retrieve the value of `service`:

```shell
GET service
```

Redis replies with `"auth0"`.

What if we ask for the value of a key that has never been set?

```shell
GET users
```

Redis replies with `(nil)` to let us know that the key doesn't exist in memory.

In a classic API that connects to a database, we'd like to perform [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations: create, read, update, and delete. We have covered how to create (write) and read data in Redis by using the `SET` and `GET` commands respectively. Let's cover the rest.

### Updating Data

We can update the value of a key simply by overwriting its data as mentioned earlier.

Lets create a new key-value pair:

```shell
SET framework angular
```

But, we change our mind and now we want the value to be `"react"`. We can overwrite it like this:

```shell
SET framework react
```

Did Redis get it right? Let's ask for it!

```shell
GET framework
```

Redis indeed replies with `"react"`. We are being a bit indecisive and now we want to set the `framework` key to hold the value of `"vue"`:

```shell
SET framework vue
```

If we run `GET framework` again, we get `"vue"`. The update/overwrite works as excepted.

### Deleting Data

But, we don't want to actually set any framework for now and we need to delete that key. How do we do it? We use the [`DEL` command](https://redis.io/commands/del):

```shell
DEL key
```

Let's run it:

```
DEL framework
```

Redis replies with `(integer) 1` to let us know the number of keys that were removed.

With just three commands, `SET`, `GET`, and `DEL`, we are able to comply with the four CRUD operations!

### Wrapping Strings with Quotation Marks

Notice something curious: we did not have to put quotation marks around a single string value we wanted to store. `SET framework angular` and `SET framework "angular"` are both accepted by Redis as an operation to store the string `"angular"` as the value of the key `framework`. 

Redis automatically wraps single string arguments in quotation marks. Since both key and value are strings, the same applies for the key name. We could have used `SET "framework" angular` and it would have worked as well. However, if we plan to use more than one string as the key or value, we do need to wrap the strings in quotation marks:

```shell
SET "the frameworks" "angular vue react"
```

Replies with `OK`.

```shell
SET the frameworks "angular vue react"
```

Replies with `(error) ERR syntax error`

```shell
SET "the frameworks" angular vue react
```

Also replies with `(error) ERR syntax error`

Finally, to retrieve the value, we must use the exact key string:

```shell
GET "the frameworks"
```

Replies with `"angular vue react"`.

### Non-Destructive Write

Redis is compassionate and lets us write data with care. Imagine that we wanted to create a `services` key to hold the value `"heroku aws"` but instead of typing `SET services "heroku aws"`, we typed `SET service "heroku aws"`. This last command would overwrite the current value of `service` without mercy. However, Redis gives us a non-destructive version of `SET` called [`SETNX`](https://redis.io/commands/setnx):

```shell
SETNX key value
```

`SETNX` creates a key in memory if and only if the key does not exist already (`SET` if `N`ot e`X`ists). If the key already exists, Redis replies with `0` to indicate a failure to store the key-value pair and with `1` to indicate success. Let's try out this previous scenario but using `SETNX` instead of `SET`:

```shell
SETNX service "heroku aws"
```

The reply is `(integer) 0` as we expected.

```shell
SETNX services "heroku aws"
```

This time, the reply is `(integer) 1`. Great!

We can use `SETNX` to prevent us from mutating data accidentally.

Now that we can perform basic data manipulation in Redis, let's learn how some commands are atomic.


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
