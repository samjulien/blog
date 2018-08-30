## Aside: Securing Node.js Applications with Auth0

Securing Node.js applications with Auth0 is easy and brings a lot of great features to the table. With [Auth0](https://auth0.com/), we only have to write a few lines of code to get solid [identity management solution](https://auth0.com/user-management), [single sign-on](https://auth0.com/docs/sso/single-sign-on), support for [social identity providers (like Facebook, GitHub, Twitter, etc.)](https://auth0.com/docs/identityproviders), and support for [enterprise identity providers (like Active Directory, LDAP, SAML, custom, etc.)](https://auth0.com/enterprise).

In the following sections, we are going to learn how to use Auth0 to secure Node.js APIs written with [Express](https://expressjs.com/).

### Creating the Express API

Let's start by defining our Node.js API. With Express and Node.js, we can do this in two simple steps. The first one is to use [NPM](https://www.npmjs.com/) to install three dependencies: `npm i express body-parser cors`.

> **Note:** If we are starting from scratch, we will have to initialize an NPM project first: `npm init -y`. This will make NPM create a new project in the current directory. As such, before running this command, we have to create a new directory for our new project and move into it.

The second one is to create a Node.js script with the following code (we can call it `index.js`):

```javascript
// importing dependencies
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

// configuring Express
const app = express();
app.use(bodyParser.json());
app.use(cors());

// defining contacts array
const contacts = [
  { name: 'Bruno Krebs', phone: '+555133334444' },
  { name: 'John Doe', phone: '+191843243223' }
];

// defining endpoints to manipulate the array of contacts
app.get('/contacts', (req, res) => res.send(contacts));
app.post('/contacts', (req, res) => {
    contacts.push(req.body);
    res.send();
});

// starting Express
app.listen(3000, () => console.log('Example app listening on port 3000!'));
```

The code above creates the Express application and adds two middleware to it: `body-parser` to parse JSON requests, and `cors` to signal that the app accepts requests from any origin. The app also registers two endpoints on Express to deal with POST and GET requests. Both endpoints use the `contacts` array as some sort of in-memory database.

Now, we can run and test our application by issuing `node index` in the project root and then by submitting requests to it. For example, with [cURL](https://curl.haxx.se/), we can send a GET request by issuing `curl localhost:3000/contacts`. This command will output the items in the `contacts` array.

### Registering the API at Auth0

After creating our application, we can focus on securing it. Let's start by registering an API on Auth0 to represent our app. To do this, let's head to [the API section of our management dashboard](https://manage.auth0.com/#/apis) (we can create a <a href="https://auth0.com/signup" data-amp-replace="CLIENT_ID" data-amp-addparams="anonId=CLIENT_ID(cid-scope-cookie-fallback-name)">free account</a>) if needed) and click on "Create API". On the dialog that appears, we can name our API as "Contacts API" (the name isn't really important) and identify it as `https://contacts.blog-samples.com/` (we will use this value later).

### Securing Express with Auth0

Now that we have registered the API in our Auth0 account, let's secure the Express API with Auth0. Let's start by installing three dependencies with NPM: `npm i express-jwt jwks-rsa`. Then, let's create a file called `auth0.js` and use these dependencies:

```javascript
const jwt = require('express-jwt');
const jwksRsa = require('jwks-rsa');

module.exports = jwt({
  // Fetch the signing key based on the KID in the header and
  // the singing keys provided by the JWKS endpoint.
  secret: jwksRsa.expressJwtSecret({
    cache: true,
    rateLimit: true,
    jwksUri: `https://${process.env.AUTH0_DOMAIN}/.well-known/jwks.json`
  }),

  // Validate the audience and the issuer.
  audience: process.env.AUTH0_AUDIENCE,
  issuer: `https://${process.env.AUTH0_DOMAIN}/`,
  algorithms: ['RS256']
});
```

The goal of this script is to export an [Express middleware](http://expressjs.com/en/guide/using-middleware.html) that guarantees that requests have an `access_token` issued by a trust-worthy party, in this case Auth0. Note that this script expects to find two environment variables:

- `AUTH0_AUDIENCE`: the identifier of our API (`https://contacts.mycompany.com/`)
- `AUTH0_DOMAIN`: our domain at Auth0 (in my case `bk-samples.auth0.com`)

We will set these variable soon, but it is important to understand that the domain variable defines how the middleware finds the signing keys.

After creating this middleware, we can update our `index.js` file to import and use it:

```javascript
// ... other require statements ...
const auth0 = require('./auth0');

// ... app definition and contacts array ...

// redefining both endpoints
app.get('/contacts', auth0(), (req, res) => res.send(contacts));
app.post('/contacts', auth0(), (req, res) => {
  contacts.push(req.body);
  res.send();
});

// ... app.listen ...
```

In this case, we have replaced the previous definition of our endpoints to use the new middleware that enforces requests to be sent with valid access tokens.

Running the application now is slightly different, as we need to set the environment variables:

```bash
export AUTH0_DOMAIN=blog-samples.auth0.com
export AUTH0_AUDIENCE="https://contacts.blog-samples.com/"
node index
```

After running the API, we can test it to see if it is properly secured. So, let's open a terminal and issue the following command:

```bash
curl localhost:3000/contacts
```

If we set up everything together, we will get a response from the server saying that "no authorization token was found".

Now, to be able to interact with our endpoints again, we will have to obtain an access token from Auth0. There are multiple ways to do this and [the strategy that we will use depends on the type of the client application we are developing](https://auth0.com/docs/api-auth/which-oauth-flow-to-use). For example, if we are developing a Single Page Application (SPA), we will use what is called the [_Implicit Grant_](https://auth0.com/docs/api-auth/tutorials/implicit-grant). If we are developing mobile application, we will use the [_Authorization Code Grant Flow with PKCE_](https://auth0.com/docs/api-auth/tutorials/authorization-code-grant-pkce). There are other flows available at Auth0. However, for a simple test like this one, we can use our Auth0 dashboard to get one.

Therefore, we can head back to [the _APIs_ section in our Auth0 dashboard](https://manage.auth0.com/#/apis), click on the API we created before, and then click on the _Test_ section of this API. There, we will find a button called _Copy Token_. Let's click on this button to copy an access token to our clipboard.

![Copying a test token from the Auth0 dashboard.](https://cdn.auth0.com/blog/nodejs-hapijs-redis/getting-a-test-token-from-auth0-dashboard.png)

After copying this token, we can open a terminal an issue the following commands:

```bash
# create a variable with our token
ACCESS_TOKEN=<OUR_ACCESS_TOKEN>

# use this variable to fetch contacts
curl -H 'Authorization: Bearer '$ACCESS_TOKEN http://localhost:3000/contacts/
```

> **Note:** We will have to replace `<OUR_ACCESS_TOKEN>` with the token we copied from our dashboard.

As we are now using our access token on the requests we are sending to our API, we will manage to get the list of contacts again.

That's how we secure our Node.js backend API. Easy, right?
