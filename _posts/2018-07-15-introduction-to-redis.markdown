---
layout: post
title: "Introduction to Redis"
description: ""
longdescription: ""
date: 2018-07-18 8:30
category: Technical Guide, Architecture, Backend, Data
design: 
  bg_color: "#4E0F08"
  image: https://cdn.auth0.com/blog/logos/redis-icon-logo.png
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

{% include tweet_quote.html quote_text="Redis is a key-value store that let us store some data, the value, inside a key. It offers ultra-fast performance to satisfy demanding real-time applications like video games 🎮." %}

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

## Expiring Keys

When creating a key with Redis, we can specify how long that key should stay stored in memory. Using the [`EXPIRE`](https://redis.io/commands/expire) command, we can set a timeout on a key and have the key be automatically deleted once the timeout expires:

```shell
EXPIRE key seconds
```

Let's create a `notification` key that we want to delete after 30 seconds:

```
SET notification "Anomaly detected"
EXPIRE notification 30
```

This schedules the `notification` key to be deleted in 30 seconds. We could look at a clock and check after 30 seconds have elapsed if `notification` is still available but we don't have to do that! Redis offers the [`TTL`](https://redis.io/commands/ttl) command that tells us how many seconds a key has left before it expires and gets deleted:

```shell
TTL key
```

It's possible that more than 30 seconds have already passed so let's try the above example again, but this time calling `TTL` as soon as we execute `EXPIRE`:

```shell
SET notification "Anomaly detected"
EXPIRE notification 30
TTL notification
```

Redis replied with `(integer) 27` to me, indicating that `notification` is still available for 27 more seconds. Let's wait a bit and run `TTL` again:

```shell
TTL notification
```

This time, Redis replied with `(integer) -2`. Starting with Redis 2.8, `TTL` returns:

- The timeout left in seconds.
- `-2` if the key doesn't exist (either it has not been created or it was deleted).
- `-1` if the key exists but has no expiry set.

I made sure that 30 seconds had passed so `-2` was expected. Let's see the error message when the key exists but has no expiry set:

```
SET dialog "Continue?"
TTL dialog
```

As expected, with no expiry set, Redis replies with `(integer) -1`.

It's important to note that we can reset the timeout by using `SET` with the key again:

```
SET notification "Anomaly detected"
EXPIRE notification 30
TTL notification
// (integer) 27
SET notification "No anomaly detected"
TTL notification
// (integer) -1
```

We learned earlier that using `SET` is the same as creating the key again, which for Redis also involves resetting any timeouts currently assigned to it.

We have a solid foundation now on manipulating data in Redis. With this knowledge under our belt, we are ready to now explore the data types that Redis offers.

## Redis Data Types

Far from being a plain key-value store, Redis is an actual **data structure server** that supports different kinds of values. Traditionally, key-value stores allow us to map a string key to a string value and nothing else. In Redis, the string key can be mapped to more than just a simple string.

Being a data structure server, we can also refer to the data types as data structures. We can use these more complex data structures to store multiple values in a key at once. Let's look at these types at a high level. We'll explore each type in detail in subsequent sections.

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

For the scope of this post, we are going to focus on all the Redis types except bitmaps and hyperloglogs. We'll visit those on a future post handling an advanced Redis use case.

## Strings

## Lists

A list is a sequence of ordered elements. For example, `1 2 4 5 6 90 19 3` is a list of numbers. In Redis, it's important to note that lists are implemented as [linked lists](https://en.wikipedia.org/wiki/Linked_list). This has some important implications regarding performance. It is fast to add elements to the head and tail of the list but it's slower to search for elements within the list as we do not have indexed access to the elements (like we do in an array).

A list is created by using a Redis command that pushes data followed by a key name. There are two commands that we can use: `RPUSH` and `LPUSH`.

### RPUSH

[`RPUSH`](https://redis.io/commands/rpush) inserts a new element at the end of the list (at the tail):

```shell
RPUSH key value [value ...]
```

Let's create an `engineers` key that represents a list:

```shell
RPUSH engineers "Alice"
// 1
RPUSH engineers "Bob"
// 2
RPUSH engineers "Carmen"
// 3
```

Each time we insert an element, Redis replies with the length of the list after that insertion. We would expect the `users` list to resemble this: 

```shell
Alice Bob Carmen
```


How can we verify that? We can use the `LRANGE` command.

### LRANGE

`LRANGE` returns a subset of the list based on a specified start and stop index. Although these indexes are zero-based, they are no the same as array indexes. Given a full list, they simply indicate where to partition the list: make a slice from here (start) to here (stop):

```shell
LRANGE key start stop
```

To see the full list, we can use a neat trick: go from `0` to the element just before it, `-1`.

```shell
LRANGE engineers 0 -1
```

Redis returns:

```shell
1) "Alice"
2) "Bob"
3) "Carmen"
```

The index `-1` will always represent the last element in the list.

To get the first two elements of `engineers` we can issue the following command:

```shell
LRANGE engineers 0 1
```

### LPUSH

[`LPUSH`](https://redis.io/commands/lpush) behaves the same as `RPUSH` except that it inserts the element at the front of the list (at the header):

```shell
LPUSH key value [value ...]
```

Let's insert `Daniel` at the front of the `engineers` list:

```shell
LPUSH engineers "Daniel"
// 4
```

We now have four engineers. Let's verify that the order is correct:

```shell
LRANGE engineers 0 -1
```

Redis replies with:

```shell
1) "Daniel"
2) "Alice"
3) "Bob"
4) "Carmen"
```

It's the same list we had before but with `"Daniel"` as the first element, which is exactly what was expected.

### Multiple Element Insertions

We saw in the signatures of `RPUSH` and `LPUSH` that we can insert more than one element through each command. Let's see that in action.

Based on our existing `engineers` list, let's issue this command:

```shell
RPUSH engineers "Eve" "Francis" "Gary"
// 7
```

Since we are inserting them at the end of the list, we expect these three new elements to show up in the same order in which they are listed as arguments. Let's verify:

```shell
LRANGE engineers 0 -1
```

To what Redis returns:

```shell
1) "Daniel"
2) "Alice"
3) "Bob"
4) "Carmen"
5) "Eve"
6) "Francis"
7) "Gary"
```

What about if we do the same with `LPUSH`:

```shell
LPUSH engineers "Hugo" "Ivan" "Jess"
// 10
```

Will Redis insert these three new elements one by one or will it insert them as a bundle, all three at once?

Let's see:

```shell
LRANGE 0 -1
```

Reply:

```shell
 1) "Jess"
 2) "Ivan"
 3) "Hugo"
 4) "Daniel"
 5) "Alice"
 6) "Bob"
 7) "Carmen"
 8) "Eve"
 9) "Francis"
10) "Gary"
```

When listing multiple arguments for `LPUSH` and `RPUSH`, Redis inserts the elements one by one, thus, `"Hugo"`, `"Ivan"`, and `"Jess"` appear in the reverse order from which they were listed as arguments.

### LLEN

We can find the length of a list at any time by using the [`LLEN`](https://redis.io/commands/llen) command:

```shell
LLEN key
```

Let's verify that the length of `engineers` is indeed `10`:

```shell
LLEN engineers
```

Redis replies with `(integer) 10`. Perfect.

### Removing Elements from a Redis List

Similar to how we can "pop" elements in arrays, we can pop an element from the head or the tail of a Redis list.

[`LPOP`](https://redis.io/commands/lpop) removes and returns the first element of the list:

```shell
LPOP key
```

We can use it to remove `"Jess"`, the first element, from the list:

```shell
LPOP engineers
```

Redis indeed replies with `"Jess"` to indicate it is the element that was removed.

[`RPOP`](https://redis.io/commands/rpop) removes and returns the last element of the list:

```shell
RPOP key
```

It's time to say goodbye to `"Gary"`, the last element of the list:

```shell
RPOP engineers
```

The reply from Redis is `"Gary"`.

It's very useful to be able to get the element that was removed from the list as we may want to do something special with it.

Redis lists are implemented as linked lists because its engineering team envisioned that for a database system [it is crucial to be able to add elements to a very long list in a very fast way](https://redis.io/topics/data-types-intro).

## Sets

## Ordered Sets

## Hashes

## Using Redis Session Storage

## Auth0 Aside
