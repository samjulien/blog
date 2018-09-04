---
layout: post
title: "Kotlin で RESTful API を開発する"
metatitle: "Kotlin で RESTful API を開発する"
description: "Kotlin と Spring Boot で RESTful API を構築してセキュアにしましょう"
metadescription: "Kotlin と Spring Boot で RESTful API を構築してセキュアにしましょう"
date: 2019-06-22 19:41
category: Technical guide, Backend, Kotlin
author:
  name: "Bruno Krebs"
  url: "https://twitter.com/brunoskrebs"
  mail: "bruno.krebs@auth0.com"
  avatar: "https://www.gravatar.com/avatar/76ea40cbf67675babe924eecf167b9b8?s=60"
design:
  bg_color: "#7370B3"
  image: https://cdn.auth0.com/blog/create-kotlin-app/logo.png
tags:
- kotlin
- JWT
- spring
- restful
related:
- jp-angular-2-authentication
- jp-reactjs-authentication
lang: ja
alternate_locale_en: developing-restful-apis-with-kotlin
---

**TL;DR：** 今回の投稿では、Java の世界を蝕んでいる成長中のプログラミング言語、Kotlin で RESTful API を開発する方法を学んでいきます。CRUD 操作を処理する小規模な Spring Boot RESTful API を作成することから始めます。その後、[Auth0 でこの API をセキュア](https://auth0.com/user-management) にし、それによって [多要素認証](https://auth0.com/multifactor-authentication)、ソーシャルプロバイダーとの統合などたくさんのセキュリティ機能を提供します。最終的には、JWT を自分たちで管理する方法も学び、Auth0 と、独自のトークンを発行する社内ソリューションとを置換します。

## Kotlin とは何か

[Kotlin](https://kotlinlang.org/) は [JetBrains](https://www.jetbrains.com/) が開発したプログラミング言語で、Java 仮想マシン(JVM)で実行し、JavaScript にもコンパイルされます。このプログラミング言語は静的型付けされ、変数、関数、式はコンパイル時間の確認ができるタイプの事前定義された値セットを使用します。

その主要目的のひとつは Java に伴って起きる問題を解決することです。例えば、Java と比較して Kotlin で書かれたソフトウェアはコード行がおよそ 40% 少ないと想定されていますが、Java に使用できる充実したライブラリのセットと相互運用できます。

## Kotlin と Java はどのように違うか

まず最初に、構文です。Kotlin の構文は Java のものと若干似ていますが、違いもたくさんあります。JetBrains は、Java 開発者が Kotlin に移動するときになめらかな学習曲線になると説明しています。これは真実ですが、Kotlin 開発者になることや、新しい言語で慣用的コードを書くことはそんなに容易ではありません。

Kotlin の特化について学習すれば、Kotlin は独自のグロッサリがある高度なプログラミング言語であることに気づかれると思います。例えば、Kotlin には [データクラス](https://kotlinlang.org/docs/reference/data-classes.html)、[シールクラス](https://kotlinlang.org/docs/reference/sealed-classes.html)、[インライン関数](https://kotlinlang.org/docs/reference/inline-functions.html)、その他多数の機能があります。これら機能のほとんどは Java でミラー化できますが、かなり詳細なコードを書かずにはできませんから、真に慣用的な Kotlin ソースコードは JetBrains が言うように簡単ではありません。

しかし、ご安心ください。JetBrains は開発者が Java ソースコードを Kotlin に移動できるようなツールを開発しました。[Kotlin の Web サイト](https://try.kotlinlang.org/) には _Java から変換_ というボタンがあります。このボタンは、Java コードを貼り付けして Kotlin のバージョンにすることができます。そのほかに、[IntelliJ IDEA にも開発者がこれら変換を実行する機能があります](https://www.jetbrains.com/help/idea/2017.1/converting-a-java-file-to-kotlin-file.html)。

## Kotlin を学習する

これまで Kotlin を使用したことがなければ、このブログ記事に従ってもいいですが、その前にこの言語について学習しても、特に害になるものではありません。次のリストは Kotlin について学ぶことができるリソースを上げています。

- [Kotlin リファレンス](https://kotlinlang.org/docs/reference/)：Kotlin の構文が詳しく説明されています
- [トライ Kotlin](https://try.kotlinlang.org/)： Kotlin について実践的に学ぶことができます
- [Kotlin イン・アクション](https://manning.com/books/kotlin-in-action)：この新しい言語を深く掘り下げたい方はご利用ください

Kotlin についてある程度経験がある方、あるいはシンプルな RESTful API を開発することは簡単か疑問に思われている方は続けてお読みください。

## Spring Boot Kotlin アプリケーションを始める

[Spring Initializr](http://start.spring.io/) は Spring Boot アプリケーションを開始するにはうってつけの方法です。えり抜かれたプログラミング言語のひとつのオプションとして Kotlin を加えました（本書の執筆時点では、Java、Kotlin、Groovy の 3 つのオプションがありました）。この Web サイトは、ユーザーがアプリケーションのライブラリを容易に選択できるようにしますが、シンプルにするため、本書のために用意した [この GitHub レポジトリ](https://github.com/auth0-blog/kotlin-spring-boot) を複製することから始め、そこから展開していきます。

====================== CODE BLOCK

このスタートアップ プロジェクトにはすでに [Spring Data JPA](http://projects.spring.io/spring-data-jpa/) と [HSQLDB](http://hsqldb.org/) が搭載されています。これら機能は、API がユーザーによる管理を可能にする 1 セットの顧客を保留します。私たちの仕事は顧客を表す `Customer` Entity Model、永続レイヤーを処理する `CustomerRepository` インターフェイス、 RESTful エンドポイントを定義する `CustomerController` クラスを作成することです。

### Kotlin データクラスを作成する

すでに述べましたが、Kotlin の最良の機能のひとつは非常に簡潔化されたプログラム言語だということです。Java 開発者たちが使い慣れている定型句コードのほとんどは _getters_、_setters_、_equals_、_hashCode_ のように簡潔化された構文を支持しています。実際は、 _dropped_ という用語はここでは適切ではありません。_equals_ や _hashCode_ のようなメソッドはコンパイラによって自動的に派生されますが、必要であれば、明確に定義できます。

RESTful API のアイディアはユーザーが顧客セットを管理できるようにすることで、[Kotlin データクラス](https://kotlinlang.org/docs/reference/data-classes.html) は `Customer` と言います。`model` という新しいディレクトリを `src/main/kotlin/com/auth0/samples/kotlinspringboot/` ディレクトリに作成してから、 `Customer.kt` というファイルに次のソースコードを追加しましょう。

```kotlin
package com.auth0.samples.kotlinspringboot.model

import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GenerationType
import javax.persistence.GeneratedValue

@Entity
class Customer(
  @Id @GeneratedValue(strategy = GenerationType.AUTO)
  var id: Long = 0,
  var firstName: String = "",
  var lastName: String = ""
)
```

Java とは異なりますが、クラスの宣言の後に `Customer` クラスの基本的なプロパティを括弧を利用して定義することに、注意してください。 Kotlin では、[これをプライマリ コンストラクターと言います](https://kotlinlang.org/docs/reference/classes.html#constructors)。クラスの本文でこれらプロパティを定義したり、他のコンストラクターを定義したりできますが、このケースではこれで十分です。また、`@Id` と `@GeneratedValue` の注釈を `id` プロパティに加えましたので、ご注意ください。この構文は Java の構文と同じです。

### 顧客用レポジトリを作成する

これから作成する `CustomerRepository` インターフェイスは正規の Java Spring Boot アプリケーションですることと非常に似ています。まず、整理するために、`persistence` というディレクトリを `src/main/kotlin/com/auth0/samples/kotlinspringboot/` ディレクトリに作成しましょう。この新しいディレクトリに、`CustomerRepository.kt` というファイルを作成し、次のコードを追加します。

```kotlin
package com.auth0.samples.kotlinspringboot.persistence

import com.auth0.samples.kotlinspringboot.model.Customer
import org.springframework.data.repository.CrudRepository

interface CustomerRepository : CrudRepository<Customer, Long>
```

このインターフェイスにはこのプロジェクトにある HSQLDB インメモリデータベースとインタラクトするために必要なすべてがあります。それで `save`、`delete`、`findAll`、[その他多数](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/CrudRepository.html) が可能になります。拡張したばかりの `CrudRepository` インターフェイスについての[詳細情報が必要な場合は、このリソースをご覧ください](https://docs.spring.io/spring-data/data-commons/docs/1.6.1.RELEASE/reference/html/repositories.html)。

### 顧客 RESTful エンドポイントを定義する

ユーザーの要求を処理する RESTful エンドポイントは Java の対応部分と同様で、もう少し簡潔ですが、Java 開発者にとってはかなり似ているものです。重要なステートメントは変わっていないことに気づかれると思います。かなり詳細ですが、私にとっては良い事ですそのため、依存関係の原因を簡単に特定できます。

クラスを作成するために、`controller` ディレクトリを `src/main/kotlin/com/auth0/samples/kotlinspringboot/` ディレクトリに作成することから始めましょう。その後、`CustomerController.kt` というファイルを新しいディレクトリに作成し、次のコードを追加します。

```kotlin
package com.auth0.samples.kotlinspringboot.controller

import com.auth0.samples.kotlinspringboot.model.Customer
import com.auth0.samples.kotlinspringboot.persistence.CustomerRepository
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/customers")
class CustomerController(val repository: CustomerRepository) {

	@GetMapping
	fun findAll() = repository.findAll()

	@PostMapping
	fun addCustomer(@RequestBody customer: Customer)
			= repository.save(customer)

	@PutMapping("/{id}")
	fun updateCustomer(@PathVariable id: Long, @RequestBody customer: Customer) {
		assert(customer.id == id)
		repository.save(customer)
	}

	@DeleteMapping("/{id}")
	fun removeCustomer(@PathVariable id: Long)
			= repository.delete(id)

	@GetMapping("/{id}")
	fun getById(@PathVariable id: Long)
			= repository.findOne(id)
}
```

このクラスのソースコードはすぐにわかりますが、完全を期すために、その説明は次のとおりです。

- `@RequestMapping("/customers")` 注釈はこのクラスのすべてのエンドポイントには `/customers` プレフィクスがあることを宣言しています。
- `@GetMapping` 注釈は `/customer`への HTTP **GET** 要求を処理するメソッドとして`findAll` を定義します。
- `@PostMapping` 注釈は`/customers` への HTTP **POST** 要求を処理するメソッドとして `addCustomer` を定義します。また、このメソッドは顧客の JSON バージョンを受理し、`Customer` クラスに自動的に逆シリアル化します。
- `@PutMapping("/{id}")` 注釈は `/customers` への HTTP **PUT** 要求を処理するメソッドとして `updateCustomer` を定義します。このメソッドも要求の本文として `Customer` を受理します。**PUT** メソッドと POST メソッドの違いは PUT メソッドは要求パスが顧客の `{id}` を更新することを求めることです。
- `@DeleteMapping("/{id}")` 注釈は `/customers` への HTTP **DELETE** 要求を処理するメソッドとして `removeCustomer` を定義します。{id} の場合、消去される顧客の ID を定義します。
- `@GetMapping("/{id}")` 注釈は `/customer/{id}` への HTTP **GET** 要求を処理するメソッドとして `getById` を定義し、`{id}` は応答としてシリアル化される顧客を定義します。

それだけです。これで Spring Boot によって支援される最初の Kotlin RESTful API ができました。遊んでみたければ、アプリケーションのルートディレクトリに `mvn spring-boot:run` とタイプすると、Spring Boot が起動します。その後、次のコマンドを使って API とインタラクトします。

```bash
# adds a new customer
curl -H "Content-Type: application/json" -X POST -d '{
    "firstName": "Bruno",
    "lastName": "Krebs"
}'  http://localhost:8080/customers

# retrieves all customers
curl http://localhost:8080/customers

# updates customer with id 1
curl -H "Content-Type: application/json" -X PUT -d '{
    "id": 1,
    "firstName": "Bruno",
    "lastName": "Simões Krebs"
}'  http://localhost:8080/customers/1

# deletes customer with id 1
curl -X DELETE http://localhost:8080/customers/1
```

何か問題が発生したら、GitHub レポジトリの顧客ブランチ でソースコードを比較してください。

## Kotlin RESTful API を Auth0 でセキュアにする

ご覧のように、API を Auth0 でセキュアにすることは非常に簡単で、たくさんの機能を提供します。Auth0 では、[シングルサインオン](https://auth0.com/docs/sso/single-sign-on)、[ユーザー管理](https://auth0.com/docs/user-profile)、[ソーシャル ID プロバイダー（Facebook、GitHub、Twitterなど）](https://auth0.com/docs/identityproviders)のサポート、[エンタープライズ（Active Directory、LDAP、SAMLなど）](https://auth0.com/enterprise)、[独自のユーザーデータベース](https://auth0.com/docs/connections/database/mysql) を含む、確かな [アイデンティティ管理ソリューション](https://auth0.com/docs/identityproviders) を取得するコード行を数行書かなければなりません。

まだこのようなことをしたことがない初心者には、[無料 Auth0 アカウント](https://auth0.com/signup) の登録をお勧めします。Auth0 アカウントをお持ちの方は、まず [ダッシュボードに API を作成](https://manage.auth0.com/#/apis) してください。API は外部リソースを表すエンティティで、クライアントが要求する保護されているリソースの受理と応答を可能にします。この API は、構築したばかりの Kotlin アプリの正確な機能です。

先進認証を始めるために [Auth0 は寛大な無料レベルを提供しています](https://auth0.com/pricing)。

==================== IMAGE

API を作成するとき、新しいAPI のフレンドリ名の Name、access\_token を要求するときに使用する String の Identifier、この API が access\_token を登録するために [対称 または 非対称アルゴリズム](https://auth0.com/blog/json-web-token-signing-algorithms-overview/) を使用する場合に定義する Signing Algorithm の 3 つの分野を定義しなければなりません。この場合、これらの分野をそれぞれKotlin RESTful API、kotlin-jwts、RS256（非対称アルゴリズムを使用します）にします。

Auth0 は異なる [OAuth 2.0 はアクセストークンを要求するためにフローします](https://auth0.com/docs/api-auth) をサポートします。この場合、例をシンプルにするために、 [API &amp; 信頼するクライアントのフロー](https://auth0.com/docs/api-auth/grant/password) を使用します。このフローは実装が最もシンプルですが、クライアントアプリケーションが **絶対的に信頼される** 場合 **だけ** 使用すべきであることに留意してください。ほとんどの場合別のフローが必要で、Auth0 の [「どの OAuth 2.0 フローを使用すべきか？」](https://auth0.com/docs/api-auth/which-oauth-flow-to-use) の記事はニーズに合った適切なアプローチを選ぶときに役立ちます。

_API &amp; 信頼されるクライアント_ フローを使用するには、まず Auth0 アカウントで Default Directory プロパティを構成しなければなりません。そのためには、[アカウント設定](https://manage.auth0.com/#/account) ページに移動し、 Default Directory プロパティの値として Username-Password-Authentication を追加します。この値は Auth0 アカウントで既定で表示される [データベース接続](https://manage.auth0.com/#/connections/database) の名前です。

また、[クライアント](https://manage.auth0.com/#/clients) で Password 付与タイプを有効にする必要もあります。上記で説明したように API を作成したら、Auth0 は Kotlin RESTful API (Test Client) というクライアントを自動的に作成します。その設定にアクセスして Show Advanced Settings オプションをクリックし、Grant Types タブの Password をチェックし、その変更を保存します。

==================== IMAGE

### コードを変更する

./src/main/resources の下に application.properties というファイルがあります。このファイルを Auth0 アカウントのデータで読み込む必要があります。新規アカウントを作成しているときに既定で、この場合に使用できる「既定のアプリ」が表示されます。これらはその構成で重要な要素なので、その値と次のアプリケーションの値を置換することを忘れないでください。

====================== CODE BLOCK

コードに進む前に、次のように Maven 構成に 3 つの依存関係を追加する必要があります。

====================== CODE BLOCK

これが終わったら、WebSecurityConfig.kt というファイルを src/main/kotlin/com/auth0/samples/kotlinspringboot/ ディレクトリに次のソースコードで作成します。

====================== CODE BLOCK

それだけです。Auth0 を Kotlin Spring Boot RESTful API で使用するために必要なことはこれだけです。アプリケーションのセキュリティをテストするために、アプリケーションを再度実行しましょう。

====================== CODE BLOCK

要求を API に発行するアクセストークンを取得する前に、まず Auth0 の新規ユーザーを作成する必要があります。そのためには、/dbconnections/signup エンドポイントに POST要求を発行する必要があります。この要求は次の JSON 本文の後に Content-Type ヘッダーと application/json が必要です。

====================== CODE BLOCK

その後、POST要求を https://YOUR-DOMAIN.auth0.com/oauth/token に発行して access\_token を取得します。この要求にも次のように本文と Content-Type ヘッダーに JSON オブジェクトを含む必要があります。

====================== CODE BLOCK

両方の要求の client\_id および client\_secret プロパティは状況に応じて **変更されなければならない** ことに注意してください。それらの値は Auth0 が作成した Kotlin RESTful API (Test Client) クライアントで見つけられます。それらの値を取得するには [クライアントページ](https://manage.auth0.com/#/clients) に移動してください。

この最後の要求を発行すると、access\_token を取得できます。これからは、Kotlin API に送信する要求のヘッダーでこのトークンを使用しますので、この access\_token でエンドポイントをクエリすると、顧客のセットを再度管理できるようになります。

====================== CODE BLOCK

[「Kotlin RESTful API を Auth0 で簡単にセキュアにする」](https://twitter.com/intent/tweet?text=%22Securing+Kotlin+RESTful+APIs+is+easy+with+Auth0%22%20via%20@auth0%20http://auth0.com/blog/developing-restful-apis-with-kotlin/)

[ツイートする](https://twitter.com/intent/tweet?text=%22Securing+Kotlin+RESTful+APIs+is+easy+with+Auth0%22%20via%20@auth0%20http://auth0.com/blog/developing-restful-apis-with-kotlin/)

## Kotlin を独自のソリューションでセキュアにする

何らかの理由で Auth0 でセキュアになる RESTful API を希望しない場合は、本章で説明するステップに従ってください。まず、pom.xml から Auth0 の依存関係を削除します。

====================== CODE BLOCK

その後に、application.properties ファイルに追加した 2 つのプロパティは使用しませんので削除します。それから、JWT を発行・検証するには、次の Maven 依存関係を追加します。

====================== CODE BLOCK

### ユーザーを処理する

API の複数のユーザーをサポートするには、まずApplicationUser.kt、ApplicationUserRepository.kt、SignUpController.kt の 3 つのクラスを作成します。これらクラスは顧客の管理をサポートするほとんどクラスのように動作します。最初のクラス、ApplicationUser.kt クラスは model パッケージに作成され、次のコードを含みます。

====================== CODE BLOCK

新しいものは何もありません。ユーザーのプロパティを保留する別のデータクラスだけです。その後、ApplicationUserRepository.kt クラスを persistence パッケージに次のコードで作成します。

====================== CODE BLOCK

この場合の CustomerRepository と比較した場合の唯一の違いは findByUsername というメソッドを定義したことです。このメソッドは、ユーザーがユーザー名を見つけるために独自のソリューションで使用されます。ここで、最後のクラス SignUpController.kt は次のコードで controller パッケージに作成します。

====================== CODE BLOCK

このコントローラーで定義された唯一のエンドポイントは signUp で、新規ユーザーによるアプリケーションの登録を可能にします。サインイン プロセスとトークンの検証は後ほど説明しますが、別の領域で処理されます。最終的なデータ漏洩でさえもユーザーのパスワードをセキュアにするには、Spring Security に付いてくる BCryptPasswordEncoder クラスを使用してすべてのパスワードをエンコードすることにご留意ください。

### JWT を Kotlin で発行・検証する

これで User データクラスをマップし、エンドポイントによって新規ユーザーが自分で登録できるので、API とインタラクトできるようにする前にこれらユーザーがサインインし、JWT を検証する必要があります。これを実現するには、JWTAuthenticationFilter、JWTAuthorizationFilter、UserDetailsServiceImpl の 2 つのフィルタと 1 つのクラスを作成します。サインイン機能を担当する最初のフィルタは JWTAuthenticationFilter.kt と呼ばれる新規ディレクトリファイルに WebSecurity クラスとして同じパッケージに作成されます。このファイルには次のソースコードがあります。

====================== CODE BLOCK

このフィルタは、

- ユーザーから資格情報を解析し、それらを認証する attemptAuthentication、
- ユーザーの認証が成功したときに JWT を作成する successfulAuthentication の 2 つの機能を定義します。

これら両方のフィルタは SECRET や EXPIRATION\_TIME のように一部未定義の定数を使用することにご留意ください。これら定数を定義するには、次のコードで SecurityConstants.kt というファイルを同じディレクトリに作成します。

====================== CODE BLOCK

上記のフィルタが作成するトークンを検証するには、2つめのフィルタ JWTAuthorizationFilter が必要です。このフィルタは次のコードで同じディレクトリ内に作成されます。

====================== CODE BLOCK

このフィルタはセキュリティ保護されたエンドポイントが要求されたときに使用され、Authorization ヘッダーにトークンがあればチェックによって開始します。何とかトークンが見つかれば、その検証が行われ、そのユーザーを SecurityContext に設定します。トークンが見つからなければ、その要求を Spring Security フィルタチェーンに応じて移動させ、それからこの要求は 401（承認されていません）状態コードの応答を受けます。

作成する必要がある最後のクラスは UserDetailsServiceImpl です。このクラスは Spring Security から UserDetailsService クラスを拡張し、データベースでユーザーを見つける担当なので、Spring Security がその資格情報をチェックできます。このクラスはメイン kotlinspringboot ディレクトリに作成され、次のソースコードを格納します。

====================== CODE BLOCK

この独自のソリューションをまとめるために、WebSecurity クラスのコンテンツと次を置換します。

====================== CODE BLOCK

これらを変更したら、再度 API とインタラクトできるようになり、次のように JWT を適切に作成・検証しているかをチェックします。

====================== CODE BLOCK

ご覧のように、JWT で独自のセキュリティソリューションを作成することはそんなに難しくはありません。ただし、Auth0 で統合するために実行した作業よりもずっと多くの作業を要します。[多要素認証](https://auth0.com/multifactor-authentication)、[ソーシャル ID プロバイダー](https://auth0.com/user-management)、[エンタープライズ接続（Active Directory、LDAP、SAMLなど）](https://auth0.com/enterprise)のようなさらに高度なトピックには対処しませんでした。このようなケースを処理するにはさらに多くの作業が必要になります。これら機能をなんとか素早く実現したとしても、Auth0 を使ったときと同じようなセキュリティ対策を講じることはできません。

## まとめ

Java 開発者にとって Kotlin でコードを書くことは、注意すべき危険がそんなにないので、そんなに難しいことではありません。しかし、言語のフルパワーと最高の機能を使って真の Kotlin 開発者になるには容易ではなく、数時間の学習と開発が必要です。Kotlin と既存の Java ライブラリとの統合は Spring Boot を使用できるので非常に良いことで、開発したコードは非常に完結で読みやすいものでした。Kotlin の機能についてあまり取り扱いませんでしたが、その適用性を最後に検証しました。

[「バックエンドの Kotlin アプリケーションを開発することは全く問題がなく簡単です。」](https://twitter.com/intent/tweet?text=%22Developing+backend+Kotlin+applications+is+perfectly+fine+and+easy.%22%20via%20@auth0%20http://auth0.com/blog/developing-restful-apis-with-kotlin/)

[ツイートする](https://twitter.com/intent/tweet?text=%22Developing+backend+Kotlin+applications+is+perfectly+fine+and+easy.%22%20via%20@auth0%20http://auth0.com/blog/developing-restful-apis-with-kotlin/)

いかがですか？Kotlin を支持して Java を断念しませんか？
