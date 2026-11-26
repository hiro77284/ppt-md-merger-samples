<!-- source: ../mds/104-multi-pptx-merge_slide1.md -->
<!-- md_merge_rawtitle: PPTXとPDFの同一構成マージ -->
<!-- #id:chapter:104-multi-pptx-merge:slide1 -->
# 1) PPTXとPDFの同一構成マージ

:::{.center}
:::{.widequote width="0.7\\linewidth"}
複数の原稿PPTXをマージして配布用PDFと講師用PPTXを作る際、両者を同じ章・節番号つきの同一構成で作る方法を解説します。
:::
:::

{{vspace:2}}

:::{.center}
:::{.widequote width="0.8\\linewidth"}
- 1.1) 複数の原稿PPTXから単一のPDFとPPTXを作りたい
- 1.2) 配布用PDFと講師用PPTXへの章節番号付与のしくみ
- 1.3) ユニークな #id 付与のしくみ
- 1.4) 複数の原稿PPTXを source に指定する
- 1.5) 複数の原稿PPTXをマージ(結合)する
- 1.6) 生成処理の実行
- 1.7) ソースPPTX、生成指示YAML、および成果物MDとPDF
:::
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/104-multi-pptx-merge_slide2.md -->
<!-- md_merge_rawtitle: 複数の原稿PPTXから単一のPDFとPPTXを作りたい -->
<!-- #id:section:104-multi-pptx-merge:slide2 -->
## 1.1) 複数の原稿PPTXから単一のPDFとPPTXを作りたい

企業研修等で数時間以上の長い講座を行うときによくあるのがこんなニーズです。

ひとつの研修の中では複数の小テーマを扱う。 それらはそれぞれ別の原稿PPTXになっている。 けれど研修業務のオペレーションを回しやすくするためには、それを1冊のPDFにして印刷したい。 バラバラに印刷して組み合わせる手間を掛けたくないからです。

そこで、複数の原稿PPTXを自動的に結合・変換して1つのPDFにまとめるようにしたいんですね。

そのときついでに表紙と目次もつけます。　さらに章節番号もつけます。テーマごとにひとつの章にして、1章1節、2章1節・・・と、番号を付加する。

さらに・・・！！

{{vspace:1}}

::: {.center}
![](images/104-multi-pptx-merge_slide2.webp){ width=100% }
:::

もうひとつ欲しいのが、同一構成の講師用PPTXです。 受講者に配付するPDFと同じ順番で1つにまとまり、同じ章節番号がついた講師用PPTXが欲しい。 それがあれば、次ページ・次ページと繰り返すだけで全ページをたどれます。 また、「次は3章4節です」 と、章節番号で案内で来て、その数字がプロジェクターの投影画面にも出るので受講者は迷わずに済みます。 

さらに、PDF側には詳細説明テキストも含めたいですね。 投影して口頭説明を加える講師用PPTXの側には要点だけでいいとしても、 「今日の講座で省略した部分は、各自自分で読んで理解してください」 と案内できるようにするためには、配布用PDFには詳細説明が必要です。

こんなことができるのでしょうか？　もちろん、できます。 そもそもそのために ppt-md-merger を作ったのですから。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/104-multi-pptx-merge_slide3.md -->
<!-- md_merge_rawtitle: 配布用PDFと講師用PPTXへの章節番号付与のしくみ -->
<!-- #id:section:104-multi-pptx-merge:slide3 -->
## 1.2) 配布用PDFと講師用PPTXへの章節番号付与のしくみ

しくみはこうです。

{{vspace:1}}

::: {.center}
![](images/104-multi-pptx-merge_slide3.webp){ width=100% }
:::

原稿PPTXのnoteにMDテキストを書く際、そこに [#id]{.term} を付与しておきます。#id とは、そのMDがどの原稿PPTXファイルの、どのスライドのものかを特定するキーです。

その #id は原稿PPTXから切り出した個別MDにも含まれていて、それを結合した結合MDには複数の#idが含まれます。

次いで、結合MDから#idを収集したファイルを作り（idcollect YAML）、そこに章節番号を付与します（idresolve　YAML、2.1は2章1節の例）。

結合MDを加工して rendered MD を作る時に#idをキーにして章節番号を反映させると rendered MD は章節番号つきの状態になります。 それをPDFに変換するので、配布用PDFも章節番号つきになります。

一方、講師用PPTXも複数の原稿PPTXを結合して作ります。 この結合命令と個別MDの結合命令は同じレシピYAMLの同じ場所に記載できるので整合性を保てます。 このとき講師用PPTXにも#idをキーにして番号を反映させることにより、配布用PDFと同一構成で同じ章節番号を付与した講師用PPTXを生成できます。

この動作は原稿PPTXが複数あっても #id がユニークなら問題なく機能します。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/104-multi-pptx-merge_slide4.md -->
<!-- md_merge_rawtitle: ユニークな #id 付与のしくみ -->
<!-- #id:section:104-multi-pptx-merge:slide4 -->
## 1.3) ユニークな #id 付与のしくみ

複数の原稿PPTXにまたがってスライドごとにユニークな '#id' を付与するしくみを解説します。

{{vspace:1}}

::: {.center}
![](images/104-multi-pptx-merge_slide4.webp){ width=100% }
:::

{{vspace:1}}

note に MD を書き出す {{BLOCK:MD}} ブロックで、以下の表記を使えます。

```plain
<__BASEFILENAME__> 拡張子を除くファイル名へと置換される
<__SLIDENUM__> スライド番号へと置換される
```

そこで、'#id' を上図例のように記載すると、置換後はファイル名とスライド番号を組み合わせたユニークなidとなります。

'#id' 行のフォーマットは TYPE, PART, LOCALの組合せです。

TYPE はその '#id' が章・節・項のどのレベルかを示します。 以下の3種類のいずれかを使用でき、通常最もよく使うのはsectionです。

```plain
chapter : 章
section : 節
subsection : 項

```
つまり、章節番号といいつつ実際は「章・節・項」の3階層を使用可能です。

id, TYPE, PART, LOCALを区切る ':' は必須ですので、通常は ':' を3個使って '#id' 行を書きます。 ':' が2個未満だと '#id' と認識されません。 4個以上あるのは問題ありません（4個目以降はすべてLOCALの一部となります）。

'#id' の次行の '## ユニークな #id 付与のしくみ' はスライドのタイトルに置換されます。 MDの見出しレベルを表す '##' の部分は '#id' の後の chpater, section, subsection と合わせて '#', '##', '###' を選んでください。

このようなしくみにより、複数の原稿PPTXを使いつつ、idのユニーク性を容易に担保できるため、MDブロックの ヘッダー部 (BLOCK:MD から ## TITLE 行まで) は、ほぼコピペで済むようになります。

### 制約事項

異なるフォルダに存在する同じファイル名のPPTXを同時に原稿PPTXとして使うと、この方式でも #id のユニーク性は担保されませんのでご注意ください。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/104-multi-pptx-merge_slide5.md -->
<!-- md_merge_rawtitle: 複数の原稿PPTXを source に指定する -->
<!-- #id:section:104-multi-pptx-merge:slide5 -->
## 1.4) 複数の原稿PPTXを source に指定する

複数の原稿PPTXを source に指定する方法です。

{{vspace:1}}

::: {.center}
![](images/104-multi-pptx-merge_slide5.webp){ width=100% }
:::

{{vspace:1}}

レシピYAMLの source.cropsrc セクションに、pptx で原稿PPTXを指定し、pdf でワークPDFを指定します。　ワークPDFとは原稿PPTXを単純にPDF化したもので、原稿PPTXから画像を切り出すために使われます。　pdfの指定は省略可能ですが、省略すると output.outputdir にワークPDFが作られます。

pptx、pdfの出力先パスはいずれもレシピYAMLを起点とする相対パス、または絶対パスです。 

原稿PPTXを多数使うと、そのワークPDFがすべて output.outputdir に出力されるのは煩わしいため、作者は レシピYAMLと原稿PPTXを src フォルダに置き、ワークPDFの出力先はそれと同列の temppdfs フォルダとする設定をよく使います。

cropimagedirs は原稿PPTXから切り出した画像の後加工をする場所です。この値は原稿PPTX内の画像切り出し命令

```plain
export-image-mode: slide_with_rectpct
export-image-target: exportrange
export-image: ../images/apple_orange.webp
```

の出力先フォルダ (expor-image中のフォルダ名) に合わせてください。 ppt-md-mergerは  expor-image-mode が slide_with_rectpct であった場合に、 cropimagedirs のディレクトリを見にいって画像の後加工処理をします。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/104-multi-pptx-merge_slide6.md -->
<!-- md_merge_rawtitle: 複数の原稿PPTXをマージ(結合)する -->
<!-- #id:section:104-multi-pptx-merge:slide6 -->
## 1.5) 複数の原稿PPTXをマージ(結合)する

複数の原稿PPTXをマージ(結合)して、大きなPDFやPPTXを作る方法です。 原稿PPTXを結合して作るPDFとPPTXの名前を指定します。 targetbasefilename を書いてあればそれをベースに自動補完されるので実際には下図中の該当項目は省略可能です。

{{vspace:1}}

::: {.center}
![](images/104-multi-pptx-merge_slide6.webp){ width=100% }
:::

{{vspace:1}}

procedure セクションで、原稿PPTXの個別スライドや個別MDのマージ(結合)操作を記述します。上図例のように、insertpptx と insertmdpages(または insertmd) を並べて書いておくと、どちらも "1-END" や "1,2,3,5-END" と、同じ部分をマージしているのがわかるため、両者を同一構成で生成できます。

"1,2,3,5-END" は4を飛ばしてマージしています。 このように、原稿PPTXのすべてを使わず、選択的にマージすることもできます。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/104-multi-pptx-merge_slide7.md -->
<!-- md_merge_rawtitle: 生成処理の実行 -->
<!-- #id:section:104-multi-pptx-merge:slide7 -->
## 1.6) 生成処理の実行

以下の命令で生成を実行します。サブコマンド ppt_build の引数に生成指示書を指定します。

{{vspace:1}}

```bash
cd cases\104-multi-pptx-merge\src
pptmdmerge ppt_build 104-multi-pptx-merge_recipe.yaml
```

{{vspace:1}}

「WARNING: YAML ファイルが見つかりません」 という警告は出ても問題ありません。

この命令で生成されるのは renderedfilename で指定する Rendered MD です。

オプションを追加すると、PDFやGitHubMDも生成します。

{{vspace:1}}

```bash
cd cases\104-multi-pptx-merge\src
pptmdmerge ppt_build 104-multi-pptx-merge_recipe.yaml --pdf --github --transfer --pptx
```

{{vspace:1}}

[オプションなし]{.term} Rendered MD のみ生成する

[--pdf]{.term} Rendered MD をもとにPDFを生成する

[--github]{.term} Rendered MD をもとにGitHub用MDを生成する

[--transfer]{.term} 生成したMDを他の場所に転送するオプション。当サンプルでは、GitHubMD をもとに README.md を作るために使用する。

[--pptx]{.term} PPTXファイルの結合を行います

Rendered, PDF, GitHubMD, PPTX 等の関係については次項の図をご覧ください。

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/104-multi-pptx-merge_slide8.md -->
<!-- md_merge_rawtitle: ソースPPTX、生成指示YAML、および成果物MDとPDF -->
<!-- #id:section:104-multi-pptx-merge:slide8 -->
## 1.7) ソースPPTX、生成指示YAML、および成果物MDとPDF

当サンプルのソースと成果物を以下のリンクで確認できます。

### ソース

[生成指示]{.term} [104-multi-pptx-merge_recipe.yaml](src/104-multi-pptx-merge_recipe.yaml)

[原稿PPTX]{.term} [104-multi-pptx-merge.pptx](src/104-multi-pptx-merge.pptx), [additional.pptx](src/additional.pptx)


### 成果物

MDは何種類か異なる仕様で生成します。 Rendered MDはPPTXソースから切り出したMDにさまざまな加工を加えた生成物で、豊富な書式指示を含んでいます。 それらの書式指示をすべて落として GitHub での表示に特化したのがGitHub用MDです。

[Rendered MD]{.term} [104-multi-pptx-merge_target_rendered.md](build/104-multi-pptx-merge_target_rendered.md)

[GitHub用MD]{.term} [104-multi-pptx-merge_target_github.md](build/104-multi-pptx-merge_target_github.md)

[PDF]{.term} [104-multi-pptx-merge_target.pdf](build/104-multi-pptx-merge_target.pdf)

[結合PPTX]{.term} [104-multi-pptx-merge_target.pptx](build/104-multi-pptx-merge_target.pptx)

[README]{.term} このファイルです

::: {.center}
![](images/104-multi-pptx-merge_slide8.webp){ width=100% }
:::

当サンプルはPDF化時に改ページ、スペース調整を行うサンプルですので、「PDF」 のpdfを開いてそれらの状態を確認し、次いで 生成指示YAMLを開いて procedure セクションと照らし合わせて確認してください。 

<!-- source: ../mds/additional_slide1.md -->
<!-- md_merge_rawtitle: 複数原稿PPTXの2ファイル目 -->
<!-- #id:chapter:additional:slide1 -->
# 2) 複数原稿PPTXの2ファイル目

:::{.center}
:::{.widequote width="0.7\\linewidth"}
この章は複数原稿PPTXの2ファイル目です。 生成された単一のPDFおよびPPTXで第2章に掲載されていることを確認してください。

下記のセクションリストは飛ばした Contents C を除外したリストになり、節番号は2.1～2.6まで連続していることを確認してください。
:::
:::

{{vspace:2}}

:::{.center}
:::{.widequote width="0.8\\linewidth"}
- 2.1) Contents A
- 2.2) Contents B
- 2.3) Contents D
- 2.4) Contents E
- 2.5) Contents F
- 2.6) Contents G
:::
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/additional_slide2.md -->
<!-- md_merge_rawtitle: Contents A -->
<!-- #id:section:additional:slide2 -->
## 2.1) Contents A

contents A

{{vspace:1}}

::: {.center}
![](images/additional_slide2.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/additional_slide3.md -->
<!-- md_merge_rawtitle: Contents B -->
<!-- #id:section:additional:slide3 -->
## 2.2) Contents B

contents B

{{vspace:1}}

::: {.center}
![](images/additional_slide3.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/additional_slide5.md -->
<!-- md_merge_rawtitle: Contents D -->
<!-- #id:section:additional:slide5 -->
## 2.3) Contents D

contents D

{{vspace:1}}

::: {.center}
![](images/additional_slide5.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/additional_slide6.md -->
<!-- md_merge_rawtitle: Contents E -->
<!-- #id:section:additional:slide6 -->
## 2.4) Contents E

contents E

{{vspace:1}}

::: {.center}
![](images/additional_slide6.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/additional_slide7.md -->
<!-- md_merge_rawtitle: Contents F -->
<!-- #id:section:additional:slide7 -->
## 2.5) Contents F

contents F

{{vspace:1}}

::: {.center}
![](images/additional_slide7.webp){ width=100% }
:::

{{vfill}}

{{pagebreak}}

<!-- source: ../mds/additional_slide8.md -->
<!-- md_merge_rawtitle: Contents G -->
<!-- #id:section:additional:slide8 -->
## 2.6) Contents G

contents G

{{vspace:1}}

::: {.center}
![](images/additional_slide8.webp){ width=100% }
:::