<!-- source: ../mds/103-page-space_slide1.md -->
<!-- md_merge_rawtitle: ページとスペースの調整 -->
<!-- #id:chapter:AUTOHEAD:1 -->
# 1) ページとスペースの調整

:::{.center}
:::{.widequote width="0.7\\linewidth"}
Markdown文書をPDF化する際にページとスペースを調整するための insertvfill,insertpagebreak,insetmdpages,vspace 等の使用方法を解説します。
:::
:::

{{vspace:2}}

:::{.center}
:::{.widequote width="0.8\\linewidth"}
- 1.1) PDF資料作成時に改ページと余白を調整したい
- 1.2) 改ページ・伸縮空白・固定空白
- 1.3) 表紙と目次をつけるためのレシピYAML
- 1.4) 原稿PPTXの note での空行制御
- 1.5) 生成処理の実行
- 1.6) ソースPPTX、生成指示YAML、および成果物MDとPDF
:::
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide2.md -->
<!-- md_merge_rawtitle: PDF資料作成時に改ページと余白を調整したい -->
<!-- #id:section:AUTOHEAD:2 -->
## 1.1) PDF資料作成時に改ページと余白を調整したい

原稿PPTXから切り出した個別MDを単純に結合してPDF化すると、よくこんな現象（下図左）が起きます。 複数の個別MDコンテンツがぎっしり詰め込まれる、という状態です。

デジタルデータを閲覧するだけのMDコンテンツであればスペースをあまり気にしないものですが、研修教材を紙媒体で配布するときは

- 受講者がメモするスペース
- 話題の切替を明示する方法

として、スペースは非常に重要です。 したがって、下図右のように改ページとスペースをコントロールできる必要があります。

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide2.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide3.md -->
<!-- md_merge_rawtitle: 改ページ・伸縮空白・固定空白 -->
<!-- #id:section:AUTOHEAD:3 -->
## 1.2) 改ページ・伸縮空白・固定空白

具体的には３種類の命令を駆使して改ページとスペースを調整します。

「固定空白」 は 、「１行分空ける」　「２行分空ける」　「10mm空ける」 のように、量を明示して空ける命令です。

それに対して 「伸縮空白」 は、言い換えると 「残り全部空ける」 です。 下図右ではＤの後に伸縮空白がありますが、これは 「改ページまでの残りを全部空ける」 働きをします。 下図左ではＡとＢの後、2箇所に伸縮空白があり、 「改ページまでの残り全部を等分する」 形になります。 C～D間は固定空白ですが、A～B間は伸縮空白なのでレイアウトが変わるわけです。

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide3.webp){ width=100% }
:::

{{vspace:1}}

では、実際にこの改ページとスペースの命令を説明します。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide4.md -->
<!-- md_merge_rawtitle: 表紙と目次をつけるためのレシピYAML -->
<!-- #id:section:AUTOHEAD:4 -->
## 1.3) 表紙と目次をつけるためのレシピYAML

具体的な使用例です。

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide4.webp){ width=100% }
:::

レシピYAMLの procedure セクションで、insertmd 命令の間に改ページと空白調整命令を挿入します。

{{vspace:1}}

[insertvspace]{.term} : 固定空白です。数値のみ書くと行単位の空白になり、 10mm のように距離単位を明示することもできます。 小数点以下の数値 (0.5 と書くと0.5行分)も使用可能で、負値は1とみなします。

[insertvfill]{.term} : 伸縮空白です。 「残り全部空ける」 動作をします。

[insertpagebreak]{.term} : 改ページです。

[insertvfillpagebreak]{.term} : insetvfill + insertpagebreak をセットで行う短縮形です。version 2.1.1 以降で使用できます。

[insertmdpages]{.term} : 間に insertvfill + insertpagebreak を挟みながら、複数のMDを一括挿入します。 MDファイル1つにつき１ページずつ使いたい場合に重宝します。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide5.md -->
<!-- md_merge_rawtitle: 原稿PPTXの note での空行制御 -->
<!-- #id:section:AUTOHEAD:5 -->
## 1.4) 原稿PPTXの note での空行制御

原稿PPTXのMDテキスト上で空白行を空けるときは、vspace 命令を使います。

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide5.webp){ width=100% }
:::

vspace の実際の使用例を下記に示します。この内容は原稿PPTXとPDFを照らし合わせて確認してください。

↓↓PDF上では5行分の空行になります。

{{vspace:5}}

↑↑PDF上では5行分の空行になります。

↓↓PDF上では「残り全部空ける」空行になります。

{{vfill}}

PDF上ではこの行がこのページの最下段行になります。

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide6.md -->
<!-- md_merge_rawtitle: 生成処理の実行 -->
<!-- #id:section:AUTOHEAD:6 -->
## 1.5) 生成処理の実行

以下の命令で生成を実行します。サブコマンド ppt_build の引数に生成指示書を指定します。

{{vspace:1}}

```bash
cd cases\103-page-space\src
pptmdmerge ppt_build 103-page-space_recipe.yaml
```

{{vspace:1}}

「WARNING: YAML ファイルが見つかりません」 という警告は出ても問題ありません。

この命令で生成されるのは renderedfilename で指定する Rendered MD です。

オプションを追加すると、PDFやGitHubMDも生成します。

{{vspace:1}}

```bash
cd cases\103-page-space\src
pptmdmerge ppt_build 103-page-space_recipe.yaml --pdf --github --transfer
```

{{vspace:1}}

[オプションなし]{.term} Rendered MD のみ生成する

[--pdf]{.term} Rendered MD をもとにPDFを生成する

[--github]{.term} Rendered MD をもとにGitHub用MDを生成する

[--transfer]{.term} 生成したMDを他の場所に転送するオプション。当サンプルでは、GitHubMD をもとに README.md を作るために使用する。

Rendered, PDF, GitHubMD 等の関係については次項の図をご覧ください。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide7.md -->
<!-- md_merge_rawtitle: ソースPPTX、生成指示YAML、および成果物MDとPDF -->
<!-- #id:section:AUTOHEAD:7 -->
## 1.6) ソースPPTX、生成指示YAML、および成果物MDとPDF

当サンプルのソースと成果物を以下のリンクで確認できます。

<!-- #id:subsection:AUTOHEAD:8 -->
### 1.6.1) ソース

[生成指示]{.term} [103-page-space_recipe.yaml](src/103-page-space_recipe.yaml)

[原稿PPTX]{.term} [103-page-space.pptx](src/103-page-space.pptx)


<!-- #id:subsection:AUTOHEAD:9 -->
### 1.6.2) 成果物

MDは何種類か異なる仕様で生成します。 Rendered MDはPPTXソースから切り出したMDにさまざまな加工を加えた生成物で、豊富な書式指示を含んでいます。 それらの書式指示をすべて落として GitHub での表示に特化したのがGitHub用MDです。

[Rendered MD]{.term} [103-page-space_target_rendered.md](build/103-page-space_target_rendered.md)

[GitHub用MD]{.term} [103-page-space_target_github.md](build/103-page-space_target_github.md)

[PDF]{.term} [103-page-space_target.pdf](build/103-page-space_target.pdf)

[README]{.term} このファイルです

::: {.center}
![](images/103-page-space_slide7.webp){ width=100% }
:::

当サンプルはPDF化時に改ページ、スペース調整を行うサンプルですので、「PDF」 のpdfを開いてそれらの状態を確認し、次いで 生成指示YAMLを開いて procedure セクションと照らし合わせて確認してください。 

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide8.md -->
<!-- md_merge_rawtitle: 実使用例 -->
<!-- #id:chapter:AUTOHEAD:10 -->
# 2) 実使用例

:::{.center}
:::{.widequote width="0.7\\linewidth"}
この章はページとスペースの調整を実際に使った例です。 PDF版でのみ意味を持つので、PDFで確認してください。レシピYAMLの記述とPDFのレイアウトを照らし合わせてください。
:::
:::

{{vspace:2}}

:::{.center}
:::{.widequote width="0.8\\linewidth"}
- 2.1) Contents A
- 2.2) Contents B
- 2.3) Contents C
- 2.4) Contents D
- 2.5) Contents E
- 2.6) Contents F
- 2.7) Contents G
:::
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide9.md -->
<!-- md_merge_rawtitle: Contents A -->
<!-- #id:section:AUTOHEAD:11 -->
## 2.1) Contents A

contents A

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide9.webp){ width=100% }
:::

{{vfill}}

<!-- source: ../mds/103-page-space_slide10.md -->
<!-- md_merge_rawtitle: Contents B -->
<!-- #id:section:AUTOHEAD:12 -->
## 2.2) Contents B

contents B

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide10.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide11.md -->
<!-- md_merge_rawtitle: Contents C -->
<!-- #id:section:AUTOHEAD:13 -->
## 2.3) Contents C

contents C

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide11.webp){ width=100% }
:::

{{vspace:2}}

<!-- source: ../mds/103-page-space_slide12.md -->
<!-- md_merge_rawtitle: Contents D -->
<!-- #id:section:AUTOHEAD:14 -->
## 2.4) Contents D

contents D

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide12.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide13.md -->
<!-- md_merge_rawtitle: Contents E -->
<!-- #id:section:AUTOHEAD:15 -->
## 2.5) Contents E

contents E

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide13.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide14.md -->
<!-- md_merge_rawtitle: Contents F -->
<!-- #id:section:AUTOHEAD:16 -->
## 2.6) Contents F

contents F

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide14.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/103-page-space_slide15.md -->
<!-- md_merge_rawtitle: Contents G -->
<!-- #id:section:AUTOHEAD:17 -->
## 2.7) Contents G

contents G

{{vspace:1}}

::: {.center}
![](images/103-page-space_slide15.webp){ width=100% }
:::