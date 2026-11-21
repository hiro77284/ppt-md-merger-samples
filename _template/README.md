<!--
事例ページ（雛形）。

ふつうはこのファイルを手で書かず、src/ のレシピに transfer: を設定して
  ppt_build <レシピ> --githubmd --transfer --pdf --yes-clear-dir
を実行し、生成された GitHub 向け Markdown で上書きする（画像は readme-images/ に入る）。
最初のスライドの note に「この事例で何ができるか」「何を書けばよいか」を書いておくと、そのまま事例ページの冒頭になる。

ビルドせずに手書きする場合は、以下の見出しを埋める。
-->
# <事例タイトル>

## この事例でできること

## 入力（src/）

| ファイル | 内容 |
|---|---|
| `<NAME>.pptx` | 原稿。本文はスライドの note に Markdown で書く |
| `<NAME>_pdf_recipe.yaml` | 生成指示書（レシピ） |

## 生成手順

```
cd src
ppt_build <NAME>_pdf_recipe.yaml --githubmd --transfer --pdf --yes-clear-dir
```

## ポイント
