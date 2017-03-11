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

[ここ](https://staruptechnology.esa.io/user/applications) から `Personal access tokens` を取得してください。

## テンプレートカスタマイズ

`template/*.local.md.erb` を作成して env.yml で指定してください。このファイルはgitignoreされています。

## 稼働時間

Slackの分報チャンネルで業務開始時に `開始`、終了時に `終了` と投稿してください。稼働時間が自動的に計算されます。

## 便利な使い方

エイリアス作ると便利。

```
alias nippou='cd /path/to/nippou_gen && bin/nippou'
```
