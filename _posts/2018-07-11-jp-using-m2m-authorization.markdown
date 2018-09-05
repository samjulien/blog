---
layout: post
title: 機器間（M2M）認証を使用する
metatitle: 機器間（M2M）認証を使用する
description: クライアント資格情報の付与と Auth0 を使って非対話型アプリを設定して IoT デバイス、CLI tool ツール、機関間 API 認証を実装する方法。
metadescription: クライアント資格情報の付与と Auth0 を使って非対話型アプリを設定して IoT デバイス、CLI tool ツール、機関間 API 認証を実装する方法。
date: 2018-07-11 08:30
category: Technical Guide, Identity
post_length: 2
author:
  name: Sebastián Peyrott
  url: https://twitter.com/speyrott?lang=en
  mail: speyrott@auth0.com
  avatar: https://en.gravatar.com/userimage/92476393/001c9ddc5ceb9829b6aaf24f5d28502a.png?size=200
design:
  image: https://cdn.auth0.com/blog/m2m/machine-to-machine-authorization-logo.png
  bg_color: "#222228"
tags:
- auth
- authentication
- authorization
- m2m
- machine
- machine-to-machine
- machine-2-machine
- api
- non-interactive
- cli
- service
- daemon
- backend
related:
- 2016-10-17-jp-sso-login-key-benefits-and-implementation
- 2016-12-05-jp-how-saml-authentication-works
- 2017-06-22-jp-developing-restful-apis-with-kotlin
lang: ja
alternate_locale_en: using-m2m-authorization
---

自律システムのさまざまなパーツ間で、セキュアに許可された通信チャネルが必要とされることがよくあります。さまざまな会社の２つのバックエンドサービスがインターネットを通して通信していることを考えてください。このような場合、OAuth 2.0 は [_クライアント資格情報の付与_](https://tools.ietf.org/html/rfc6749)フローを提供します。この投稿では、[_OAuth 2.0_](https://tools.ietf.org/html/rfc6749) から与えられたクライアント資格情報と Auth0 をどのようにして[_機器間の通信_](https://auth0.com/docs/applications/machine-to-machine)で使用するかについて見ていきます。

{% include jp-tweet_quote.html quote_text="Auth0 で機器間の認証を使用する方法を学びましょう！" %}

この投稿でサンプルの[_コードを取得_](https://github.com/auth0-samples/auth0-api-auth-samples)してください。

## 機器間通信

サービス間、デーモンとバックエンド間、CLI クライアントと内部サービス間、[_IoT_](https://auth0.com/blog/javascript-for-microcontrollers-and-iot-part-1/) ツール間など機器間通信が意味をなすシステムのパーツがたくさんあります。これら通信の主なアスペクトは、システムで信頼を築く要素は*クライアント* であるという事実に基づいています。これはどういう意味でしょうか？承認プロセスが*ユーザー* を認証することで信頼を築こうとする通常のシステムとは対照的に、この場合認証して信頼しなければならないものはクライアントです。つまり、ユーザーが認証するシステムで対話する必要はなく、むしろシステムが*クライアント* を認証し、承認しなければなりません。.明確に言うと、この場合、クライアントは単なるアプリケーション、プロセスであり、自律システムでさえあります。このようなシナリオの場合、ユーザー名とパスワード、ソーシャルログインなど一般的な認証スキームは意味をなしません。

OAuth 2.0 の [クライアント認証情報の付与] はこれらシナリオのニーズを満たそうとします。クライアント資格情報の付与では、クライアントはクライアント ID とクライアント シークレットの２つの情報を保留します。この情報で、クライアントは保護されたリソースのアクセストークンをリクエストできます。

![Client Credentials Grant](https://cdn.auth0.com/blog/jp-using-m2m-authorization/jp-client-credentials-grant.png)

1. このクライアントは `client ID` や `client secret`、`audience` のほかにクレームを送信する認証サービスへリクエストします。
2. この認証サービスはリクエストを検証し、成功すれば、アクセストークンと応答を送信します。
3. クライアントはリソースサーバーから保護されたリソースをリクエストするためにアクセストークンを使うことができます。

このクライアントはクライアントシークレットをいつも保留しなければならないので、この付与は*信頼された* クライアントのみで使用されることを意味します。つまり、*クライアントシークレット* を保留するクライアントは必ず、そのシークレットが誤用されないリスクがない場所で使用しなければなりません。例えば、Web 中のレポートをシステムのさまざまなパーツに送信する内部デーモンでクライアント資格情報の付与を使用するのはいい考えですが、外部ユーザーが GitHub からダウンロードできるパブリックツールを使うことはできません。

## クライアント資格情報の付与

クライアント資格情報の付与を使うのはとても簡単です。以下は関連性の高い HTTP リクエストです：

```
POST https://<YOUR_AUTH0_DOMAIN>/oauth/token
Content-Type: application/json
{
  "audience": "<API_IDENTIFIER>",
  "grant_type": "client_credentials",
  "client_id": "<YOUR_CLIENT_ID>",
  "client_secret": "<YOUR_CLIENT_SECRET>"
}
```

成功する認証リクエストは次のような応答を生じます：

```
HTTP/1.1 200 OK
Content-Type: application/json
{
  "access_token": "eyJz93a...k4laUWw",
  "token_type": "Bearer",
  "expires_in": 86400
}
```

Auth0 では、クライアント資格情報の付与を使用するには、[_ダッシュボードから新しい「機器間」アプリケーションを作成します：_](https://auth0.com/docs/applications/machine-to-machine)

![Machine to Machine in the Auth0 Dashboard](https://cdn.auth0.com/blog/m2m/2-create.png)

機器間アプリケーションは少なくても1つの API を選択する必要があります。これは、上記の HTTP リクエストの `audience` クレームを通して選択する API です。

![Select API in the Auth0 Dashboard](https://cdn.auth0.com/blog/m2m/3-select-api.png)

Auth0 ダッシュボードの [_API_](https://manage.auth0.com/) セクションで API および保護されたリソース用のユーザー対象を作ります。アプリケーションの `API` タブでこれら API タブを有効または無効にします。

### Auth0 の細分性アクセス許可

[_Auth0 __でルール_](https://auth0.com/docs/rules/current)を使用したため、機器間通信に細分性アクセス許可を設けるのはとても簡単です。あるクライアントがクライアント資格情報の付与を使用するとき、ルールは `scopes` または `roles` を含むそのリクエストのデータチェックを実行できます。この情報で、そのリクエストを付与したり拒否したりできます。

{% include jp-tweet_quote.html quote_text="Auth0 ルールで、機器間認証でさえもさらに強力な細分性のアクセス許可を設けることができます。" %}

ルールはリクエストが行われるたびに実行するコードの小さな一部です。これらは可変性が高く、強力です。これらルーツは次のようなものです：

```javascript
function (user, context, callback) {
  if (context.clientID === "BANNED_CLIENT_ID") {
    return callback(new UnauthorizedError('このアプリケーションへのアクセス許可は一時的に取り消されました'));
  }

  callback(null, user, context);
}
```

このルールでは、固有のクライアント ID は拒否されました。ルールは JavaScript コードなので、アクセス許可または認証の複合ロジックをアプリに追加できます。

ルールの可変性が必要ないのであれば、スコープで細分性レベルを達成することができます。これらは API あたり、アプリケーション/クライアントベースあたりで有効にできます。

## M2M 通信の一般的な使用

本セクションでは、M2M 通信が意味をなす場合の一般的なシナリオを見ていきます。

### バンクエンド間（サービス間/デーモン間）

これは最も一般的なシナリオのひとつです。ログのフォームにデータを生成する異なる内部サービスがあるとします。これらログをデータ ウェアハウスのローカルに格納します。ただし、ポリシーの一環として、これらログをコールド ストレージ ソリューションのオフサイトに格納することにします。これらログを別のクラウド プロバイダーのコールド ストレージ ソリューションにインターネットで送信します。別のサービスのログ格納をネットワークで承認するには、クライアント資格情報の付与を使い、各クライアントにクライアント ID やクライアントシークレットを与えます。

![Machine to Machine Logging](https://cdn.auth0.com/blog/jp-using-m2m-authorization/jp-3-backend-to-backend.png)

ジョブ スケジューラやデーモン、継続的なプロセスのようなその他一般的なサービスはどうでしょうか？これらは機器間認証が意味をなす場合にも素晴らしいシナリオです。ジョブ スケジューラがネットワークにあるとしますが、GPU 処理の素晴らしい取引を提供する違うクラウド プロバイダーによるものです。承認済のクライアントだけがそのサービスを使えるようにしたいと考えています。このため、クライアント資格情報の付与を使い、許可したいクライアント ID だけを承認します。.

### モノのインターネット (IoT) 機器

[_モノのインターネット__ (IoT) __機器_](https://auth0.com/blog/javascript-for-microcontrollers-and-iot-part-1/)の増加は器機間ソリューションの素晴らしいケースです。.IoT 機器の多く（ほとんどでなければ）は、小型、自律、特殊デバイスでデータを収集し、サーバーに送信します。駐車場に駐車している車の番号のデータを収集するために使用する小型の IoT 機器が多数あるとします。セントラルサーバーにデータを報告し続ける機器がたくさんあります。これら器機は WiFi 接続で通信します。侵入を避けるために、その WiFi がパスワード保護されていたとしても、クライアント資格情報の付与を使い、各 IoT 機器に独自のクライアント ID とクライアントシークレットを与えます。これら器機は自分でセットアップし、誰もそれらと対話できないので、信頼されています。

### CLI クライアント

システムが大きくなると、オートメーションがどんどん道理にかなうようになります。反復的で、管理者の監督を必要とする多くの作業はスクリプトになり始めています。これらスクリプトは管理者が実行する必要があるときに実行されます。これらスクリプトは会社のアーキテクチャの重要な部分と対話するので、通常何らかの保護があります。このような場合、管理者は操作を実行するときに必要な権利がある CLI アプリを作成するかもしれませんが、自分のものやメインフレームなど特定のコンピュータだけが使用できます。このような場合も、クライアント資格情報の付与が道理にかないます。これら CLI アプリは信頼されていますが、システムの重要な部分にもアクセスする必要があります。クライアント ID やクライアントシークレットを要求することで、システムの重要な部分へのアクセスを保護することはひとつのソリューションです。

## コード例：ギフト配信アプリ

実社会のシナリオに適用できるコードに興味がある方には、その目的のサンプルアプリがあります。[_ギフト配信アプリ_](https://github.com/auth0-samples/auth0-api-auth-samples/tree/master/machine-to-machine)では同じ会社の２つのバックエンド・サービスがクライアント資格情報の付与を使用してしっかりと対話する方法を表示しています。

このアプリでは、あるサービス [_World Mappers API_](https://github.com/auth0-samples/auth0-api-auth-samples/tree/master/machine-to-machine/worldmappers-api-nodejs) は座標、アドレス、方向を見つけるために使用する API を公開し、別のサービス [_ギフト配信サービス_](https://github.com/auth0-samples/auth0-api-auth-samples/tree/master/machine-to-machine/giftdeliveries-nodejs)が `World Mappers API` を使ってある地点から接続先のアドレス（ギフトを送信する）への方向を取得します。

![Gift Deliveries App](https://cdn.auth0.com/blog/m2m/4-gift-deliveries-app.png)

これら両方のサービスはオンラインショップの内部ネットワークで実行するので、`Gift Deliveries` クライアントは信頼されたクライアントで、クライアント資格情報の付与を使用することができます。

`Giftdeliveries-nodejs/index.js` ファイルをご覧いただくと、クライアント資格情報の付与を使用するアクセストークンを取得するコードがあります：

```javascript
var getAccessToken = function(callback) {
  if (!env('AUTH0_DOMAIN')) {
    callback(new Error('AUTH0_DOMAIN はアクセストークンを取得するために必要です（構成を検証します）'));
  }

  logger.debug('Fetching access token from https://' + env('AUTH0_DOMAIN') + '/oauth/token');

  var options = {
    method: 'POST',
    url: 'https://' + env('AUTH0_DOMAIN') + '/oauth/token',
    headers: {
      'cache-control': 'no-cache',
      'content-type': 'application/json'
    },
    body: {
      audience: env('RESOURCE_SERVER'),
      grant_type: 'client_credentials',
      client_id: env('AUTH0_CLIENT_ID'),
      client_secret: env('AUTH0_CLIENT_SECRET')
    },
    json: true
  };

  request(options, function(err, res, body) {
    if (err || res.statusCode < 200 || res.statusCode >= 300) {
      return callback(res && res.body || err);
    }

    callback(null, body.access_token);
  });
}
```

このアプリを実行する場合、[_無料__ Auth0 __アカウントに登録_](https://auth0.com/signup)し、[_レポジトリ_](https://github.com/auth0-samples/auth0-api-auth-samples)を複製し、[_説明ファイル_](https://github.com/auth0-samples/auth0-api-auth-samples/blob/master/machine-to-machine/README.md)に従ってください。

## まとめ

機器間通信はほとんどどんなモダンアーキテクチャにも必要です。OAuth 2.0 および Auth0 はアーキテクチャで容易に使用できるように構築ブロックを提供します。バックエンド間からサービス間、デーモン間、IoT機器間、そして CLI ツール間でさえ、クライアント資格情報の付与は自律や非自律システム間での認証問題に対するシンプルで、有効なアプローチです。この付与はルールのパワーを増大し、すべての一般的な使用に適用され、将来細分性の高いセキュリティが必要なときの可変性が維持されます。製品に機器間通信を使用する場合、またはその使用にご興味がある方は、所定欄にコメントをご記入ください。ご使用のアーキテクチャにどのように適用されるか分からない場合は、[_ホームページの「営業担当者に連絡」ボタンをクリックしてください_](https://auth0.com/)。喜んでご質問にお答えいたします