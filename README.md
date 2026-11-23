# ppt-md-merger 事例集

[ppt-md-merger](https://github.com/hiro77284/ppt-md-merger) を使って PowerPoint 原稿から PDF・Markdown などを作った事例を集めたリポジトリです。
ツール本体の使い方は本体リポジトリを参照してください。

各事例のフォルダには、原稿（pptx）と生成指示書（レシピ yaml）など **入力一式** と、生成結果を GitHub で読める形にした **事例ページ（README.md）** が入っています。
`src/` でレシピを実行すれば、PDF などの生成物はいつでも作り直せます。

## 事例一覧

<!-- BEGIN CASE INDEX -->
<!-- この部分は scripts/build_index.py が生成する。手で書き換えない。 -->

全 2 件

| | 事例 | 概要 | タグ | 確認バージョン |
|---|---|---|---|---|
|  | [pptxで画像＋Markdown一括制作](cases/100-slide-md/)<br>`100-slide-md` | スライドに画像を描き、noteにMarkdownを書いてそれを組み合わせた Markdown 原稿を自動生成する事例です。 | `markdown` `image-crop` | 2.0.6 |
| <img src="cases/101-special-variable/readme-images/101-special-variable-1.webp" width="400" alt=""> | [画像ファイルとMDファイルの命名を自動化](cases/101-special-variable/)<br>`101-special-variable` | スライド番号を使って画像ファイルとMDファイルに自動的にスライドごとに違う名前を付与して、export命令をコピペで済ませる | `export` `ファイル名` | 2.0.6 |

### タグ別

- `export` (1): [101-special-variable](cases/101-special-variable/)
- `image-crop` (1): [100-slide-md](cases/100-slide-md/)
- `markdown` (1): [100-slide-md](cases/100-slide-md/)
- `ファイル名` (1): [101-special-variable](cases/101-special-variable/)

<!-- END CASE INDEX -->

## 事例フォルダの中身

```
cases/NNN-slug/
├── case.yaml         事例のメタデータ（タイトル・概要・タグ・確認バージョンなど）。この一覧の元
├── README.md         事例ページ。ふつうは ppt_build --githubmd --transfer で生成する
├── readme-images/    README.md が参照する画像（transfer が書き出す）
├── thumbnail.png     一覧用のサムネイル（任意。case.yaml の thumbnail で別の画像も指定できる）
└── src/              入力一式: 原稿 pptx・レシピ yaml・COVER_VARS.yaml・表紙 md など
```

`images/`・`mds/`・`temppdfs/`・`build/` は `src/` のレシピを実行すると作られる生成物なので、リポジトリには入れません（`.gitignore` 済み）。
複数の事例で共通に使う設定は [`user_settings/`](user_settings/) に置き、レシピから `../../../user_settings/...` で参照します。

## ダウンロード

GitHub はフォルダ単位でダウンロードできないため、事例ごとの zip を Releases に置く予定です（事例が 10 件前後になったら GitHub Actions で自動化します）。
それまでは、リポジトリ全体を Code → Download ZIP で取得してください。

## 事例の追加

[CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。
