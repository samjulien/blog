## Aside: Securing Spring APIs with Auth0

Securing Spring Boot APIs with Auth0 is easy and brings a lot of great features to the table. With [Auth0](https://auth0.com/), we only have to write a few lines of code to get solid [identity management solution](https://auth0.com/user-management), [single sign-on](https://auth0.com/docs/sso/single-sign-on), support for [social identity providers (like Facebook, GitHub, Twitter, etc.)](https://auth0.com/docs/identityproviders), and support for [enterprise identity providers (like Active Directory, LDAP, SAML, custom, etc.)](https://auth0.com/enterprise).

In the following sections, we are going to learn how to use Auth0 to secure APIs written with [Spring Boot](https://spring.io/projects/spring-boot).

### Creating the API

First, we need to create an API on our <a href="https://auth0.com/signup" data-amp-replace="CLIENT_ID" data-amp-addparams="anonId=CLIENT_ID(cid-scope-cookie-fallback-name)">free Auth0 account</a>. To do that, we have to go to [the APIs section of the management dashboard](https://manage.auth0.com/#/apis) and click on "Create API". On the dialog that appears, we can name our API as "Contacts API" (the name isn't really important) and identify it as `https://contacts.blog-samples.com` (we will use this value later).

### Registering the Auth0 Dependency

The second step is to import a dependency called [`auth0-spring-security-api`](https://mvnrepository.com/artifact/com.auth0/auth0-spring-security-api). This can be done on a Maven project by including the following configuration to `pom.xml` ([it's not harder to do this on Gradle, Ivy, and so on](https://mvnrepository.com/artifact/com.auth0/auth0-spring-security-api)):

```xml
<project ...>
    <!-- everything else ... -->
    <dependencies>
        <!-- other dependencies ... -->
        <dependency>
            <groupId>com.auth0</groupId>
            <artifactId>auth0-spring-security-api</artifactId>
            <version>1.0.0-rc.3</version>
        </dependency>
    </dependencies>
</project>
```

### Integrating Auth0 with Spring Security

The third step consists of extending the [WebSecurityConfigurerAdapter](https://docs.spring.io/spring-security/site/docs/current/apidocs/org/springframework/security/config/annotation/web/configuration/WebSecurityConfigurerAdapter.html) class. In this extension, we use `JwtWebSecurityConfigurer` to integrate Auth0 and Spring Security:

```java
package com.auth0.samples.secure;

import com.auth0.spring.security.api.JwtWebSecurityConfigurer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Value(value = "${auth0.apiAudience}")
    private String apiAudience;
    @Value(value = "${auth0.issuer}")
    private String issuer;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        JwtWebSecurityConfigurer
                .forRS256(apiAudience, issuer)
                .configure(http)
                .cors().and().csrf().disable().authorizeRequests()
                .anyRequest().permitAll();
    }
}
```

As we don't want to hard code credentials in the code, we make `SecurityConfig` depend on two environment properties:

- `auth0.apiAudience`: This is the value that we set as the identifier of the API that we created at Auth0 (`https://contacts.blog-samples.com`).
- `auth0.issuer`: This is our domain at Auth0, including the HTTP protocol. For example: `https://blog-samples.auth0.com/`.

Let's set them in a properties file on our Spring application (e.g. `application.properties`):

```bash
auth0.issuer:https://blog-samples.auth0.com/
auth0.apiAudience:https://contacts.blog-samples.com/
```

### Securing Endpoints with Auth0

After integrating Auth0 and Spring Security, we can easily secure our endpoints with Spring Security annotations:

```java
package com.auth0.samples.secure;

import com.google.common.collect.Lists;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(value = "/contacts/")
public class ContactController {
    private static final List<Contact> contacts = Lists.newArrayList(
            Contact.builder().name("Bruno Krebs").phone("+5551987654321").build(),
            Contact.builder().name("John Doe").phone("+5551888884444").build()
    );

    @GetMapping
    public List<Contact> getContacts() {
        return contacts;
    }

    @PostMapping
    public void addContact(@RequestBody Contact contact) {
        contacts.add(contact);
    }
}
```

Now, to be able to interact with our endpoints, we will have to obtain an access token from Auth0. There are multiple ways to do this and [the strategy that we will use depends on the type of the client application we are developing](https://auth0.com/docs/api-auth/which-oauth-flow-to-use). For example, if we are developing a Single Page Application (SPA), we will use what is called the [_Implicit Grant_](https://auth0.com/docs/api-auth/tutorials/implicit-grant). If we are developing a mobile application, we will use the [_Authorization Code Grant Flow with PKCE_](https://auth0.com/docs/api-auth/tutorials/authorization-code-grant-pkce). There are other flows available at Auth0. However, for a simple test like this one, we can use our Auth0 dashboard to get one.

Therefore, we can head back to [the _APIs_ section in our Auth0 dashboard](https://manage.auth0.com/#/apis), click on the API we created before, and then click on the _Test_ section of this API. There, we will find a button called _Copy Token_. Let's click on this button to copy an access token to our clipboard.

![Copying a test token from the Auth0 dashboard.](https://cdn.auth0.com/blog/nodejs-hapijs-redis/getting-a-test-token-from-auth0-dashboard.png)

After copying this token, we can open a terminal and issue the following commands:

```bash
# create a variable with our token
ACCESS_TOKEN=<OUR_ACCESS_TOKEN>

# use this variable to fetch contacts
curl -H 'Authorization: Bearer '$ACCESS_TOKEN http://localhost:8080/contacts/
```

> **Note:** We will have to replace `<OUR_ACCESS_TOKEN>` with the token we copied from our dashboard.

As we are now using our access token on the requests we are sending to our API, we will manage to get the list of contacts again.

That's how we secure our Node.js backend API. Easy, right?
