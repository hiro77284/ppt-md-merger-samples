<!-- source: ../mds/100-slide-md1.md -->
<!-- md_merge_rawtitle: パワポスライドにMDテキストをつけて一括合成 -->
<!-- #id:section:100-slide-md:slide1 -->
## パワポスライドにMDテキストをつけて一括合成

技術解説文書を書くときは、要点箇条書きスライドだけでは足りません。精密な図解に加えて文章による詳細解説も必要なのが普通です。

そこで欲しくなるのが図解入りMarkdownファイルです。

本書はPPTXで図解＋Markdownを制作した後、それを自動的に分解結合して１つの長い図解入りMarkdownファイルを作るサンプルです。

{{vspace:1}}

::: {.center}
![](images/100-slide1.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/100-slide-md2.md -->
<!-- md_merge_rawtitle: スライドに図を書き、noteにMarkdownを書く -->
<!-- #id:section:100-slide-md:slide2 -->
## スライドに図を書き、noteにMarkdownを書く

基本的なしくみは、スライドに図を書いてnoteにMarkdownを書き、Markdownテキスト内で図を参照するというものです。

{{vspace:1}}

::: {.center}
![](images/100-slide2.webp){ width=100% }
:::

{{vspace:1}}

noteというのはPowerPointファイル(PPTX)のスライドごとに付属する、文章でちょっとしたメモ書きを書いておける領域です。そこに図の詳細解説をMarkdownで書きます。

このときに一定の書式を使うことで、Markdown中でスライドの図を参照します。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/100-slide-md3.md -->
<!-- md_merge_rawtitle: 長方形シェイプを使って画像切り出し範囲を示す -->
<!-- #id:section:100-slide-md:slide3 -->
## 長方形シェイプを使って画像切り出し範囲を示す

スライド側では、切り出したい画像の背後に切り出し範囲を示す長方形シェイプを置き、そこに名前をつけます。 
シェイプに名前をつけるには、シェイプ選択後に 「編集→選択→オブジェクトの選択と表示」 で出てくる名前を変更します。

他のシェイプと区別できればどんな名前でもかまいませんが、当サンプルでは例として exportrange という名前を使います。

{{vspace:1}}

::: {.center}
![](images/100-slide3.webp){ width=100% }
:::

{{vspace:1}}

ppt-md-merger はこの範囲を単独の画像ファイルとして自動的に切り出します。それをMarkdownテキストで参照すればよいわけです。

では次に Markdownテキスト側の書き方を確認しましょう。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/100-slide-md4.md -->
<!-- md_merge_rawtitle: noteに画像切り出し指示とMarkdownを書く -->
<!-- #id:section:100-slide-md:slide4 -->
## noteに画像切り出し指示とMarkdownを書く

note側に画像切り出し指示とMarkdownを書きます。

1行目の "NOTE_CONTENT_FORMAT: 1.0" は、この note の内容を ppt-md-merger への指示として解析しろ、という命令です。

note のテキストは "===BLOCK===" で区切り、各ブロックの1行目は "{{BLOCK:*}}" の書式でブロックの種類を示します。

"{{BLOCK:IMAGE}}" はそのブロックが画像切り出し指示であることを意味します。ここで、画像として切り出す範囲 exportrange と、ファイル名（パス）も指定します。

{{vspace:1}}

::: {.center}
![](images/100-slide4.webp){ width=100% }
:::

{{vspace:1}}

"{{BLOCK:MD}}" はそのブロックがMarkdownテキストであることを意味します。 出力するMarkdownファイルのパスを "export-note" で指定します。

次の行から次のブロックまで（またはnote末尾まで)をMarkdownテキストとして出力します。

このMarkdownテキストの中に画像参照コードを書くことで、切り出したスライド画像を参照できます。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/100-slide-md5.md -->
<!-- md_merge_rawtitle: ソースPPTX、生成指示YAML、および成果物MDとPDF -->
<!-- #id:section:100-slide-md:slide5 -->
## ソースPPTX、生成指示YAML、および成果物MDとPDF

当サンプルのソースと成果物を以下のリンクで確認できます。

### ソース

[生成指示]{.term} [100-slide-md_pdf_recipe.yaml](src/100-slide-md_pdf_recipe.yaml)

[画像とMD]{.term} [100-slide-md.pptx](src/100-slide-md.pptx)


### 成果物

MDは何種類か異なる仕様で生成します。 Rendered MDはPPTXソースから切り出したMDにさまざまな加工を加えた生成物で、豊富な書式指示を含んでいます。 それらの書式指示をすべて落として GitHub での表示に特化したのがGitHub用MDです。

[Rendered MD]{.term} [100-slide-md-target-rendered.md](build/100-slide-md-target-rendered.md)

[GitHub用MD]{.term} [100-slide-md-target-github.md](build/100-slide-md-target-github.md)

[PDF]{.term} [100-slide-md-target.pdf](build/100-slide-md-target.pdf)

::: {.center}
![](images/100-slide5.webp){ width=100% }
:::

当サンプルは主に 「PPTXに画像とMDを記載できる」 ことを説明するサンプルですので、「画像とMD」 のpptxを開いて画像とMDのブロックを確認し、それが 「Rendered」 MDでどのようになっているかを確認してみてください。