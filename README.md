# ppt-md-merger 事例集

[ppt-md-merger](https://github.com/hiro77284/ppt-md-merger) を使って PowerPoint 原稿から PDF・Markdown などを作った事例を集めたリポジトリです。
ツール本体の使い方は本体リポジトリを参照してください。

各事例のフォルダには、原稿（pptx）と生成指示書（レシピ yaml）など **入力一式** と、生成結果を GitHub で読める形にした **事例ページ（README.md）** が入っています。
`src/` でレシピを実行すれば、PDF などの生成物はいつでも作り直せます。

## 事例一覧

<!-- BEGIN CASE INDEX -->
<!-- この部分は scripts/build_index.py が生成する。手で書き換えない。 -->

全 1 件

| | 事例 | 概要 | タグ | 確認バージョン |
|---|---|---|---|---|
| <img src="cases/001-pdf1-minimum/readme-images/pdf1-minimum-slide3.webp" width="160" alt=""> | [1つの PPTX をまるごと PDF にする最小事例](cases/001-pdf1-minimum/)<br>`001-pdf1-minimum` | スライドの note に本文 Markdown を書き、生成指示 YAML 1枚で表紙・目次つきの PDF を作る、いちばん単純な構成の事例。 | `pdf` `cover` `toc` `image-crop` | 2.0.6 |

### タグ別

- `cover` (1): [001-pdf1-minimum](cases/001-pdf1-minimum/)
- `image-crop` (1): [001-pdf1-minimum](cases/001-pdf1-minimum/)
- `pdf` (1): [001-pdf1-minimum](cases/001-pdf1-minimum/)
- `toc` (1): [001-pdf1-minimum](cases/001-pdf1-minimum/)

<!-- END CASE INDEX -->

## 事例フォルダの中身

```
cases/NNN-slug/
├── case.yml          事例のメタデータ（タイトル・概要・タグ・確認バージョンなど）。この一覧の元
├── README.md         事例ページ。ふつうは ppt_build --githubmd --transfer で生成する
├── readme-images/    README.md が参照する画像（transfer が書き出す）
├── thumbnail.png     一覧用のサムネイル（任意。case.yml の thumbnail で別の画像も指定できる）
└── src/              入力一式: 原稿 pptx・レシピ yaml・COVER_VARS.yaml・表紙 md など
```

`images/`・`mds/`・`temppdfs/`・`build/` は `src/` のレシピを実行すると作られる生成物なので、リポジトリには入れません（`.gitignore` 済み）。
複数の事例で共通に使う設定は [`user_settings/`](user_settings/) に置き、レシピから `../../../user_settings/...` で参照します。

## ダウンロード

GitHub はフォルダ単位でダウンロードできないため、事例ごとの zip を Releases に置く予定です（事例が 10 件前後になったら GitHub Actions で自動化します）。
それまでは、リポジトリ全体を Code → Download ZIP で取得してください。

## 事例の追加

[CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。
