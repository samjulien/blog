---
layout: post
title: "Laravel 5.7 Release: What's New? 10 Features To Try"
description: "Laravel 5.7 has just been released! What's new? What improvements were made? Learn how to build better PHP applications with this new release."
metadescription: "PHP framework Laravel 5.7 release. Learn about new Symfony integrations, filesystem methods, improved Artisan Commands testing, Multilingual support, and more."
date: 2018-09-06 08:30
category: Technical Guide, Whats New, Laravel
design:
  bg_color: "#4A4A4A"
  image: https://cdn.auth0.com/blog/logos/laravel.png
author:
  name: Prosper Otemuyiwa
  url: http://twitter.com/unicodeveloper
  mail: prosper.otemuyiwa@auth0.com
  avatar: https://en.gravatar.com/avatar/1097492785caf9ffeebffeb624202d8f?s=200
tags:
- laravel
- web-app
- php
- api
- laravel-57
- open-source
related:
- 2016-06-23-creating-your-first-laravel-app-and-adding-authentication
- 2017-12-26-developing-restful-apis-with-lumen
- 2017-02-21-laravel-5-6-release-what-is-new
---

**TL;DR:** **Laravel 5.7** is a major release to, at time of writing, the most popular PHP framework on GitHub. Furthermore, [Laravel Nova](https://nova.laravel.com) was also released. In this article, I'll cover the new features in Laravel 5.7 and several other changes and deprecations.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">🎊 Laravel 5.7.0 has been released! Includes support for email verification, guest policies, dump-server, improved console testing, notification localization and more! <a href="https://t.co/DIISmfm5oP">https://t.co/DIISmfm5oP</a> 🎊</p>&mdash; Laravel (@laravelphp) <a href="https://twitter.com/laravelphp/status/1036971212449243136?ref_src=twsrc%5Etfw">September 4, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


## What's new in Laravel 5.7?

### 1. Symfony Dump Server Integration

Marcel Pociot, authored a package called [laravel-dump-server](https://github.com/beyondcode/laravel-dump-server). This package provides you a dump server, that collects all your `dump` call outputs. It's inspired by [Symfony's Var-Dump Server](https://symfony.com/doc/current/components/var_dumper.html#the-dump-server).

Laravel 5.7 now officially ships with the _laravel_dump-server_ package and makes it available via the Artisan command:

```bash
php artisan dump-server
```

All `dump` calls will be displayed in the console window once the server has started.

![Laravel - Symfony Dump Server Integration](https://cdn.auth0.com/blog/laravel/laravel-dump-server.gif)
_Source: murze.be_

### 2. Better Support For Filesystem

Laravel 5.7 ships with two new methods for reading and writing streams in the filesystem. They are `readStream` and `writeStream` methods for reading and writing streams respectively as shown in the example below:

```php
Storage::disk('s3')->writeStream(
    'new-package.zip',
    Storage::disk('local')->readStream('local-package.zip')
);
```

### 3. Improved Artisan Command Testing

Laravel 5.7 provides a better approach for testing artisan commands.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">ICYMI Last week a new PR was merged into laravel 5.7 with a neat way for testing Artisan commands, check details here: <a href="https://t.co/36f9FbAhBI">https://t.co/36f9FbAhBI</a> <a href="https://t.co/pLC3sVLrJP">pic.twitter.com/pLC3sVLrJP</a></p>&mdash; Mohamed Said🐋 (@themsaid) <a href="https://twitter.com/themsaid/status/1033954657226420224?ref_src=twsrc%5Etfw">August 27, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Check out the example below:

This is an Artisan command:

```php
Artisan::command('hackathon-starter:init', function () {
    $project = $this->ask('What type of project do you want to build?');

    $this->line('Initializing...');

    $answer = $this->choice('Which language do you program in?', [
        'pwa-on-steroids',
        'pwa-normal',
        'pwa-on-fire',
    ]);

    $this->line('Installing...');
});
```

You may now test the command above with the slick test approach below:

```php
/**
 * Test a console command.
 *
 * @return void
 */
public function test_console_command()
{
    $this->artisan('hackathon-starter:init')
         ->expectsQuestion('What type of project do you want to build?', 'PWA')
         ->expectsOutput('Initializing..')
         ->expectsQuestion('Please specify the type of PWA', 'pwa-on-fire')
         ->expectsOutput('Installing...')
         ->assertExitCode(0);
}
```


{% include tweet_quote.html quote_text = "Laravel 5.7 provides a better approach for testing artisan commands." %}

### 4. Multi-Lingual Support for Notifications

In Laravel 5.7, you can now send notifications in other locales, apart from the current language.

The `Illuminate\Notifications\Notification` class offers a `locale` method that can be invoked to set the preferred language.

```php
  $user->notify((new EmailSent($email))->locale('zh'));
```

```php
  Notification::locale('zh')->send($users, new EmailSent($email));
```

### 5. Paginator

By default, Laravel provides three links on each side of the primary paginator links.

In Laravel 5.7, there's a new option, `onEachSide`, to enable customization of the number of links displayed on both sides.


{% highlight html %}
{% raw %}
 {{ $paginator->onEachSide(7)->links() }}
{% endraw %}
{% endhighlight %}

### 6. More Options for Guest Policies

By default, authorization gates and policies return _false_ for guest visitors to your application. In this new release, you can now allow unauthenticated visitors to pass through authorization checks by declaring an "optional" type-hint or supplying a `null` default value for the user argument.

```
Gate::define('modify-sheet', function (?User $user, Sheet $sheet) {
    // ...
});
```

### 7. Optional Email Verification

Laravel 5.7 provides an optional email verification feature. An `email_verified_at` timestamp column has to be added to the user's table migration for this feature to work as intended.

If you want new users to verify their email, the `User` model needs to implement the `MustVerfifyEmail` interface.

```php
<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable implements MustVerifyEmail
{
    // ...
}
```

The newly registered users will receive an email containing a signed verification link. Once the user clicks the link, the app will automatically update the database and redirect the user to the intended location.

This feature also ships with a `verified` middleware for situations where you need to protect certain app routes from only verified members.

```php
  'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
```

### 8. Better Support for Development Errors

**Joseph Silber** submitted a PR that allows Laravel 5.7 to provide a clear and concise message when a non-existent method is called on a model.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Ever mistyped a method on an Eloquent model and got a cryptic error saying that the method doesn&#39;t exist *on the query builder* 😳<br><br>Well, in <a href="https://twitter.com/laravelphp?ref_src=twsrc%5Etfw">@laravelphp</a> 5.7 you&#39;ll now get a clear, concise message saying that the method doesn&#39;t exist on the model 👌<a href="https://t.co/uKAxbIVdmv">https://t.co/uKAxbIVdmv</a> <a href="https://t.co/aWgQ8zr2ak">pic.twitter.com/aWgQ8zr2ak</a></p>&mdash; Joseph Silber (@joseph_silber) <a href="https://twitter.com/joseph_silber/status/1028768236417036288?ref_src=twsrc%5Etfw">August 12, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

### 9. URL Generator & Callable Syntax

Laravel 5.7 now supports callable array syntax for controller actions that generate URLs.

_Before Laravel 5.7_

```php
$url = action('FoodController@index');

$url = action('FoodController@view', ['id' => 1]);
```

_Now_

```php
$url = action([FoodController::class, 'index']);

$url = action([FoodController::class, 'view'], ['id' => 1]);
```

### 10. Laravel Nova

Taylor already announced that he was working on a project several months ago. The long awaited project called **[Laravel Nova](https://nova.laravel.com)** has been released. Nova is a beautifully designed administration panel for Laravel. It offers support for filters, lenses, actions, queued actions, metrics, authorization, custom tools, custom cards, custom fields, etc.

![Laravel Nova](https://nova.laravel.com/img/screenshot.png)
_Laravel Nova_


{% include tweet_quote.html quote_text = "As if Laravel 5.7 wasn't enough, @taylorotwell formally introduced @laravel_nova, a beautifully designed administration panel for Laravel." %}

## Deprecations and Other Updates

* The _resources/assets_ directory has been flattened into _resources_.

Check out other [Laravel 5.7 updates on GitHub](https://github.com/laravel/framework/releases/tag/v5.7.0).

## Upgrading to Laravel 5.7

Laravel 5.7 requires `PHP >= 7.1.3`. And the estimated upgrade time from Laravel `v5.6` is about ten to fifteen minutes.

Check out this [comprehensive upgrade guide](https://laravel.com/docs/master/upgrade#upgrade-5.7.0). However, if you don't want to be bothered about manually configuring and changing files for the upgrade, I recommend using [Laravel Shift - A service that provides automated, instant Laravel upgrade services by an army of thorough bots and friendly humans](https://laravelshift.com).

{% include asides/laravel-backend.markdown %}

## Conclusion

**Laravel 5.7** PHP framework came loaded with new features and significant improvements. And **Nova** is a product every Laravel developer should try out!

Have you upgraded to Laravel v5.7 yet? What are your thoughts? Let me know in the comments section! 😊

{% include tweet_quote.html quote_text = "Laravel 5.7 has been released! Learn what's new in the most popular PHP framework" %}
