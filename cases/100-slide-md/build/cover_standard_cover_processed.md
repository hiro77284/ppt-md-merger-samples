<!--
engine: typst の既定の表紙（パッケージ同梱）。standard_cover_wideimage(_with_footerimage).tex と
同じ構成を、Typst 用に書き起こしたもの。

pandoc.typst-cover-md を省略し、cover-md か conditional-process-input（LaTeX 用の表紙）が
指定されているレシピでは、engine: typst のときにこれを使う。
レシピ vars の COVER_* を使い、{{#if:NAME}} … {{#endif:NAME}} で値が空の項目を省く。
画像は Markdown の画像記法で書く（typst-images.lua が resource-path から探す）。
文字の大きさは LaTeX 版（\Huge / \LARGE / \large）を和文スケール 0.962 で縮めた値。
空き（#v）は基準 PDF（lualatex 版）の位置に合わせて調整してある。

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


```{=typst}
#align(center, text(font: sem-fonts.sans, weight: "bold", size: 23.9pt)[
```

パワポで画像とMarkdownを一括制作

```{=typst}
])
```

```{=typst}
#v(-1mm)
#align(center, text(size: 16.6pt)[
```

技術解説画像入りMarkdown制作のメンドクササを解消

```{=typst}
])
```

```{=typst}
#v(7.4mm)
#align(center, text(size: 11.5pt)[
```

作成日：2026-11-25 17:22:49

```{=typst}
])
#v(6mm)
#align(center, text(size: 11.5pt)[
```

著者：開米瑞浩


```{=typst}
])
```


```{=typst}
#v(10mm)
```

スライドに画像を描き、noteにMarkdownを書いてそれを組み合わせた Markdown 原稿を自動生成する事例です。

