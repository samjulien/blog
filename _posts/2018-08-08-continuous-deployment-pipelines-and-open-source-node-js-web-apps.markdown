---
layout: post
title: "Continuous Deployment Pipelines and Open-Source Node.js Web Apps"
description: "Learn how to configure a Continuous Deployment pipeline for your open-source Node.js web applications."
date: 2018-07-25 08:30
category: Technical Guide, Backend
author:
  name: "Idorenyin Obong"
  url: "https://twitter.com/kingidee/"
  mail: "idee4ril@gmail.com"
  avatar: "https://cdn.auth0.com/blog/guest-author/idorenyin-obong.jpg"
design:
  bg_color: "#333333"
  image: https://cdn.auth0.com/blog/logos/node.png
tags:
- continuous-deployment
- node-js
- open-source
- web-app
related:
- 2018-06-07-developing-well-organized-apis-with-nodejs-joi-and-mongo
- 2018-06-13-vue-js-and-lambda-developing-production-ready-apps-part-1
---

**TL;DR:** In this article, you will learn how to configure a Continuous Deployment pipeline for your open-source Node.js web apps. For demonstration purposes, you will use Now.sh, GitHub, and TravisCI to automate the pipeline. However, the strategy can actually be used with other programming languages (e.g. Python, Java, and .NET Core) and tools (like BitBucket, AWS, and CircleCI).

## Continuous Deployment Overview

[Continuous Deployment](https://www.scaledagileframework.com/continuous-deployment/) (popularly known as CD) is a modern software engineering approach that has to do with automating the release of software. Instead of the usual manual method of pushing out a software to production, Continuous Deployment aims to ease and automate this process with the use of pipelines. In Continuous Deployment, an update to the source code means an update to the production server too if all tests are passed. Continuous Deployment is often mistaken with Continuous Integration and Continuous Delivery. For you to properly get a hang of this concept, let us distinguish the other two concepts.

In [Continuous Integration (CI)](https://www.atlassian.com/continuous-delivery/continuous-integration-intro), when a new code is checked in, a build is generated and tested. The aim is to test every new code to be sure that it doesn’t break the software as a whole. This will require writing test for every update that is pushed. The importance of CI is to ensure a stable codebase at all times, especially when there are multiple developers in a team. With this, bugs are discovered more rapidly when the automated tests fail.

[Continuous Delivery](https://aws.amazon.com/devops/continuous-delivery/) moves a step ahead of Continuous Integration. After testing, the release process is also automated. The aim is to generate a releasable build (i.e. a build that is stable enough to go into production). This helps to reduce the hassle of preparing for release. In Continuous Delivery, since there are regular releases, there is also a faster feedback.

The major difference between Continuous Delivery and Continuous Deployment is the way releases are done. One is manual, while the other is automated. With Continuous Delivery, your software is always at a state where it can be pushed out to production manually. Whereas, with Continuous Deployment, any stable working version of the software is pushed to production immediately. Continuous Deployment needs Continuous Delivery, but the reverse is not applicable.

In all of these, you need a repository where your code will reside and a Continuous Integration server to monitor the repository where the code is checked into. When the server notices an update in the code, it triggers the pipeline. A pipeline in this context is a script/file that contains commands and tasks to be executed on the project. When typically setting up your Continuous Integration server, you setup your pipeline alongside it. Some common Continuous Integration servers include [Travis CI](https://travis-ci.org/), [Jenkins](https://jenkins.io/), [TeamCity](https://www.jetbrains.com/teamcity/), etc.

In this post, you will learn how to setup a Continuous Integration server together with a GitHub repository to show Continuous Deployments in practice. Continuous Deployments are important for the following reasons: better integration for large teams, faster and easier releases, faster feedback, increased development productivity as a whole, etc.

## Preparing an Open-Source Node.js Web App for Continuous Deployment

In this section, you will build a simple hello-world app with Node.js. As such, first you will need to ensure that you have Node.js installed on your machine before moving ahead.

```bash
node --version
```

Running the command above should make your terminal print something similar to `v9.11.1`. If you get a message saying that `node` was not found, please, follow this [link](https://nodejs.org/en/download/) to install Node.js and NPM.

### Scaffolding a Node.js Web App

Now that you have Node.js properly installed in your machine, you will setup the structure of your Node.js application. For easy setup, you will run `npm init -y` in a new directory (this will be your project root). This command will generate for you a `package.json` file for that will have the details of your Node.js app. The `package.json` file contains basic information about your app coupled with the name of the dependencies used.

To create you project and the `package.json` file, go to your terminal and execute the following commands:

```bash
# create the project root
mkdir node-cd

# move into the project root
cd node-cd

# start it as a NPM project
npm init -y
```

After running the last command, NPM will generate the `package.json` file for you. Now, if you open the directory for your app, you will see that the `package.json` file contains the following contents:

```json
{
  "name": "node-cd",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
```

### Installing the Node.js Web App Dependencies

After creating the `package.json` file, you will need to install the dependencies needed to build your project. For this article, you will need only two dependencies: [`express`](https://github.com/expressjs/express) and [`body-parser`](https://github.com/expressjs/body-parser). You can install all these dependencies at once by running this command:

```bash
npm install express body-parser --save
```

Once the installation is complete you should see a `node_modules` folder. Additionally, your `package.json` file will contain the dependencies installed and their versions.

### Creating a Web Page on Node.js

During the setup of the app, NPM declared the `index.js` file as the entry point of the app. Now, you need to create this file. So, still in the project root, run the following command to create it:

```bash
touch index.js
```

Next, you will have to create an HTML file. Usually, it is a good practice to create a directory for your views. As such, you will create the directory and the HTML file by running the following commands from the project root:
 
```bash
# create a directory for your views
mkdir pages

# create your first view
touch pages/index.html
```

Now, to make your Node.js web app serve the HTML file, you will open the `index.js` file and set it up like so: 

```javascript
// import dependencies
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
    
// initialise express
const app = express();
    
// root endpoint
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname + '/pages/index.html'));
});
    
// select the port in which your Node.js web app will run
const port = 5000;
    
// then listen to the selected port
app.listen(port, () => console.log(`Server is running on port ${port}`));
```    

This snippet contains all the server logic required for this app. As you can see, just one endpoint is declared (i.e. the one that loads the `index.html` page). Also, as defined in the code above, the app will run on port `5000`.

Now, to add some content to your `index.html` file, open this file and insert the following code:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Title Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.3/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
</head>
<body>
  <h1 class="text-center">Hello World</h1>  
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</body>
</html>
```

This is a basic HTML code with [Bootstrap (a library that helps building beautiful web apps)](https://getbootstrap.com/) and [jQuery (a JavaScript library needed by Bootstrap)](https://jquery.com/) referenced via CDN (Content Delivery Network). The web page contains a **hello world** text in a `h1` tag to make the text a heading. You can run your server now with this command: 

```bash
node index.js
```

Now, if you visit [`http://localhost:5000`](http://localhost:5000), you should see something like this:

![Node.js web app showing a hello-world page.](https://cdn.auth0.com/blog/continuous-deployment/hello-world-node-js-web-app.png)

That's it! For the purposes of this article, the current project will be enough. Now, you will need to submit your project to a version control system.

## GitHub and Open-Source Web Apps

Earlier in this article, I mentioned the need for repository to demonstrate Continuous Deployment in action. A repository in this case is simply a place where source code is stored. As such, you will need to store your project's source code on a remote (online) repository.

[Git](https://git-scm.com/) is the most popular and one of the most advanced [version control systems](https://en.wikipedia.org/wiki/Version_control) out there. Therefore, a service that can host a Git repository is what you should choose. There are many available out there but we will use the most popular of them, GitHub. [GitHub](https://www.github.com) is a web service where Git repositories are hosted. Actually, they offer more than this and you can read more about [GitHub's features here](https://github.com/features).

### Creating a GitHub Account

If you don’t have an account with GitHub, visit the [website](https://www.github.com) and create a new one. If you do have an account, make sure you are logged in to your profile. Creating an account requires a unique username, email with any password of your choice. 

![Creating a GitHub account](https://cdn.auth0.com/blog/continuous-deployment/creating-a-github-account.png)

After registration, you will be required to verify your account through your email address to gain full access.

### Creating a GitHub Repository

GitHub is free for public repositories (i.e. for open-source projects), which is just what you need for this article. To create a new repository, open your profile, click the plus button, and select _New repository_. Your profile should look like this:

![GitHub profile and "New Repository" button](https://cdn.auth0.com/blog/continuous-deployment/github-profile.png)

After click on the _New repository_ option, you will be presented with a form like this:

![Creating a new GitHub repository](https://cdn.auth0.com/blog/continuous-deployment/creating-new-github-repo.png)

Fill the form with a name of your repository (e.g. `node-js-cd-pipeline`) and a description (e.g. "Node.js & Continuous Deployment") then hit the _Create repository_ button. When GitHub finishes creating your repository, you will be redirected to it. There, you will be able to copy the repository's `URL` (it must be similar to `https://github.com/KingIdee/node-js-cd-pipeline.git`). Copy it to your clipboard as you will need it soon.

> **Note:** If you have perviously [configured you GitHub account with an SSH key](https://help.github.com/articles/connecting-to-github-with-ssh/), you may be able to copy and use the other URL format. This format is similar to: `git@github.com:KingIdee/node-js-cd-pipeline.git`.

### Pushing your Open-Source Node.js Web App to GitHub

Haven setup your Node.js web app and created a GitHub repository for it, it is time to push your source code online. So, from your project root, run the following command:

```bash
git init
```

> **Note:** [You will need to install the Git CLI (Command Line Interface) to execute `git` commands](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

This command initialises Git in the project directory by creating a `.git` folder (on most operational systems, this directory is invisible by default). After initiliasing Git, you will have to set up your GitHub repository as a remote:

```bash
git remote add origin REPO_URL
```
> Make sure you replace `REPO_URL` with the repository URL you copied earlier.

Sometimes, there are particular files that you need to ignore when pushing a project to your remote repository. For this project (and most Node.js projects), you will need to ignore the `node_modules` directory. Therefore, create a `.gitignore` file in the directory like so:

```bash
touch .gitignore
```

Then, open the file and paste this line:

```bash
/node_modules
```

Next, you need to commit the changes made to the project and push to your remote repository. You can do so by running the following commands:

```bash
# add changed files
git add -A

# commit them to Git
git commit -m "first commit"

# push them to GitHub
git push -u origin master
```

The first command (`git add`) adds all files affected by changes to Git, except the ones explicitly listed in the `.gitignore` file. Then, the second command (`git commit`) adds a message to the added/changed files to note what changes occurred and save them in your local Git repository. Lastly, the `git push` command pushes the local changes made to the project to the remote repository (GitHub in this case) and sets up the local project to track remote changes.

If everything works fine, you should see the source code of your project online when you visit the repository you created.

![Pushing changes to the GitHub remote repository.](https://cdn.auth0.com/blog/continuous-deployment/pushing-changes-to-the-github-remote-repo.png)

## Now.sh and Open-Source Apps

[Now](http://now.sh) is a Platform as a Service (PaaS) which allows you deploy your Node.js (or Docker) powered projects to the cloud with ease. Now aims to make Continuous Deployments easier for developers. Naturally, deploying websites built with Node.js require a sound knowledge of server configurations and management together with a good command of the terminal. With Now, you can focus more on your app logic and worry less about deployments.

Some of the amazing features of Now include:

- Free unique URL: for every deployment made, there is a unique `URL` generated usually in the form `<appname>-<random string>.now.sh` (e.g `helloworld-hddnhdvhsd.now.sh`).
- Process logging: every process from the point of running the command to the point of starting the server for the deployed app is logged on the screen and can be viewed by clicking on any of the deployment instance link found on your dashboard.
- SSL certificate management - Now uses [Let's Encrypt](https://letsencrypt.org/) to provide your deployments with SSL at no cost. Etc.

What is even more awesome is that Now allows you to deploy lightweight open-source applications on their infrastructure without paying a dime. [The code, in that case, is open for anyone who is curious about the project](https://zeit.co/blog/now-public). However, since you are developing an open-source app, this shouldn't be a problem. Also, environment variables (for example credentials to connect to a database) are not shared with the public as they are not part of the source code itself.

### Creating a Now.sh Account

To create a Now.sh account, go to [the sign up page of Now](https://zeit.co/signup) and choose one of the methods available (i.e. through email or through your GitHub account). If you choose to sign up through email, you will get a message with a magic link that you can click to verify your account. After that, the browser tab that you used to sign up will be reloaded with your Now dashboard.

Besides that, if you chose the _Signup with GitHub_ option, a verification mail will be sent to your email address.

After verifying your email, you will be able [login to Now](https://zeit.co/login). If you are a new user, after logging in, your dashboard should look like this:

![Signing up to Now.sh](https://cdn.auth0.com/blog/continuous-deployment/signing-up-to-now.png)

### Obtaining a Now Token

Once the registration process is complete and you are logged in, [click on your profile picture on the top-right corner and then click on your email address](https://zeit.co/account) (it will appear under the _Settings_ option). After that, Now will show your account settings and, below you profile picture, [you will see a link to _Tokens_](https://zeit.co/account/tokens). Click on it.

In this next screen, you will see a section called _Authorized Apps_ and an input field where you will be able to create a new token. In this field, insert a descriptive name like _Continuous Deployment_ and hit the `Enter`. After that, Now will generate a new Token for you.

For the time being, leave this page open. Soon, you will need to copy this token.

## Introducing Travis CI

[Travis CI](https://travis-ci.org/) is a continuous integration server. CI servers are used to monitor repositories when there is a change and trigger a pre-configured process on the repository. Travis CI particularly supports only projects on GitHub. The project is usually configured by adding a pipeline file named -  `.travis.yml` file to the root directory of the repository.  

### Creating a Travis Account

To move ahead, you have to signup on [Travis CI](https://travis-ci.org/). Travis CI requires only GitHub signup. Since you 
have a GitHub account, open the website and signup.

### Configuring Travis CI for your GitHub Repo

After a successful signup, you can see a list of your public repositories on your profile [here](https://travis-ci.org/) while your private repositories are found [here](http://travis-ci.com.). Travis stores public and private repos in separate domains. Go to your public repository list. It should look like this


![](https://d2mxuefqeaa7sj.cloudfront.net/s_256435711D8498B15897840D6DBA9A5C15B103EC205218F06CA3BF9F3DF56283_1532392825500_Screen+Shot+2018-07-24+at+1.39.51+AM.png)


Select the repository you created earlier and activate it. 


![](https://d2mxuefqeaa7sj.cloudfront.net/s_256435711D8498B15897840D6DBA9A5C15B103EC205218F06CA3BF9F3DF56283_1532393198638_Screen+Shot+2018-07-24+at+1.45.28+AM.png)


### Configuring Travis in your Application

Go back to the project folder, create a `.travis.yml` file and paste the following code:

```
language: node_js
node_js:
- node
cache:
  directories:
  - node_modules
before_deploy: npm install now --no-save # installs now cli
deploy:
- provider: script
  # deploys the application to now.sh if all tests pass
  script: now --public --token $NOW_TOKEN && now alias --token $NOW_TOKEN
  skip_cleanup: true
  on:
    master: true
- provider: script
# starts the node server with the entry point script server.js
  script: npm run server
  skip_cleanup: true
```


In `language:` the technology used for the app is specified, in this case -  Node.js. The `before_deploy:` section specifies the command to be executed before deployment. Here, the Now CLI is installed. The first `script:` in the `deploy` section deploys the project to Now.sh using Now CLI, the `on:` tells Travis which branch to work with and the second `script` starts the node application.

Next, open your `package.json` file too and add this in the file:
 
```json
{
 [...]
 "scripts": {
   "start": "npm run server",
   "server": "node index.js"
  }
 }
```
 
The `npm run server` which was defined in `.travis.yml` didn’t exist in `package.json` file until you just added it now.  

### Securing Now.sh token with Travis CLI

Security is important when deploying your application as secret keys may be involved. For instance, in your case, the now token is a secret key. Setting the keys as environment variables in Travis CI may seem as the run to approach. Unfortunately, this is not entirely secure. To secure your keys properly, you will need to use the Travis Command Line Interface. To use this, you need to install  ruby and `gem` on your machine. Follow this [documentation](https://github.com/rubygems/rubygems#installation) to achieve that. After you have done that, you can now install Travis CLI using this command:

```
gem install travis
```

Congrats! You now have Travis CLI installed. You can now encrypt your `now token` by running this command in your project directory:

```
travis encrypt NOW_TOKEN=YOUR_TOKEN --add
```

> Replace YOUR_TOKEN with the token with the token you copied from your Now.sh dashboard.


This snippet encrypts `YOUR_TOKEN` and adds the encoded version to `.travis.yml` file under  the`.env` section. If the above command is successful you should see some configurations appear on `.travis.yml` file as shown below:

```
env:
    global:
    secure: DZC4XpjVPoPl4oXKPD2QATP4++vbPUXllQW0XZaUnSp4S/U9zQamciEMPjvwot324CC/nWm8eL5EyY4WIEyhvhbWwtl85GIYJJeSVhJbkOcwX9Z8Z95aE+9ajI0INNgE9xS0f7jHYqUOSGTDz0aagGrl8ZgA/qI7qL7QZKLgX07e3nh5Zgyjtrgvyukhchtyiuhoetryuiozb4EoUUc8LJAZJPXBcok/qAmuxPQe6vZt5OTmhNPeL0efdRt861dql45A2qHKOGREYm3Ma0aV1IuqeCLrmoJkT5u7oGd+pG+OWh7LlgA1bjFbTufT/2YiGqCKDNLwbsX8OzCqOluOSnm8Rb32Yr6VJIw/ulVweg+ZRsEIdNaY=
``` 

The key generated above will be used for deploying your application to Now.

## Testing the Continuous Deployment Pipeline

To test your deployment pipeline all you need to do is add or change files, commit and push to your remote repository which you created in the course of this tutorial.

### Pushing Your First Change

Change the text in your `index.html` file to something like - **Hello World! Watch this space.** Commit your changes and push to GitHub by running the following commands individually:

```bash
git add -A
    
git commit -m "configured deployment pipeline with travis"
    
git push
```

Once the changes has been pushed to your repository a deployment process is triggered and Travis CI takes over the build process. It handles this process based on the configurations in `.travis.yml` file which you created in your root directory. As this process is going on you should see the log on your Travis dashboard.

Once the build is completed, visit your Now dashboard you should see the current deployment instance created with a unique URL which you can visit to view your deployed application on the browser.

### Pushing Your Second Change

Next, you can make more changes to your `index.html` file, commit  the changes and push again. Watch your changes go live in minutes. 

```bash
git add -A
    
git commit -m "made adjustment to index.html files"
    
git push
```


Once again visit your Now dashboard you should see the current deployment instance created with a unique URL which you can visit to view your deployed application on the browser. The deployment instances are displayed as shown below:

![](https://d2mxuefqeaa7sj.cloudfront.net/s_256435711D8498B15897840D6DBA9A5C15B103EC205218F06CA3BF9F3DF56283_1532681757775_Screen+Shot+2018-07-27+at+9.55.14+AM.png)


## Conclusion

In this article you have learnt about one of the buzzing terms in modern software development - Continuous Deployments. You learnt about git hosting web services, CI servers, a PaaS, and their respective duties in Continuous Deployments. Particularly, you used tools like GitHub, Travis CI, and Now.sh. You even went ahead to create a Node.js app and deploy by yourself. Isn’t that awesome? 

With this knowledge, you can go ahead and apply continuous integration to your much more complex projects. You can even decide to try tools similar to what is used here, like trying a different CI server, or a new git hosting web service. I look forward to seeing what you will build. Cheers!