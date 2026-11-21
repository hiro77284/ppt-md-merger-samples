# 事例の追加手順

1. `_template/` を `cases/NNN-slug/` にコピーする
   - `NNN` は連番（3桁）、`slug` は英小文字・数字・`-`（例: `002-chapter-cover`）
2. `src/` に入力一式を置く
   - 原稿 pptx、レシピ yaml、`COVER_VARS.yaml`、表紙 md、挿入用のサンプル pptx など
   - 雛形のレシピ `src/NAME_pdf_recipe.yaml` は NAME を原稿名に置き換えて使う（不要なら削除）
   - 1つの事例でしか使わない設定は `src/` に、2つ以上で使う設定は `user_settings/` に置く
3. `src/` でビルドし、事例ページを生成する
   ```
   cd cases/NNN-slug/src
   ppt_build NAME_pdf_recipe.yaml --githubmd --transfer --pdf --yes-clear-dir
   ```
   `../README.md` と `../readme-images/` が書き出される。手書きする場合は `_template/README.md` の見出しを埋める
4. `case.yml` を書く（項目の説明は `_template/case.yml`）
   - `ppt_md_merger_version` には、手順 3 で実際に使ったバージョン（`pip show ppt-md-merger` 等で確認）を書く
5. 一覧を更新する
   ```
   python scripts/build_index.py
   ```
6. `git status` で `images/`・`mds/`・`temppdfs/`・`build/` が入っていないことを確認してコミットする

## 事例に入れないもの

- 生成物（`images/`・`mds/`・`temppdfs/`・`build/`・`log.txt`）。`src/` から作り直せるため
- 顧客名・社内文書名・個人のローカルパス（`D:\...` など）。原稿 pptx の note やプロパティにも残っていないか確認する

## 推奨タグ

一覧のタグ別索引に使うので、できるだけ次の語から選ぶ。足りなければ追加してよい（英小文字・`-`）。

| タグ | 意味 |
|---|---|
| `pdf` | PDF を生成する |
| `githubmd` / `puremd` / `html` | それぞれの形式を生成する |
| `pptmerge` | 複数の pptx を 1つに結合する |
| `cover` | 表紙を付ける |
| `toc` | 目次を付ける |
| `numbering` | 章節番号・図番号を付ける |
| `image-crop` | スライドから画像を切り出す |
| `animation` | アニメーション（マルチステップ）を扱う |
| `vars` | 変数置換・条件分岐を使う |
| `stylebase` | スタイルベースで見た目を揃える |
