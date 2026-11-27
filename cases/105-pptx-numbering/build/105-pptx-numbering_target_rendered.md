<!-- source: ../mds/105-pptx-numbering_slide1.md -->
<!-- md_merge_rawtitle: PPTXへの章節番号付番のみ(PDF化しない) -->
<!-- #id:chapter:105-pptx-numbering:slide1 -->
# 1) PPTXへの章節番号付番のみ(PDF化しない)

:::{.center}
:::{.widequote width="0.7\\linewidth"}
MarkdownやPDF出力を行わず、PPTXへの章節番号付番のみ行う方法を解説します。
:::
:::

{{vspace:2}}

:::{.center}
:::{.widequote width="0.8\\linewidth"}
- 1.1) 単にPPTXに章節番号をつけたいだけ
- 1.2) 複数のPPTXをひとつにまとめて章節番号をつけたい
- 1.3) 基本は「章・節」方式
- 1.4) CHAPT マーカーで章を切替える
- 1.5) 章とびら無しなら CHAPT と SECTION を書く
- 1.6) 番号カウントの抑制
- 1.7) 番号付与の抑制
- 1.8) PPTXのみの番号付与を行うレシピYAML
- 1.9) 注意！　MD、PDF生成時はchapt_sectionは使えない
- 1.10) 注意！　付番されるのは「タイトル」属性を持つシェイプのみ
- 1.11) 生成処理の実行
- 1.12) ソースPPTX、生成指示YAML、および成果物PPTX
:::
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide2.md -->
<!-- md_merge_rawtitle: 単にPPTXに章節番号をつけたいだけ -->
<!-- #id:section:105-pptx-numbering:slide2 -->
## 1.1) 単にPPTXに章節番号をつけたいだけ

大きなPPTXを作っているとよく遭遇するのが、 「単に章・節番号をつけたいだけなのに自動的にできない」 という問題です。

Word にはアウトラインで自動的に章・節・項以下の番号を振る機能がありますが、それに該当する機能がPowerPointにはありません。 そこでやむなく手作業で番号を振るのはなかなかにうんざりする作業です。

{{vspace:1}}

::: {.center}
![](images/105-pptx-numbering_slide2.webp){ width=80% }
:::

{{vspace:1}}

作者は必要に迫られて何度となくこの作業をやりましたが、率直に言って 「もうやりたくねえ！」 というのが本音です。 

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide3.md -->
<!-- md_merge_rawtitle: 複数のPPTXをひとつにまとめて章節番号をつけたい -->
<!-- #id:section:105-pptx-numbering:slide3 -->
## 1.2) 複数のPPTXをひとつにまとめて章節番号をつけたい

さらに、元ネタになるPPTXが複数あって、それらをまとめて1つの長いPPTXを作り、そこに付番したいというケースもよくあります。

{{vspace:1}}

::: {.center}
![](images/105-pptx-numbering_slide3.webp){ width=80% }
:::

{{vspace:1}}

単純なタスクではありますが、それだけにやりたくない作業です。 なんとか結合と付番を自動的に行う方法はないのでしょうか？　というわけで ppt-md-merger にはその機能もつけました。この機能は画像やMarkdownの切り出し、結合、PDF化等を行わないので、noteを書く必要もなく、レシピYAMLの設定も簡単です。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide4.md -->
<!-- md_merge_rawtitle: 基本は「章・節」方式 -->
<!-- #id:section:105-pptx-numbering:slide4 -->
## 1.3) 基本は「章・節」方式

基本的なしくみとしては、章・節 の2階層でスライドタイトルに番号を付与します。 PowerPoint の一般的な用法では 「節」 に該当するスライドを書く比率が最も高いと思われるため、節番号は何もしなくても自動的に増えていく仕様です。

{{vspace:1}}

::: {.center}
![](images/105-pptx-numbering_slide4.webp){ width=100% }
:::

では、章が変わるときはどうすればよいのでしょうか？

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide5.md -->
<!-- md_merge_rawtitle: CHAPT マーカーで章を切替える -->
<!-- #id:section:105-pptx-numbering:slide5 -->
## 1.4) CHAPT マーカーで章を切替える

新しい章の最初のスライドのどこかに CHAPT というマーカー文字列を書いておきます（実際は '#' 記号で挟んで書きます)。すると自動付番後は章番号が変わり、マーカーは消えます。

次のスライドからは再び節番号が増えていくようになります。

{{vspace:1}}

::: {.center}
![](images/105-pptx-numbering_slide5.webp){ width=100% }
:::

ただしこれは 「章とびら」 を置くスタイルです。 章とびらは 「その章全体の概要を示すページ」 であり、節とは異質なページなので番号仕様も "2)" のように章番号だけを使います。

一方、編集方針によっては章とびらを置かずに、1.2) からいきなり 2.1) へ変わるようなスタイルもあります。その場合はどうすればよいのでしょうか？

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide6.md -->
<!-- md_merge_rawtitle: 章とびら無しなら CHAPT と SECTION を書く -->
<!-- #id:section:105-pptx-numbering:slide6 -->
## 1.5) 章とびら無しなら CHAPT と SECTION を書く

章とびらを置かないスタイルの時は、新章開始スライドで CHAPT と SECTION の両方を書くと、章とびらなしで節から始まります。(SECTION を単独で使うと、節番号を1にリセットします）

{{vspace:1}}

::: {.center}
![](images/105-pptx-numbering_slide6.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide7.md -->
<!-- md_merge_rawtitle: 番号カウントの抑制 -->
<!-- #id:section:105-pptx-numbering:slide7 -->
## 1.6) 番号カウントの抑制

番号のカウントアップを止めたい場合は STAY と書きます。 複数のスライドに同一番号を付与したい場合に使います。 

{{vspace:1}}

::: {.center}
![](images/105-pptx-numbering_slide7.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide8.md -->
<!-- md_merge_rawtitle: 番号付与の抑制 -->
<!-- #id:section:105-pptx-numbering:slide8 -->
## 1.7) 番号付与の抑制

一部のスライドに番号を付与しない場合は NONUMBERING と書きます。 そのスライドでのみ、タイトルへの番号付与が止まります。 ただし番号カウントアップ自体は行うので、「抜け番」がある状態になります。

{{vspace:1}}

::: {.center}
![](images/105-pptx-numbering_slide8.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide9.md -->
<!-- md_merge_rawtitle: PPTXのみの番号付与を行うレシピYAML -->
<!-- #id:section:105-pptx-numbering:slide9 -->
## 1.8) PPTXのみの番号付与を行うレシピYAML

PPTXのみの番号付与を行うレシピYAMLの例です。 PDF関係の設定は必要ありません。

{{vspace:1}}

::: {.center}
![](images/105-pptx-numbering_slide9.webp){ width=100% }
:::

{{vspace:1}}

indexer.pptxnumbering: に　"chapt_section" を指定します。

output.pptxfilename: に、最終生成されるPPTXファイル名を指定してください。 原稿PPTXとダブらないようにします。

force: true は既存ファイルがあっても上書きします。

procedure.insertPPTX: に原稿PPTXを指定します。

全スライドを出力する場合は slides: all です。一部のスライドのみ必要な場合は、 1-99 のような From-to 記法か、 1,2,5,6 とカンマで区切って列挙してください。　3-END と書くと、3番目以降全部になります。 ただし -END という記法の最大値は既定で99なので、それを超えるスライド数がある場合は range-max で明示します。

原稿PPTXは複数あってもかまいません。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide10.md -->
<!-- md_merge_rawtitle: 注意！ MD、PDF生成時はchapt_sectionは使えない -->
<!-- #id:section:105-pptx-numbering:slide10 -->
## 1.9) 注意！　MD、PDF生成時はchapt_sectionは使えない

::: {.warning}
chapt_section方式が使えるのは、PDFのみを生成する場合です。MD、PDFも生成するときは idresolve を使ってください。
:::

::: {.center}
![](images/105-pptx-numbering_slide10.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide11.md -->
<!-- md_merge_rawtitle: 注意！ 付番されるのは「タイトル」属性を持つシェイプのみ -->
<!-- #id:section:105-pptx-numbering:slide11 -->
## 1.10) 注意！　付番されるのは「タイトル」属性を持つシェイプのみ

::: {.warning}
付番されるのは「タイトル」属性を持つシェイプのみ
:::

::: {.center}
![](images/105-pptx-numbering_slide11.webp){ width=100% }
:::

シェイプ（PowerPointの図形）の中にはスライドごとに1つ、タイトル属性を持つものがあります。 未入力時に 「タイトルを入力」 というガイドメッセージが出るものがそれです。 通常、新スライドを追加すると一番上にあって目立ちますね。

ppt-md-merger の番号付番はタイトルシェイプに対して行うので、それがないときは付番されません。　いったんタイトルシェイプを削除して、代わりに同じ位置に長方形シェイプを置くと、一見タイトルに見えてもそれはタイトル属性を持たないただの長方形なので付番されません。

タイトルシェイプをコピペしてもタイトル属性が外れます。 スライドの内容をコピペしてタイトルを作り直したときに、この問題が起きやすいのでご注意ください。 一部のスライドのみ番号付番が行われない場合はこの現象を疑ってください。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide12.md -->
<!-- md_merge_rawtitle: 生成処理の実行 -->
<!-- #id:section:105-pptx-numbering:slide12 -->
## 1.11) 生成処理の実行

以下の命令で生成を実行します。 このサンプルでは chapt_section 方式の PPTX のみの生成を行うので、サブコマンドは pptmerge です。

{{vspace:1}}

```bash
cd cases\105-pptx-numbering\src
pptmdmerge pptmerge 105-example_recipe.yaml
```

{{vspace:3}}

付番前と付番後のPPTXファイルの一部を示します。

{{vspace:1}}

::: {.center}
![](images/105-pptx-numbering_slide12.webp){ width=100% }
:::

{{vspace:1}}

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/105-pptx-numbering_slide13.md -->
<!-- md_merge_rawtitle: ソースPPTX、生成指示YAML、および成果物PPTX -->
<!-- #id:section:105-pptx-numbering:slide13 -->
## 1.12) ソースPPTX、生成指示YAML、および成果物PPTX

当サンプルのソースと成果物を以下のリンクで確認できます。

### ソース

[生成指示]{.term} [105-example_recipe.yaml](src/105-example_recipe.yaml)

[原稿PPTX]{.term} [105-example1.pptx](src/105-example1.pptx), [105-example2.pptx](src/105-example2.pptx)


### 成果物

当サンプルはPPTXの生成のみを行い、MDやPDFは生成しません。 

[付番後PPTX]{.term} [105-example_target.pptx](build/105-example_target.pptx)

[README]{.term} 今、あなたがGitHubで読んでいるこのファイルです

::: {.center}
![](images/105-pptx-numbering_slide13.webp){ width=100% }
:::

原稿PPTXと付番後PPTXを開いて CHAPT や NONUMBERING, SUBSECTION がどう働くかを確認してください。

また、原稿PPTXにはnoteが書かれていないことも確認してください。

複数の原稿PPTXが結合されて、それらが続き番号として一貫した付番が行われていることを確認してください。