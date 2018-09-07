---
layout: post
title: "Spring Boot API で DTO をエンティティへ自動的にマッピングする"
metatitle: "Spring Boot API で DTO をエンティティへ自動的にマッピングする"
description: "ModelMapper が Spring Boot API 上のエンティティへの DTO のマッピング プロセス自動化にどのように役立つか学びましょう。"
metadescription: "ModelMapper が Spring Boot API 上のエンティティへの DTO のマッピング プロセス自動化にどのように役立つか学びましょう。"
date: 2017-09-05 08:45
category: Technical Guide, Java, Spring Boot
author:
  name: "Bruno Krebs"
  url: "https://twitter.com/brunoskrebs"
  mail: "bruno.krebs@auth0.com"
  avatar: "https://www.gravatar.com/avatar/76ea40cbf67675babe924eecf167b9b8?s=60"
design:
  bg_color: "#3F6426"
  image: https://cdn.auth0.com/blog/spring-boot-auth/logo.png
tags:
- spring-boot
- dto
- modelmapper
related:
- jp-developing-restful-apis-with-kotlin
- jp-angular-2-authentication
- jp-reactjs-authentication
lang: ja
alternate_locale_en: automatically-mapping-dto-to-entity-on-spring-boot-apis
---

## DTO とは何か？

DTO はデータ転送オブジェクトを表し、リモート インターフェイスで作業しているときに、呼び出し数を減らすことを思いついた設計パターンです。[Martin Fowler がブログで定義](https://martinfowler.com/eaaCatalog/dataTransferObject.html)するように、データ転送オブジェクトを使用する主な理由は複数のリモート通話を１つのバッチにすることです。

例えば、銀行アカウントのデータを公開する RESTful API で通信しているとしましょう。この場合、現状や最新のアカウント取引をチェックするように複数の要求を発する代わりに、銀行は DTO を返すエンドポイントを公開してすべてを要約することができます。リモート アプリケーションの操作で最も高価なもののひとつはクライアントとサーバーの間の往復時間なので、この粒度の粗いインターフェイスはパフォーマンスの改善に大きく役立ちます。

## DTO および Spring Boot API

Java（と Spring Boot）で書き込まれた RESTful API で DTO を使用するもうひとつの利点はドメイン オブジェクト（別名：エンティティ）の実装詳細を非表示するときに役立ちます。エンドポイントを介してエンティティを公開することは、どのプロパティをどの操作を通して変更するかをよく注意しなければ、セキュリティ問題になります。

例として、ユーザーの詳細を公開し、２つのエンドポイントを介してユーザーの更新を承諾する Java API を想像してみましょう。最初のエンドポイントは `GET` リクエストを処理し、ユーザーデータを返します。そして、２つめのエンドポイントがこれらの詳細を更新するために `PUT` リクエストを承諾します。このアプリケーションが DTO を利用しなければ、ユーザーのすべてのプロパティは最初のエンドポイント（例：パスワード）で公開され、２つめのエンドポイントはユーザーを更新するときにどのプロパティを承諾するかを精選しなければなりません（例：誰もがユーザーの役割を更新できるわけではありません）。この状況を乗り越えるために、DTO は最初のエンドポイントが対象とするものだけを公開し、２つめのエンドポイントが承諾するものを制限するのに役に立ちます。この特性はアプリケーション内のデータ整合性を保つのに役立ちます。

{% include jp-tweet_quote.html quote_text="DTO は Java アプリケーション上のデータ整合性を保つのに役立ちます。" %}

本アーティクルでは、このような状況を処理するために DTO を利用していきます。後で説明するように、この設計パターンではさらにいくつかのクラスをアプリケーションに導入しますが、そのセキュリティは改善されます。

## ModelMapper の導入

DTO をマップするために面倒な/定型コードをエンティティに書き込んだり、その反対を避けるために、[ModelMapper](http://modelmapper.org/) と呼ばれるライブラリを使用していきます。ModelMapper の目標はあるオブジェクト モデルを別のものにどのようにマップするかを自動的に決定して、オブジェクト マッピングを簡単にすることです。このライブラリはかなり強力で、マッピングプロセスを簡素化する非常にたくさんの構成を適用できますが、ほとんどのケースに当てはまる既定の動作を提供して構成よりも規則を優遇します。

[このライブラリのユーザー マニュアル](http://modelmapper.org/user-manual/)はよく書かれており、マッピング プロセスを調整する必要があるときに貴重なリソースになります。このライブラリの機能を少しご紹介するために、次のような `User` があるとしましょう。

```java
// assume getters and setters
class User {
  long id;
  String firstName;
  String lastName;
  String email;
  String password;
  String securitySocialNumber;
  boolean isAdmin;
}
```

そして、`id`、`firstName`、および `email` のみを公開するとします。ModelMapper を使って、次のように DTO を生成しなければなりません。

```java
// assume getters and setters
class UserDTO {
  long id;
  String firstName;
  String email;
}
```

それから、次ように ModelMapper を呼び出します。

```java
ModelMapper modelMapper = new ModelMapper();
// user here is a prepopulated User instance
UserDTO userDTO = modelMapper.map(user, UserDTO.class);
```

つまり、公開したい構成を定義し、`modelMapper.map` を呼び出すことで、目標を達成し、公開したくないものを非表示にします。[Jackson](https://github.com/FasterXML/jackson) のようなライブラリはオブジェクトをシリアライズするときにプロパティの一部を無視する注釈を提供することに反対する方がいますが、このソリューションはデベロッパーがエンティティを高速化する唯一の方法を制限します。DTO と ModelMapper を使用することで、希望するだけの異なるバージョン（と異なる構造）のエンティティを提供できます。

## 何を構築するか？

これからは、Spring Boot RESTful API のエンティティを公開する DTO を使うことに集中していきます。ModelMapper を使って、この API を DTO に、およびその反対に作成するエンティティからマップしていきます。新しいプロジェクトを一から設定することにあまり時間を費やしたくはないので、[前回のアーティクル](https://auth0.com/blog/integrating-spring-data-jpa-postgresql-liquibase/)で作成した QuestionMarks プロジェクトを利用していきます。このアーティクルの全文を読む **必要はありません** 。これから[そのプロジェクトをサポートする GitHub レポジトリ](https://github.com/auth0-blog/questionmarks-server)を複製し、私たちが関心があることを中心とした確固たる基盤を与えてくれる特定の [Git タグ](https://git-scm.com/book/en/v2/Git-Basics-Tagging) を確認していきます。

QuestionMarks の背景にある考え方は、このアプリケーションはユーザーが多岐選択式の質問に答えて実践し、知識を高めることができることです。より良い体制を提供するために、これらの質問は異なる試験にグループ化されています。例えば、ユーザーがインタビューに備えるのに役立つ JavaScript 関係の質問を保留する _JavaScript インタビュー_ と呼ばれる試験があります。もちろん、本書では、アプリケーション全体を構築すると時間がかかり、アーティクルが大きくなりますので、構築しませんが、上記のテクノロジーのアクションをご覧いただけます。

[前回のアーティクルでは、Spring Data JPA、PostgreSQL、および Liquibase を統合して永続レイヤーを管理しました](https://auth0.com/blog/integrating-spring-data-jpa-postgresql-liquibase/)。エンティティを公開する良い方法がなかったので、RESTful エンドポイントを作成しませんでした。これは本書の主な目標です。

### PostgreSQL を起動する

既存のプロジェクトを複製する前に、PostgreSQL インスタンスを設定してデータベース操作や永続化をサポートする必要があります。[前のアーティクル](https://auth0.com/blog/integrating-spring-data-jpa-postgresql-liquibase/)で述べたように、Docker は開発機にインストールしないでアプリケーションを起動するには素晴らしいソリューションです。

Docker をインストールする必要がありますが、それをインストールするプロセスは簡単です（[MacOS はこちらのリンク](https://www.docker.com/docker-mac)、[Windows はこちらのリンク](https://www.docker.com/docker-windows)、および [Ubuntu はこちらのリンク](https://docs.docker.com/engine/installation/linux/ubuntu/)）。Docker を正しくインストールすると、Docker 化した PostgreSQL のインスタンスを次のように実行できます。

```bash
docker run --name questionmarks-psql \
    -p 5432:5432 \
    -e POSTGRES_DB=questionmarks \
    -e POSTGRES_PASSWORD=mysecretpassword \
    -d postgres
```

Docker インスタンス内で PostgreSQL を起動したくない場合、または別の PostgreSQL インスタンスがすでにある場合は、`questionmarks` と呼ばれるデータベースがそれにあり、`postgres` ユーザーがパスワードとして `mysecretpassword` を持っていることを保証する必要があります。または、`./src/main/resources/application.properties` ファイルのこれら値を変更します。

```properties
spring.datasource.url=jdbc:postgresql://localhost/questionmarks
spring.datasource.username=postgres
spring.datasource.password=mysecretpassword
spring.datasource.driver-class-name=org.postgresql.Driver
```

### QuestionMarks を複製する

次のステップは、[QuestionMarks をサポートする GitHub レポジトリ](https://github.com/auth0-blog/questionmarks-server) を複製することです。本書の特定タグを確認してください。次のコマンドを発行して達成します。

```bash
git clone https://github.com/auth0-blog/questionmarks-server.git
cd questionmarks-server
git checkout post-2
```

[前のアーティクル](https://auth0.com/blog/integrating-spring-data-jpa-postgresql-liquibase/)ではエンドポイントを作成しなかったので、ここでアプリケーションを実行するのは良くありません。アプリケーションを実行しても害にはなりません。Liquibase はすでに作成されている５つのエンティティをサポートするテーブルの構造を作成します。しかし、エンドポイントを開発した後にそれが実行するのを待つことは同じ効果を出します。

その後、Spring Boot プロジェクトを優先 IDE（統合開発環境）にインポートする必要があります。

### 依存関係を追加する

QuestionMarks プロジェクトを複製し、IDE にインポートしたら、DTO の自動マッピング処理に進みます。まず行う最初のステップは `./build.gradle` ファイルに依存関係として ModelMapper を追加します。依存関係を [`hibernate-java8` library](https://mvnrepository.com/artifact/org.hibernate/hibernate-java8) にも追加します。このアーティクルを使って、Java8-固有クラスをデータベース上の列にマップします。

```gradle
// ... other definitions

dependencies {
	// ... other dependencies
  compile('org.modelmapper:modelmapper:1.1.0')
  compile('org.hibernate:hibernate-java8:5.1.0.Final')
}
```

### 試験エンティティをリファクタ―する

DTO を使う本当の利点を証明し、マッピング プロセスのさらに有意義な例を実行するために、`Exam` エンティティを少しリファクターしていきます。その試験がいつ作成され、最後に編集された期日を把握するために、２つのデータ プロパティをそれに追加していきます。そして、それが発行された（一般が利用可能）か否かを示すフラッグを追加していきます。`./src/main/java/com/questionmarks/model/Exam.java` ファイルを開き、次のコードの行を追加します。

```java
// ... other imports
import java.time.LocalDateTime;

// ... annotations
public class Exam {
    // ... other properties

    @NotNull
    private LocalDateTime createdAt;

    @NotNull
    private LocalDateTime editedAt;

    @NotNull
    private boolean published;
}
```

最後のセクションに `hibernate-java8` ライブラリをインポートしないと、JPA/Hibernate は自動的に `LocalDateTime` をデータベースにマップすることはできませんので、ご注意ください。幸運なことにこのライブラリはユーザーを助けるためにあります。そうでなければ、独自のコンバーターを作る必要があります。

また、新しいプロパティ（列として）を、アプリケーションをサポートする PostgreSQL データベースに追加する必要があります。[前回のアーティクルでは、スキーマ移行を処理する Liquibase をセットアップしました](https://auth0.com/blog/integrating-spring-data-jpa-postgresql-liquibase/)ので、そのコマンドで新しいファイルを作り、新しい列を追加しなければなりません。このファイルを `v0002.sql` と呼び、次のコンテンツでそれを `./src/main/resources/db/changelog/changes/` フォルダに追加します。

```sql
alter table exam
  add column created_at timestamp without time zone not null default now(),
  add column edited_at timestamp without time zone not null default now(),
  add column published boolean not null default false;
```

このアプリケーションを次回実行するとき、Liquibase はこのファイルを読み取り、これらのコマンドを実行して３つの列を追加します。SQL コマンドは既存記録の既定値でこれら列も事前設定します。そのほかに、JPA/Hibernate が列やその処理に対応するために変更する必要があるものはありません。

### DTO を作成する

ユーザーに直接変更してほしくない機微なプロパティを保留する `Exam` エンティティを変更したので、ユーザーのリクエストを良く処理するために２つの DTO を作成していきます。最初の DTO は新しい試験の作成を担当するので、`ExamCreationDTO` と呼びます。`com.questionmarks.model` パッケージ内の `dto` と呼ばれる新しいパッケージにこの DTO クラスを作成します。このクラスには次のソースコードが含まれます。

```java
package com.questionmarks.model.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Getter
@Setter
public class ExamCreationDTO {
    @NotNull
    private String title;

    @NotNull
    private String description;

    @JsonIgnore
    private final LocalDateTime createdAt = LocalDateTime.now();

    @JsonIgnore
    private final LocalDateTime editedAt = LocalDateTime.now();
}
```

新しい試験の作成に協力的なユーザーは新しい DTO で定義されている構造を含むリクエストを送信する必要があります。つまり、このユーザーは `title` と `description` を正確に送信する必要があります。`createdAt` プロパティと `editedAt` プロパティの両方は DTO 自体によって事前設定されます。これらプロパティを介して値を送信しようとするユーザーがあるときは、このアプリケーションは `@JsonIgnore` のマークがついているのでそれらを無視します。そのほかに、`Exam` エンティティに追加した `published` プロパティは DTO がそれを含まなかったので、外部からは完全に非表示にされます。

これから作成する２つめの DTO は既存の試験を更新する担当になります。この DTO を `ExamUpdateDTO` と呼び、それを次のコードで `com.questionmarks.model.dto` パッケージに含みます。

```java
package com.questionmarks.model.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Id;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Getter
@Setter
public class ExamUpdateDTO {
    @Id
    @NotNull
    private Long id;

    @NotNull
    private String title;

    @NotNull
    private String description;

    @JsonIgnore
    private final LocalDateTime editedAt = LocalDateTime.now();
}
```

他の DTO との違いは、これは更新する `id` プロパティを含み、このフィールドを更新するのは意味がないので、`createdAt` プロパティがありません。

DTO の視点から、これは大体、試験を安全に作成し、更新するために必要なことです。これから、これらマッピングを手動で操作しなくてもいいように、DTO をエンティティへマッピングするプロセスの合理化に集中していきます。

ちょっとお待ちください！次の作業に進む前に、ModelMapper が実際に DTO を `Exam` エンティティへマッピングできることを保証する小さな単体テストを作りましょう。（`./src/test/java/com/questionmarks/` フォルダ内の）テストコードにある `com.questionmarks` パッケージ内に `model` と呼ばれる新しいパッケージを作りましょう。 それから、次のコード内に `ExamUT` と呼ばれるクラスを作ります。

```java
package com.questionmarks.model;

import com.questionmarks.model.dto.ExamCreationDTO;
import com.questionmarks.model.dto.ExamUpdateDTO;
import org.junit.Test;
import org.modelmapper.ModelMapper;

import static org.junit.Assert.assertEquals;

public class ExamUT {
    private static final ModelMapper modelMapper = new ModelMapper();

    @Test
    public void checkExamMapping() {
        ExamCreationDTO creation = new ExamCreationDTO();
        creation.setTitle("Testing title");
        creation.setDescription("Testing description");

        Exam exam = modelMapper.map(creation, Exam.class);
        assertEquals(creation.getTitle(), exam.getTitle());
        assertEquals(creation.getDescription(), exam.getDescription());
        assertEquals(creation.getCreatedAt(), exam.getCreatedAt());
        assertEquals(creation.getEditedAt(), exam.getEditedAt());

        ExamUpdateDTO update = new ExamUpdateDTO();
        update.setTitle("New title");
        update.setDescription("New description");

        modelMapper.map(update, exam);
        assertEquals(update.getTitle(), exam.getTitle());
        assertEquals(update.getDescription(), exam.getDescription());
        assertEquals(creation.getCreatedAt(), exam.getCreatedAt());
        assertEquals(update.getEditedAt(), exam.getEditedAt());
    }
}
```

このクラスで唯一定義された `@Test` は特定の `title` と `description` で `ExamCreationDTO` のインスタンスを作り、新しい `Exam` を生成する `ModelMapper` のインスタンスを使用します。それから、この `Exam` が `ExamCreationDTO` によって保留されるものと同じ `title`、`description`、`createdAt`、および `editedAt` 値を含むかを確認します。

最後に、`ExamUpdateDTO` のインスタンスを作成し、`title`、`description`、および `editedAt` プロパティが更新されたか、`createdAt` プロパティが変更されないままかを確認する前に作成された `Exam` インスタンスに適用します。ここで、IDE または `gradle test` コマンドを介してテストを実行すると、良い結果が見られるはずです。これから、エンジンの残りを構築し、DTO をエンティティへマップしていきます。

### DTO をエンティティへ自動的にマッピングする


ModelMapper ライブラリには [Spring のために特別に設計された拡張](http://modelmapper.org/user-manual/spring-integration/)がありますが、これから実行することには役立たないので使用しません。これから DTO を処理する RESTful API を構築していき、これら DTO をできるだけ自動的にエンティティへ変換したいので、この魔法をするために独自のセットの汎用クラスを作成します。

用心深い読者は `ExamUpdateDTO` クラスの `id` プロパティに `@Id` のマークがついていることにお気づきだと思います。このソリューションはデーターベースに保存される既存エンティティのインスタンスをフェッチするために Spring MVC、JPA/Hibernate、および ModelMapper とこれら `@Ids` の値と統合するので、この注釈を追加しました。`@Id` プロパティを含まない DTO の場合、データベースを照会せずに、送信された値を基にした新しいエンティティを作ります。

`Exam` のインスタンスとその DTO のみを処理するようにこのソリューションを制限できますが、QuestionMarks プロジェクトが拡大するにつれて、新しい DTO や新しいエンティティをお互いに変換しなければなりません。ですから、汎用ソリューションを作成して、発生するエンティティや DTO のシナリオを処理するのが状況にかないます。

これから作成する最初のアーティファクトは DTO をエンティティへ自動的にマッピングする注釈です。`com.questionmarks` パッケージに `util` と呼ばれる新しいパッケージを作り、次のコードでそれに `DTO` インターフェイスを作ります。

```java
package com.questionmarks.util;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.PARAMETER)
@Retention(RetentionPolicy.RUNTIME)
public @interface DTO {
    Class value();
}
```

このインターフェイスは `@interface` と定義される注釈を実際に生成し、ランタイム (`@Retention (RetentionPolicy.RUNTIME)`) のメソッド パラメータ (`@Target (ElementType.PARAMETER)`) で使用されることを意図とします。この注釈が公開する唯一のプロパティは `value` で、その目標はどの DTO からエンティティが生成/更新されるかを定義することです。

次に作成する要素はその作業を担当するクラスです。このクラスは DTO の一部の構造に適合するユーザーによるリクエストを取得し、特定のエンティティ上の DTO を変換します。このクラスは送信した DTO が `@Id` を含む場合のために、データベースの照会も担当します。このクラスを `DTOModelMapper` と呼び、次のソースコードでそれを `com.questionmarks.util` パッケージ内に生成しましょう。

```java
package com.questionmarks.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.modelmapper.ModelMapper;
import org.springframework.core.MethodParameter;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.http.HttpInputMessage;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.ModelAndViewContainer;
import org.springframework.web.servlet.mvc.method.annotation.RequestResponseBodyMethodProcessor;

import javax.persistence.EntityManager;
import javax.persistence.Id;
import javax.validation.constraints.NotNull;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Type;
import java.util.Collections;

public class DTOModelMapper extends RequestResponseBodyMethodProcessor {
    private static final ModelMapper modelMapper = new ModelMapper();

    private EntityManager entityManager;

    public DTOModelMapper(ObjectMapper objectMapper, EntityManager entityManager) {
        super(Collections.singletonList(new MappingJackson2HttpMessageConverter(objectMapper)));
        this.entityManager = entityManager;
    }

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(DTO.class);
    }

    @Override
    protected void validateIfApplicable(WebDataBinder binder, MethodParameter parameter) {
        binder.validate();
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        Object dto = super.resolveArgument(parameter, mavContainer, webRequest, binderFactory);
        Object id = getEntityId(dto);
        if (id == null) {
            return modelMapper.map(dto, parameter.getParameterType());
        } else {
            Object persistedObject = entityManager.find(parameter.getParameterType(), id);
            modelMapper.map(dto, persistedObject);
            return persistedObject;
        }
    }

    @Override
    protected Object readWithMessageConverters(HttpInputMessage inputMessage, MethodParameter parameter, Type targetType) throws IOException, HttpMediaTypeNotSupportedException, HttpMessageNotReadableException {
        for (Annotation ann : parameter.getParameterAnnotations()) {
            DTO dtoType = AnnotationUtils.getAnnotation(ann, DTO.class);
            if (dtoType != null) {
                return super.readWithMessageConverters(inputMessage, parameter, dtoType.value());
            }
        }
        throw new RuntimeException();
    }

    private Object getEntityId(@NotNull Object dto) {
        for (Field field : dto.getClass().getDeclaredFields()) {
            if (field.getAnnotation(Id.class) != null) {
                try {
                    field.setAccessible(true);
                    return field.get(dto);
                } catch (IllegalAccessException e) {
                    throw new RuntimeException(e);
                }
            }
        }
        return null;
    }
}
```

これは、ここまで生成したクラスの中で最も複雑ですから、良くご理解いただくために細かく説明していきましょう。

1. このクラスは `RequestResponseBodyMethodProcessor` に拡張します。リクエストをクラスに変換するプロセス全体を書かなくてもいいように、このプロセッサを利用します。Spring MVC に慣れている方のために、拡張されたクラスは [`@RequestBody` parameters](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestBody.html) を処理し事前設定するものです。これは、例えば JSON 本文などを取り、クラスのインスタンスで変換することを意味します。今回は、基本クラスを調整して、代わりに DTO のインスタンスを事前設定します。
2. このクラスは `ModelMapper` のスタティック インスタンスを含みます。このインスタンスは DTO をエンティティへマップするために使用されます。
3. このクラスは `EntityManager` のインスタンスを含みます。DTO を介してパスした `id` を基に、既存エンティティのデータベースをクエリできるように、このクラスにエンティティ マネージャを挿入します。
4. `supportsParameter` メソッドを上書きします。このメソッドを上書きせずに、新しいクラスは丁度、基本クラスのように `@RequestBody` パラメータに適用されます。ですから `@DTO` 注釈のみに適用されるように調整する必要があります。
5. `validateIfApplicable` を上書きします。基本クラスはパラメータに `@Valid` または `@Validated` のマークが付いている場合のみ [Bean Validation](http://beanvalidation.org/) を実行します。この動作を変更してすべての DTO に bean validation を適用します。
6. `resolveArgument` を上書きします。これはこの実装で最も重要なメソッドです。このプロセスでそれを調整して `ModelMapper` インスタンスを埋め込み、DTO をエンティティへマップします。しかし、マッピングする前に、新しいエンティティを処理するか、または既存エンティティへ DTO によって提案された変更を適用しなければならないかをチェックします。
7. `readWithMessageConverters` メソッドを上書きします。基本クラスはこのパラメターのタイプを取り、このリクエストをそれのインスタンスに変換します。このメソッドを上書きしてこの変換が `DTO` 注釈で定義されたタイプにし、DTO からエンティティへのマッピングを `resolveArgument` メソッドに残します。
8. `getEntityId` メソッドを定義します。このメソッドは事前設定される DTO のフィールドで反復し、`@Id` のマークが付いているものをチェックします。それが見つかれば、フィールドの値が返され、`resolveArgument` はそれと共にデータベースをクエリできるようになります。

サイズは大きいですが、このクラスの実装を理解するのは難しくありません。要約すると、これは DTO のインスタンスを事前設定し、`@DTO` 注釈で定義され、この DTO のプロパティをエンティティへマップします。これを魅力的にするには、エンティティの新しいインスタンスを常に事前設定する代わりに、まず、データベースから既存エンティティをフェッチする必要があるか否かを見るために DTO に `@Id` プロパティがあるかをチェックします。

この Spring Boot アプリケーションで `DTOModelMapper` クラスをアクティブ化するには、`WebMvcConfigurerAdapter` を拡張して引数リゾルバとしてそれを追加します。次のコンテンツで、`com.questionmarks` パッケージに `WebMvcConfig` と呼ばれるクラスを作りましょう。

```java
package com.questionmarks;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.questionmarks.util.DTOModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import javax.persistence.EntityManager;
import java.util.List;

@Configuration
public class WebMvcConfig extends WebMvcConfigurerAdapter {
    private final ApplicationContext applicationContext;
    private final EntityManager entityManager;

    @Autowired
    public WebMvcConfig(ApplicationContext applicationContext, EntityManager entityManager) {
        this.applicationContext = applicationContext;
        this.entityManager = entityManager;
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
        super.addArgumentResolvers(argumentResolvers);
        ObjectMapper objectMapper = Jackson2ObjectMapperBuilder.json().applicationContext(this.applicationContext).build();
        argumentResolvers.add(new DTOModelMapper(objectMapper, entityManager));
    }
}
```

`WebMvcConfig` 構成クラスのインスタンスが Spring によって作成されると、`ApplicationContext` および `EntityManager` の２つのコンポーネントが挿入されます。後者は `DTOModelMapper` を作るために使用され、前に説明したように、データベースをクエリするのに役立ちます。`ApplicationContext` は [`ObjectMapper`](https://fasterxml.github.io/jackson-databind/javadoc/2.5/com/fasterxml/jackson/databind/ObjectMapper.html) のインスタンスを作るために使用されます。 このマッパーは Java オブジェクト間を変換したり JSON 構造を一致する機能を提供し、`DTOModelMapper` とそのスーパークラス `RequestResponseBodyMethodProcessor` によって必要とされます。

{% include jp-tweet_quote.html quote_text="DTO をエンティティへ自動的に Spring Boot 上にマッピングする" %}

このプロジェクトの `WebMvcConfig` が正しく構成されたので、RESTful API 上の `@DTO` 注釈を利用して自動的に DTO をエンティティへマップします。これを実行するために、試験を作成・更新するリクエストに同意するエンドポイントや、すべての既存の試験をリストにするエンドポイントを表示するコントローラーを作成していきます。このコントローラーを作成する前に、試験の永続化を処理できるようにするクラスを作っていきます。このクラスを `ExamRepository` と呼び、次のコードで `com.questionmarks.persistence` という新しいパッケージを作っていきます。

```java
package com.questionmarks.persistence;

import com.questionmarks.model.Exam;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ExamRepository extends JpaRepository<Exam, Long> {
}
```

`JpaRepository` インターフェイスには `save (Exam exam)`、`findAll ()`、および `delete (Exam exam)` のようなメソッドが含まれていますので、 ほかに実装する必要があるものはありません。よって、このレポジトリ インターフェイスを使用し、上記のエンドポイントを公開するコントローラーを作成できます。`com.questionmarks.controller` と呼ばれる新しいパッケージを作り、それに `ExamRestController` と呼ばれるクラスを追加しましょう。

```java
package com.questionmarks.controller;

import com.questionmarks.model.Exam;
import com.questionmarks.model.dto.ExamCreationDTO;
import com.questionmarks.model.dto.ExamUpdateDTO;
import com.questionmarks.persistence.ExamRepository;
import com.questionmarks.util.DTO;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/exams")
public class ExamRestController {
    private ExamRepository examRepository;

    public ExamRestController(ExamRepository examRepository) {
        this.examRepository = examRepository;
    }

    @GetMapping
    public List<Exam> getExams() {
        return examRepository.findAll();
    }

    @PostMapping
    public void newExam(@DTO(ExamCreationDTO.class) Exam exam) {
        examRepository.save(exam);
    }

    @PutMapping
    @ResponseStatus(HttpStatus.OK)
    public void editExam(@DTO(ExamUpdateDTO.class) Exam exam) {
        examRepository.save(exam);
    }
}
```

このクラスの実装はとても簡単でした。各エンドポイントに１つのメソッドで３つのメソッドを作り、コンストラクターを介して `ExamRepository` インターフェイスを挿入しました。定義された最初のメソッド `getExams` は `GET` リクエストを処理し、例のリストを返すために実装されました。２つめのエンドポイント `newExam` は`ExamCreationDTO` を含む `POST` リクエストを処理し、`DTOModelMapper` の助けで `Exam` の新しいインスタンスに変換するために実装されました。３つめで最後のメソッドは `editExam` と呼ばれ、`PUT` リクエストを処理するエンドポイントとして定義され、`ExamUpdateDTO` オブジェクトを既存の `Exam` インスタンスに変換します。

この最後のメソッドが永続化 `Exam` のインスタンスを見つける DTO を介して送信された `id` を使用し、メソッドを提供する前に３つのプロパティを置換することを強調することが重要です。置換されたプロパティは `title`、`description`、および `editedAt` で、`ExamUpdateDTO` で定義されたとおりです。

IDE を介してまたは `gradle bootRun` コマンドを介してここでアプリケーションを実行すると、このアプリケーションが起動し、ユーザーは生成したエンドポイントとの相互作用が可能になります。次のコマンドのリストは生成した DTO を使って、試験を生成、更新、取得するための [`curl`](https://curl.haxx.se/) の使い方を示します。

```bash
# retrieves all exams
curl http://localhost:8080/exams

# adds a new exam
curl -X POST -H "Content-Type: application/json" -d '{
    "title": "JavaScript",
    "description": "JS developers."
}' http://localhost:8080/exams

# adds another exam while ignoring fields not included in the DTO
curl -X POST -H "Content-Type: application/json" -d '{
    "title": "Python Interview Questions",
    "description": "An exam focused on helping Python developers.",
    "published": true
}' http://localhost:8080/exams

# updates the first exam changing its title and description
curl -X PUT -H "Content-Type: application/json" -d '{
    "id": 1,
    "title": "JavaScript Interview Questions",
    "description": "An exam focused on helping JS developers."
}' http://localhost:8080/exams
```

{% include asides/spring-boot.markdown %}

## 次のステップ：例外処理および I18N

`@DTO` 注釈とそのコンパニオン `DTOModelMapper` を使ってエンティティの実装詳細を簡単に非表示にできるしっかりした基本を構築しました。合わせて、DTO をエンティティへ自動的にマッピングし、これら DTO を介して送信されたデータを検証することで RESTful エンドポイントの開発プロセスをスムーズにします。ここで欠落しているのは、これらの検証期間にスローされた例外や、フライト期間に起きるかもしれない予期されない例外を処理する適切な方法です。

私たちは API を購入する誰もにできるだけ素晴らしい経験を提供したいと願っています。これにはよくフォーマットされたエラー メッセージを与えることも含まれます。それ以上に、私たちは英語以外の他の言語を話すユーザーとコミュニケーションができるようにしたいと思います。よって、次回のアーティクルでは、Spring Boot API で例外の処理や I18N（国際化）に取り組んでいきます。お見逃しなく！