# nippou_gen
日報ジェネレーター

## 使い方

example をコピーして env.yml を作ってください。
```
cp config/env.yml.example config/env.yml
```

`bin/nippou` コマンドを実行すると日報 Markdown が作成され、Vim で開かれます。 Vim を終了すると日報が esa.io に Ship It! されます。

## How to get Slack Token

[ここ](https://api.slack.com/custom-integrations/legacy-tokens) から `Create token` をしてください。

## How to get GitHub Token

[ここ](https://github.com/settings/tokens) から `Generate new token` をしてください。 `repo` に権限つけてください。

## How to get esa.io Token

[ここ](https://staruptechnology.esa.io/user/applications) から `Personal access tokens` を取得してください。 `write` に権限をつけてください。

## How to get Google Calendar API Token etc.

[ここ](https://console.developers.google.com) から Calendar API を使うように設定した Project を作成し、OAuth 2.0 クライアントID/Secret を発行してください。
初回（またはトークンの有効期限が切れた状態で）プログラムを実行すると、OAuth認証のためのURLが発行されるので、ブラウザでURLにアクセスしてOAuth認証を通しましょう。
一度認証が完了すると tmp/google_tokens.yaml に保存されるので、有効期限が切れるまで再度入力する必要はなくなります。

## テンプレートカスタマイズ

`templates/*.local.md.erb` を作成して env.yml で指定してください。このファイルはgitignoreされています。

## 稼働時間

Slackの分報チャンネルで業務開始時に `開始`、終了時に `終了` と投稿してください。稼働時間が自動的に計算されます。

## 便利な使い方

エイリアス作ると便利。

```sh
alias nippou='cd /path/to/nippou_gen && bin/nippou'
```

```vimrc
"alias
command Check %s/\[ \]/[x]/c
command Uncheck %s/\[x\]/[ ]/c
```
