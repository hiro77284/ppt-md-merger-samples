<!--
PDF（typst）の既定の表紙（パッケージ同梱）。旧 LaTeX 版の standard_cover_wideimage(_with_footerimage).tex と
同じ構成を、Typst 用に書き起こしたもの。

レシピで pandoc.cover-md: cover_standard.md と書くとこれを使う（名前だけで同梱を探す。version 3 以前は
typst-cover-md）。旧名 cover_standard_typst.md はエラー（2026-11-16 から受け付けない）。
version 2 以前のレシピでは、typst-cover-md を省略し cover-md か conditional-process-input
（LaTeX 用の表紙）があるときにも暗黙に使う（非推奨。version 3 以降では使わない）。
レシピ vars の COVER_* を使い、{{#if:NAME}} … {{#endif:NAME}} で値が空の項目を省く。
画像は Markdown の画像記法で書く。レシピ dir 基準で見つかれば merge.image-dir にコピーし（merge.copy-images が有効なとき）、
見つからなければ typst-images.lua が resource-path から探す。
文字の大きさは LaTeX 版（\Huge / \LARGE / \large）を和文スケール 0.962 で縮めた値。
空き（#v）は基準 PDF（lualatex 版）の位置に合わせて調整してある。

使う変数（vars）:
COVER_IMAGE トップ画像
COVER_TITLE タイトル文字列
COVER_SUBTITLE サブタイトル文字列
COVER_AUTHOR　著者
COVER_AFFILIATION　所属
COVER_CONTACT　連絡先
COVER_NOTE　説明文
COVER_FOOTERIMAGE　フッター画像

-->

```{=typst}
#v(16mm)
```

::: {.center}
![](images/cover_image.webp){width=80%}

:::

```{=typst}
#v(22.7mm)
```

```{=typst}
#align(center, text(font: sem-fonts.sans, weight: "bold", size: 23.9pt)[
```

PDF生成時に表紙と目次をつける方法

```{=typst}
])
```

```{=typst}
#v(-1mm)
#align(center, text(size: 16.6pt)[
```

Markdown からPDFを生成するときに{{BR}}表紙と目次をつける方法の解説とサンプル

```{=typst}
])
```

```{=typst}
#v(7.4mm)
#align(center, text(size: 11.5pt)[
```

作成日：2026-11-28 13:24:43

```{=typst}
])
#v(6mm)
#align(center, text(size: 11.5pt)[
```

著者：開米瑞浩

所属：アイデアクラフト

```{=typst}
])
```


```{=typst}
#v(10mm)
```

indexer.pptxnumbering の設定で表紙と目次をつける方法を指定できます。

```{=typst}
#v(10mm)
```

::: {.center}
![](images/cover_footerimage.webp){width=80%}
:::
