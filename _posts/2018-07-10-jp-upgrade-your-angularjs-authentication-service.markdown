---
layout: post
title: AngularJS 認証サービスをアップグレードする
metatitle: AngularJS 認証サービスをアップグレードする
description: AngularJS から新しい Angular にアプリケーションをアップグレードすることについて学びましょう。そのほかに AngularJS 認証戦略を Angular にするアップグレードについても学びます。
metadescription: AngularJS から新しい Angular にアプリケーションをアップグレードすることについて学びましょう。そのほかに AngularJS 認証戦略を Angular にするアップグレードについても学びます。
date: 2018-07-10 08:30
category: Technical Guide, Angular
post_length: 4
author:
  name: "Sam Julien"
  url: "https://www.upgradingangularjs.com/?ref=auth0"
  avatar: "https://cdn.auth0.com/blog/guest-authors/sam-julien.jpeg"
design:
  bg_color: "#012C6C"
  image: https://cdn.auth0.com/blog/logos/angular.png
tags:
- angular
- angularjs
- ngupgrade
- authentication
- auth0
- ngupgrade
related:
- jp-angular-2-authentication
lang: ja
alternate_locale_en: upgrade-your-angularjs-authentication-service
---

**TL;DR** 本書では、非常に難しいテーマですが、私にとってごく近くて非常に大切なもの ngUpgrade と認証の２つについて話していきます。まず、AngularJS から Angular にアプリケーションをアップグレードする基礎を学びましょう。それから、AngularJS 認証戦略を Angular にアップグレードする実践的な例を見ていきます。機器間認証を使うアプリの例を Auth0 で見ていきます。

{% include jp-tweet_quote.html quote_text="AngularJS から新しい Angular フレームワークに移行する方法を学びましょう。" %}

本書は、[Auth0 オンラインミートアップ](https://www.meetup.com/Auth0-Online-Meetup/)でのトークを基にしています。[トークの動画はこちらから](https://register.gotowebinar.com/register/7495371156540204033)、そして[スライドはこちらから](https://www.upgradingangularjs.com/auth0)アクセスできます。

## ngUpgrade の基礎

2016年後半、私は会社のアプリを AngularJS から Angular にアップグレードしようとして、非常に苦痛な問題を抱えていました。私は完全に圧倒され、まったく何をしていいのか分かりませんでした。怒り狂い、洞窟にこもるよりも、アップグレード プロセスについてできる限りのことを学びながら、その経過をコミュニティのために文書化することに、自分のフラストレーションを向けることにしました。私の動画コース [AngularJS アップグレード](https://www.upgradingangularjs.com/?ref=auth0)はこのような背景から、このプロセスを見つけ出す自分自身の血と汗と涙から来るものです。 私が費やした何百時間という時間によって、皆様の労力と時間を節約することができるように願っております。

また、本書を作成するのは、このような背景から皆様の時間と手間を省くことができればという願いからです。

### **ngUpgrade の背景**

では、背景を少し見てみましょう。AngularJS (1.x) は2018年7月1日、2021年6月31日まで続く[長期的な安定したスケジュール](https://blog.angular.io/stable-angularjs-and-long-term-support-7e077635ee9c)に入りました。この安定した最新バージョンはバージョン 1.7 になります。では、これは私たちに何を委ねることになるのでしょうか？私たちに新しい Angular (2+) が委ねられます。皆さんにはアップグレードが必要かを判断する橋渡しの期間があります。アップグレードが必要であれば、ngUpgrade ライブラリを使ってそのアップグレードを完成させます。

ほとんどの場合は、アップグレードが必要ですが、例外もわずかながらあります。主な例外は、アプリケーションをこれから非アクティブにする場合です。これ以上機能の開発をしないのであれは、アップグレードをする必要はありません。AngularJS パッケージと CDN はこれからもずっと存在するでしょう。レガシ コードが跡形もなく消えて、何もできなくなると心配される必要はありません。

そうは言っても、機能を開発するのであれば、ご自分のためにも Angular に移動するべきです。Angular はずっと高速で、はるかに良い機能やたくさんのアーキテクチャがあり、すでにデータフローのベストプラクティスがフレームワークに織り込まれています。ご心配なく。一度にやる必要はありません。時間をかけて徐々に、正しくやる必要があります。

ほかに、「リアクション/Vue/その他のために、すべてを再書き込みするべきですか？」という質問をよく受けます。ほとんどの場合、それを専門分野とするチームメンバーがいる場合（または何らかの理由で、別のフレームワークに移動したい場合）を除いて、その答えは「ノー」です。別のフレームワークへの移動が簡単という可能性はあまりありません。@angular/upgrade/static パッケージの ngUpgrade ライブラリは AngularJS と Angular との間のギャップを明確に橋渡しするために作られました。React または Vue の同等のライブラリなどありません。

## ngUpgrade のプロセス

アップグレードのプロセスがどのようなものなのか、高レベルで見てみましょう。明確なフェーズが2つあります。

### **フェーズ１：準備**

まず、準備フェーズです。AngularJS の良い点のひとつは可変性が非常に高いということです。AngularJS は簡単なデータ バインディングから複雑なシングルページ アプリケーションまで、たくさんのさまざまな状況で使用できます。

しかし、この可変性には不都合な点があります。ジョン・パパが現れて、すべてを[AngularJS スタイルガイド](https://github.com/johnpapa/angular-styleguide/blob/master/a1/README.md)に成文化するまで、AngularJS のベストプラクティスが収集されることは長い間、ありませんでした。アプリケーションを構成するには可能な方法がたくさんあり、とても分かりにくいので、このコレクションは非常に役立ちました。すべてのアプリケーションが直ちにスタイルガイドに適合するというものではありませんが、ngUpgrade の可能な開始点がたくさんあるということです。「すべてに当てはまる」ソリューションなどありません。このため、ngUpgrade プロセスの一環として AngularJS コードをベストプラクティスに適合させます。

準備フェーズは ngUpgrade プロセスへの４つの  **文書パーツ** から成ります：

- **ファイル構造** 。ここではスタイルガイドに従って、２つの重要な点があります。まず、ファイルをタイプ別ではなく、機能別に整理することです。次に、ファイルあたりに１つのアイテムのみを持つことです。
- **依存関係** 。ひところ、コミュニティはどのようにして依存関係を最適に管理するかによって分かれていました。今では、パッケージや依存関係を管理する最適な方法として、npm (または yarn) に決めています（Bower ではありません）。また、最初バージョンの AngularJS（5 バージョン以降、できれば最新のものが好ましい）を使用する必要があります。
- **アーキテクチャ** 。AngularJS 1.5 はコンポーネント API を導入したので、コンポーネントアーキテクチャの対応が可能になります。アプリケーションをコンポーネントアーキテクチャに移動することは準備フェーズの一環です。AngularJS 1.5 はライフサイクルフックや単方向データバインディングのようなものも導入しました。アップグレードするとき、コントローラーをコンポーネントと置換してその他 $scope のインスタンスをすべて取り除きます。ngUpgrade を使い始める前からすべてを最高の形にする必要はありませんが、AngularJS または Angular のどちらを使おうとも最終的なものはコンポーネントアーキテクチャです。コンポーネントに近ければ近いほど、アップグレードもより簡単になります。
- **ビルド**** プロセス**。ビルドプロセスはすべてのアプリケーションをコンパイルして ngUpgrade ライブラリの準備をするツールです。実際には、これはモジュールバンドルに Webpack やコードに Typescript を使用することを意味します。つまり、Gulp および Grunt のようなスクリプトタグまたはタスクランナーを ES6 モジュールと置換することです。今回の目標はいつか、Angular CLI に移動できるように、Angular ツールに正確に沿ったツールにすることです。

CLI と言えば、 レガシ アプリケーションで今すぐそれを使用できるのであれば、是非そのようにしてください。特定の場合ですが、CLI をすぐにプロジェクトにアップグレードできないことがあります。コードの構造が整理されていないで一貫性がなかったり、非常にカスタマイズされたビルド プロセスだったりします。このような場合、アプリケーションが CLI にフィットするように、少なくともコードやアーキテクチャをクリーンアップするまで待つ必要があります。CLI はどのようにコードを整理するかについての自説が非常に強く、独自のビルドプロセスをコントロールします。これは長期的に素晴らしく、AngularJS の初期の問題を解決しますが、古いパターンを使用する大きなアプリケーションで作業する場合はフラストレーションになることがあります。

これら４つの文書パーツを通して作業することについて、もうひとつあります。これは必ずしも線形プロセスではありません。ngUpgrade に移動し始める前に、すべてが完璧である必要はありません。特に、アーキテクチャの部分は時間をかけて行ったり、アップグレードプロセスと同時に行うことができます。アプリケーションの大きさがどれくらいか、機能開発やバグ修正をしながら、技術的負債を通して作業する能力がどれくらいあるかによって決まります。依存関係が最新であることのほかに、唯一本当に重要なことは、ngUpgrade を使用してアプリケーションを移動し始めるためにはモジュールバンドラーと TypeScript が本当に必要なので、 _ビルド プロセス_ です。

### **フェーズ2：アップグレードをする**

では、アップグレードのフェーズについて話しましょう。このフェーズには３つの異なるパートがあります。

まず、 **インストールとセットアップ** です。Angular と ngUpgrade のすべてのパッケージをインストールし、両方のフレームワークをブートストラップして一緒に同時に実行します（ここでは詳しく取り扱いませんが、Scotch.io に詳しい投稿を書きましたので、皆さんのお役に立てればと思います）。

２つめは  **移行プロセス** です。これは徐々にアプリケーションの部分が Angular に移動するループで、ngUpgrade を使って Angular と AngularJS のコードとお互いに対話できるようにします。これにはさまざまなアプローチがありますが、ほとんどの方はルートを選んで、アプリケーションの構造によって下部か上部から始めます。一般的に、依存関係数が最も少ないアイテムから最も多いアイテムのものに移動します。例えば、ルートのサービスから始めて、それからコンポーネントを通して徐々に築き上げていきます。

この移行プロセスは必要なだけ時間をかけることができます。私は ngUpgrade のアプリケーションをすべてセットアップしてから、Angular にあるすべての新しい機能に制限を設定するのが好きです。それから、新しい機能を Angular に追加するとき、必然的にコード ベースのほかの部分に触れていきます。それに取り掛かっているとき、それらの部分を再書き込みしてそれを通して徐々に築き上げていくので、開発サイクルが自然なプロセスになります。

最後に、ルーティングはアプリケーションのブレインなので、最後に残します。すべてを Angular に再書き込みしてから、旧モデルの AngularJS ルーターを新しい Angular ルーターと交換します。

給料を受け取りたいのであれば、このプロセスのどこかで、このコードを作業に展開する必要があります。 **作業のためにコードをセットアップ** しなければなりません。これは、 AOT（Ahead of Time）コンパイルと呼ばれる Angular の静的コンパイルプロセスを利用する必要があることを意味します。Angular は Just in Time (JIT) コンパイルモードと Ahead of Time (AOT) コンパイルモードの２つのモードが実行できます。

コンパイラは Angular ライブラリのかなりの部分を取ります。開発中のとき JIT コンパイルを使うので、ブラウザーに送信するとき、プロセスのためのコードだけではなく、ブラウザーで使用するコードを変換するコンパイラコードを含んで送信するので、データはずっと大きくなります。

![The compiler takes up a big chunk of Angular.](https://cdn.auth0.com/blog/ngupgrade/compiler-chunk.png)

AOT コンパイルプロセスを使うとき、すべてが事前にコンパイルされ、コンパイラコード自身はバンドルに入れる必要はありません。

このようにする理由は、セキュリティの強化などたくさんありますが、基本は AOT が JIT よりも小さく速いので、制作に有利です。AOT の Webpack をセットアップする方法については、[私が書いた本書をチェックしてください](https://medium.com/@UpgradingAJS/the-ultimate-guide-to-setting-up-aot-for-ngupgrade-without-jumping-out-a-window-998df2fdd196)。また、[このコースで扱うセットアップ方法](https://www.upgradingangularjs.com/?ref=auth0)についてのステップバイステップの動画もあります。

これでアップグレードプロセスの異なる部分について把握したので、フェーズ２の **移行プロセス** の実例を見てみましょう。

## サンプル アプリケーション

[コースのサンプルプロジェクトのアップデートされたフォークをクローンしてください](https://github.com/upgradingangularjs/ordersystem-evergreen)（`npm install` または `yarn install` を `server` および `public` フォルダの両方で実行することを忘れないでください）。以下のコマンドを実行して Auth0 ブランチと開始コミットを確認してください：

```bash
git checkout auth0
git checkout c6b2055f831134b616452ad3319309817ab9d574
```

この基本的な注文システムのアプリケーションは AngularJS 1.6 および Angular 5 でハイブリッドアプリケーションとして出発しました（このチュートリアルで取り扱うものは Angular 6 のものとは違いませんので、ご心配なく）。まったくファンシーではありませんが、AngularJS の実社会で見てきた拡張可能なパターンの一部を使用するように作りました。

### **最新認証のセットアップ**

Express サーバーは機器間の API とクライアント関係で、Auth0 でセットアップします。ユーザーログインのシステムはその複雑さの層がひとつ多いので、私は機器間で使用しており、この目的のため実際は、あまり重要ではありません。ここで重要なのは、トークンを取得する機能で、データを取得できるために発信リクエストにそれを加えます。それがユーザーに固有か、またはアプリケーションに固有かは重要ではありません（また、Auth0 を使用するとき、本書のアプローチはあらゆるトークン システムに適用します）。

顧客ルートや製品ルートの２つのルートを認証で使用します。これは、顧客のルートは Angular コンポーネントおよびサービスを使用しますが、製品のルートはまだ AngularJS の部分を使用します。そこでアプローチやアップグレードの仕方の両方を見ることができます。

これに従うには、このサーバーはローカルで実行するだけなので、機器間の API とアプリケーションをセットアップする Auth0 を使用する必要があります。これは Auth0 ダッシュボードから実行できます。まず、[API を作成](https://auth0.com/docs/quickstart/backend/nodejs)してから、機器間アプリケーションとしてアプリケーションを作成します。

![Machine to machine application.](https://cdn.auth0.com/blog/ngupgrade/machine-to-machine-auth0-api.png)

作ったばかりのアプリケーションを使用するためにこの API アプリケーションを接続します。

Auth0 セットアップが終わったら、API 情報と以下を置換するために `server/auth.js` を編集します：

```js
const checkJwt = jwt({
  secret: jwksRsa.expressJwtSecret({
    cache: true,
    rateLimit: true,
    jwksRequestsPerMinute: 5,
    jwksUri: `https://samjulien.auth0.com/.well-known/jwks.json`// <-- 置換します
  }),

  // 対象ユーザーと発行元を検証します。
  audience: 'ordersystem-api', // <-- 置換します
  issuer: `https://samjulien.auth0.com/`, // <-- 置換します
  algorithms: ['RS256']
});
```

`authVariables.js` と呼ばれるファイルをプロジェクトのルートに追加し、変数としてアプリケーションのクライアント ID とクライアント シークレットを以下のようにエクスポートします：

```js
export const CLIENT\_ID = '[client id here]';
export const CLIENT\_SECRET = '[client secret here]';
```

AngularJS AuthService はトークンを API から取得するためにそのファイルを使用します。

`src` フォルダーの内側にあるクライアント側（ `public` フォルダー）に、 `app.run.ajs.ts` と呼ばれるファイルがあります。このファイルには、次のように認証済みかチェックし、認証されていなければトークンを取得する認証サービスと呼ばれる機能が含まれています：

```typescript
runAuth.$inject = ['authService'];

export function runAuth(authService) {
  if (!authService.isAuthenticated()) authService.getToken();
}
```

この機能は `app.module.ajs.ts` の `angular.module().run()` を使って AngularJS モジュールに追加されます。

トークンを送信リクエストに追加するために、AngularJS $http プロバイダー（`auth.interceptor.ajs.ts`）用の HTTP インターセプターがあります。ローカル ストレージからトークンを取得してから、リクエストが送信される前に、ベアラー トークンを承認ヘッダーに追加します。

まだ AngularJS にある認証サービス（`./shared/authService.ts`）は Auth0 （サービスを通して）からトークンを取得してからそのトークンをローカル ストレージにセットします。

これが動作しているかを確認するには、ターミナルを開き、 `server` フォルダー内の `npm start` を実行します。それから、別のターミナルを開き、`public` フォルダー内の `npm run dev` を実行します。[localhost:9000](localhost:9000) に移動し、Chrome 開発者ツールを開き、Customers タブをクリックします。トークンは次のようにヘッダーとして送信リクエストに追加されていることが分かります：

![The Authorization header on the customer's request.](https://cdn.auth0.com/blog/ngupgrade/authorization-header.png)

Express サーバーを呼び出す `/products` の認証にも使用する Products タブで同じように実行します。

もちろん、これはトークンを認証する非常にシンプルな方法です。エラー処理を追加するなど、これはもっと複雑なたくさんの方法ですることができますが、ここでは基本的なコンセプトをご理解ください。

### **Angular インターセプターを追加する**

このセットアップにはひとつの問題があります。（`./customers/customer.service.ts` の） CustomerService の getCustomers 呼び出しは実際は不正行為です：

```typescript
getCustomers(): Observable<Customer[]> {
  return this.http.get<Customer[]>('/api/customers', {
    headers: { Authorization: `Bearer ${localStorage.access_token}` }
  });
}
```

ここでは、インターセプターを使用しないで、手動でヘッダーを追加します。これをコメントアウトするには、Webpack に再度バンドルさせて、トークンはリクエストにアタッチしなくなるので、顧客データを取得できなくなります。

これはなぜでしょうか？AngularJS の $http と Angular の HttpClient はお互いにやりとりしません。このギャップを何とか橋渡ししなければなりません。このためには、HttpClient のインターセプターを Angular に書き込みます。

インターセプターを追加するために、`auth.interceptor.ts` と呼ばれるソース フォルダーのルートに新しいファイルを作成しましょう。そのファイル内に、次のように新しいクラスを追加します：

```typescript
import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';
import { Observable } from 'rxjs/Observable';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor() {}
  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    request = request.clone({
      setHeaders: {
        Authorization: `Bearer ${localStorage.access_token}`
      }
    });
    return next.handle(request);
  }
}
```

HttpRequest や HttpHandler、HttpClient から数点をインポートし、 RxJS から Observable をインポートします（注：このアプリは RxJS 5 を使って作成されたので、本書では古いインポートスタイルを使います）。それから intercept機能を 持つことで HttpInterceptor インターフェイスを実装します。この機能は AngularJS インターセプターのものとかなり似ています。リクエストをクローンして、ローカル ストレージからのアクセストークンでヘッダーをセットします。

このステップを完成するには、これをプロバイダーとして Angular モジュール（`app.module.ts`）に追加する必要があります。Angular の HTTP\_INTERCEPTORS と新規インターセプターをインポートしてから、次のように特殊プロバイダーを providers アレイに追加します：

```typescript
// ファイルの先頭に追加します
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { AuthInterceptor } from './auth.interceptor';

// Providers アレイ内
{
  provide: HTTP_INTERCEPTORS,
  useClass: AuthInterceptor,
  multi: true
}
```

では、構成オブジェクトを `getCustomers` コールから削除し、すべてを保存し、Webpack に再度バンドルさせます。正しいヘッダーはリクエストにまだ追加されるので、データが正しく読み込まれているかを確認します。

[このセクションの完了済コードはこちら](https://github.com/upgradingangularjs/ordersystem-evergreen/commit/77283ef3d8e9ebe4b5ac883430313f3268543d03/)からご覧ください。

詳細のクイックポイント：すべてのサービスが Angular への変換が終わるまで、AngularJS インターセプターをなくさないでください。Angular の HttpClient インターセプターは AngularJS サービスでは使用できません。

### **Angular の APP\_INITIALIZER を利用する**

HttpClient インターセプターを使って Angular サービスを取得しました。これは良いですが、問題が多少あります。トークンの取得をセットアップする方法に遅延が生じます。ローカル ストレージからトークンを削除して、顧客ルート上でリフレッシュすると、トークンが解決する前に顧客コールがされるのが分かります：

![We’re trying to get the customers data before the token resolves!](https://cdn.auth0.com/blog/ngupgrade/wrong-flow.png)

トークンが解決する前に顧客データを入手しようとしていますそれは良くありません。

約束を解決する方法で AngularJS コードのこれを修正することができますが、もっと良い方法があります。これは ngUpgrade を通して作業し実現する実例で、現在のコードを再書き込みするか、オリジナルのコードに戻って AngularJS コードでもっと時間を費やす必要があるかを判断する必要があります。

ほとんどの場合は、AngularJS の部分から離れ、Angular に実装することをお勧めします。ここで AngularJS run block を Angular で `APP_INITIALIZER` と呼ばれるものと置換してすぐに実行します。そのために、いくつかのことを実行する必要があります。まず、認証サービスを Angular に再書き込みします。それから、それをダウングレードして AngularJS アプリケーションに提供し、AngularJS 認証ルートがまだ機能するようにします。最後に、アプリケーションがスピンアップするときに `APP_INITIALIZER` を使って AuthService をコールします。

#### **ANGULAR サービスに再書き込みする**

この部分を始めるには、このコミットを確認してください：

```bash
git checkout abd3e34cbbaa8bbed004f56796d37e7ed28f73e2
```

このコミットでは、アプリ実行ブロックや認証サービスに対してリファクターを少し行います。実行機能では、`isAuthenticated` を確認したそのビットを移動し、その責任を認証サービスに移動しました。

このサービスを Angular に再書き込みしましょう。このサービスはすでに ES6 クラスなので、ステップは多くはありません。まず auth.service.ts に名前を変更して規則によく従います。ここで、ファイルの先頭にこれら２つのインポートを追加します：

```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
```

`@Injectable()` デコレータをそのクラスの上に追加します。

次に、すべてのレファレンスを http で $http に名前を変更します（検索と置換を使うと作業が簡単になります）。コンストラクターでは、http のプライベートインスタンスは次の HttpClient タイプであることを指定します：

```typescript
constructor(private http: HttpClient) { }
```

TypeScript が `.then` のあらゆるインスタンスをグリップしていることを確認します。これは、HttpClient は Promise の代わりに Observable を返すからです。ngUpgrade でとても役立つ戦略のひとつは直ぐに Observable を対処しないことです。私は Observable が大好きですが、実社会の実稼働アプリケーションを使っているときは、必ずしも直ぐに Observable に行くというものではありません。再有効化はほとんどの方にとって真新しいパターンであることを考えて、その方法を容易にする必要がある場合があります。これは Observable を Promise に変換してすべてが機能していることを確認し、その Promise をリファクタリングして後で Observable にに戻して行うことができます。ここでは、実例の目的のために、このようにします。

これらを次のようにファイルの先頭に追加します：

```typescript
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';
```

（再び、これは RxJS 5 インポート方法ですが、ご自由に RxJS 6 を使用して rxjs から Observable へ、`rxjs/operators` から `toPromise` へインポートをアップデートします。）

ここで `.then` の前にすべてのコールに `.toPromise()` を追加し、再度  TypeScript を満足させます。 HttpClient は応答本文のデータを返すのに十分なので、リターンの .data を削除することもできます。

以下を確認します：

```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/toPromise';

import { CLIENT_ID, CLIENT_SECRET } from '../../../authVariables';

@Injectable()
export class AuthService {
  constructor(private http: HttpClient) {}

  getToken() {
    if (!this.hasToken() || !this.isAuthenticated()) {
      const url = 'https://samjulien.auth0.com/oauth/token';
      const body = `{
        "client_id":"${CLIENT_ID}",
        "client_secret":"${CLIENT_SECRET}",
        "audience":"ordersystem-api",
        "grant_type":"client_credentials"}`;
      const options = { headers: { 'content-type': 'application/json' } };
      return this.http
        .post(url, body, options)
        .toPromise()
        .then(response => {
          this.setSession(response);
        });
    }
  }

  // 変更なし
  isAuthenticated() { ... }

  // 変更なし
  hasToken() { ... }

  // 変更なし
  setSession(authResult) { ... }
}
```

信じられないような話ですが、このサービスを Angular に再書き込みするにはこれだけです。ローカル ストレージ API でさえも同じです。まんざら悪くないですよね。これでそれを Angular モジュールに追加します。`app.module.ts` を開き、上部の AuthService をインポートし、AuthService をプロバイダーアレイに追加します。

```typescript
// 下の CreateOrderComponent をインポートします
import { AuthService } from './shared/auth.service';

// プロバイダーアレイをアップデートします
providers: [
    CustomerService,
    OrderService,
    locationServiceProvider,
    productServiceProvider,
    addressServiceProvider,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    },
    AuthService
  ]
```

AngularJS コードがそのサービスに確実にアクセスできるようにするにはどうしたらいいでしょうか？そこで ngUpgrade が関与します。ngUpgrade の `downgradeInjectable` 機能を AngularJS モジュールで使用し、この Angular サービスがレガシ コードに使用できるゆようにします。

`app.module.ajs.ts` を開きます。まず、ファイルの名前を変更したので、上部のインポートを修正します。それから、サービスを登録している場所で、それをファクトリに変更し、そのダウングレード機能を丁度、`OrderService` および `CustomerService` のように使用します：

```typescript
// 修正されたインポート
import { AuthService } from './shared/auth.service';

// ...その間のその他のコンテンツ
angular
  .module(MODULE_NAME, ['ngRoute'])
// ...その他の登録
  .factory('authService', downgradeInjectable(AuthService));
```

いいですね。アプリケーションのバンドルと読み込みが正しく処理されているかなど、すべてが同様に機能するかも確認します。良くできました！

[ここまでで完成したコードはこちら](https://github.com/upgradingangularjs/ordersystem-evergreen/commit/e4464a42734213d02c95a743a1062224a6572b8d)。

#### **実行時間でトークンを取得する**

ここからは楽しい部分です。AngularJS のアプリ実行機能を削除し、それを新しい Angular `APP_INITIALIZER` と置換します。Angular モジュールに戻りましょう。機能を Angular のファクトリとして提供します。これを NgModule デコレータの上に貼り付けます：

```typescript
export function get_token(authService: AuthService) {
  return () => authService.getToken();
}
```

この機能は `AuthService` を挿入し、その `getToken` 機能を呼び出します。ここで APP\_INITIALIZER を使用してこの機能を立ち上げ時に呼び出すファクトリを提供します。この新しいオブジェクトをインターセプターと `providers` アレイの `AuthService` の後に追加します。

```typescript
{
  provide: APP_INITIALIZER,
  useFactory: get_token,
  deps: [AuthService],
  multi: true
}
```

`NgModule`（`core` から）をインポートするライン上の `import` プロパティに `APP_INITIALIZER` も追加する必要があります。

これを実行してみましょう。AngularJS モジュール（`app.module.ajs.ts`）の `run` 登録機能をコメントアウトし、すべてのコンパイルとバンドルを確認します。それから、ブラウザーに移動します。確実にスタートから開始するために Chrome 開発者ツールを使ってアプリケーション記憶域を消去して、そのページをリフレッシュします。どのルートであっても、これが機能することを確認します。Customers タブで実行して Angular で確認し、それから Products タブで実行して AngularJS で確認します。インターセプターがそれを使って呼び出す前に、トークンが呼び出され、読み込まれることを確認します。素晴らしい！

これを終えるには、AngularJS モジュールから run 機能とそれのインポートを削除し、app.run.ajs.ts ファイルを削除します。[完成したコードはこちらからご覧ください](https://github.com/upgradingangularjs/ordersystem-evergreen/commit/e0fd2ec2ecac606ce59948ea86a84f5ad5cc8996)。

{% include jp-tweet_quote.html quote_text="AngularJS アプリを新しい Angular フレームワークにアップグレードすることについての本書をご覧ください。" %}

## 本書の内容

ではまとめてみましょう。アプリ実行ブロックから始めました。これは、トークンを取得するサービスを呼び出し、インターセプターを使ってトークンをリクエストにアタッチします。これはすべて AngularJS で実行しましたから、カスタマーサービスで機能しなかったら、Angular HttpClient はそのインターセプターを使用できません。これを修正するために、独自の Angular インターセプターを追加しました。

このインターセプターは役立ちましたが、トークンの取得にタイム ラグがあったので、十分ではありませんでした。Angular がランタイムでトークンを実行できる方法を見つける必要があります。そのためには、まず認証サービスを Angular に再書き込みします。それから、APP\_INITIALIZER 機能およびプロバイダーを追加しました。

このデモンストレーションは数点のことを提供しました。まず、AngularJS と Angular コードはお互いに自動的にやりとりしません。これらは並列に実行するので、そのギャップを橋渡しするために ngUpgrade を使用する必要があります。次に、できるだけ再書き込みをし、できるときにダウングレードしてください。Promise を修正したり、ルートをもっと高度にしたりして AngularJS コードに取り組んでトークンのタイミング問題を修正することができました。この問題の解決方法は Angular に再書き込みするだけで解決できるという簡単なものでした。レガシ コードをアップデートすることにできる限りあまり努力をし過ぎないようにしてください。AngularJS コードを再書き込みするときは一度にひとつづつやるようにしてください。

こをするときに困ったら、私がご質問にお答えします。[200 個以上の詳細ビデオ、質問クイズなど総合的なアップグレードのコースを用意しております](https://www.upgradingangularjs.com/?ref=auth0)。毎日、一般的な開発者のために作成しており、最高の ngUpgrade リソースです。Eメールでご登録いただきますと、無料の Upgrade Roadmap Checklist をお送りします。アップグレードの準備をお見逃しなく！また、完全でもも用意しておりますので、ご確認ください。

では、次回もよろしくお願いします！
