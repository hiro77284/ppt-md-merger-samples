<!-- source: ../mds/100-slide-md1.md -->
<!-- md_merge_rawtitle: パワポスライドにMDテキストをつけて一括合成 -->
<!-- #id:section:100-slide-md:slide1 -->
## パワポスライドにMDテキストをつけて一括合成

技術解説文書を書くときは、要点箇条書きスライドだけでは足りません。精密な図解に加えて文章による詳細解説も必要なのが普通です。

そこで欲しくなるのが図解入りMarkdownファイルです。

本書はPPTXで図解＋Markdownを制作した後、それを自動的に分解結合して１つの長い図解入りMarkdownファイルを作るサンプルです。



![](images/100-slide-md1.webp){ width=100% }





<!-- source: ../mds/100-slide-md2.md -->
<!-- md_merge_rawtitle: スライドに図を書き、noteにMarkdownを書く -->
<!-- #id:section:100-slide-md:slide2 -->
## スライドに図を書き、noteにMarkdownを書く

基本的なしくみは、スライドに図を書いてnoteにMarkdownを書き、Markdownテキスト内で図を参照するというものです。



![](images/100-slide-md2.webp){ width=100% }



noteというのはPowerPointファイル(PPTX)のスライドごとに付属する、文章でちょっとしたメモ書きを書いておける領域です。そこに図の詳細解説をMarkdownで書きます。

このときに一定の書式を使うことで、Markdown中でスライドの図を参照します。





<!-- source: ../mds/100-slide-md3.md -->
<!-- md_merge_rawtitle: 長方形シェイプを使って画像切り出し範囲を示す -->
<!-- #id:section:100-slide-md:slide3 -->
## 長方形シェイプを使って画像切り出し範囲を示す

スライド側では、切り出したい画像の背後に切り出し範囲を示す長方形シェイプを置き、そこに名前をつけます。 
シェイプに名前をつけるには、シェイプ選択後に 「編集→選択→オブジェクトの選択と表示」 で出てくる名前を変更します。

他のシェイプと区別できればどんな名前でもかまいませんが、当サンプルでは例として exportrange という名前を使います。



![](images/100-slide-md3.webp){ width=100% }



ppt-md-merger はこの範囲を単独の画像ファイルとして自動的に切り出します。それをMarkdownテキストで参照すればよいわけです。

では次に Markdownテキスト側の書き方を確認しましょう。





<!-- source: ../mds/100-slide-md4.md -->
<!-- md_merge_rawtitle: noteに画像切り出し指示とMarkdownを書く -->
<!-- #id:section:100-slide-md:slide4 -->
## noteに画像切り出し指示とMarkdownを書く

note側に画像切り出し指示とMarkdownを書きます。

1行目の "NOTE_CONTENT_FORMAT: 1.0" は、この note の内容を ppt-md-merger への指示として解析しろ、という命令です。

note のテキストは "===BLOCK===" で区切り、各ブロックの1行目は "{{BLOCK:*}}" の書式でブロックの種類を示します。

"{{BLOCK:IMAGE}}" はそのブロックが画像切り出し指示であることを意味します。ここで、画像として切り出す範囲 exportrange と、ファイル名（パス）も指定します。



![](images/100-slide-md4.webp){ width=100% }



"{{BLOCK:MD}}" はそのブロックがMarkdownテキストであることを意味します。 出力するMarkdownファイルのパスを "export-note" で指定します。

次の行から次のブロックまで（またはnote末尾まで)をMarkdownテキストとして出力します。

Markdownテキスト出力範囲の先頭に '##' 見出しを書きます。'#' や '###' も使用可能ですが、基本は '##' としてください。 '#' は章・節構成で複数の章に分けるような長い文書を書く際に 章 レベルを書くために使います。

Markdownテキストの中に画像参照コードを書くことで、切り出したスライド画像を参照できます。





<!-- source: ../mds/100-slide-md5.md -->
<!-- md_merge_rawtitle: 生成指示書(レシピYAML)の役割 -->
<!-- #id:section:100-slide-md:slide5 -->
## 生成指示書(レシピYAML)の役割

原稿PPTXの他に重要なのが生成指示書（レシピYAML）です。 このファイルは原稿PPTXファイルから結合MDファイルを作る処理の流れ全体を指示するものなので、「生成指示書」 または料理のレシピのような役割を果たすYAMLファイルであることからレシピYAMLと呼びます。

処理の流れは大まかに　「ソース　→　素材　→　ビルド　→　後加工」　に分かれます。　source, fragment, output はそれぞれ対応するYAMLファイルのセクション名です。

おおよそ下記のように、ソースから素材を切り出し、素材を結合して結合MDをビルドするという流れです。 この流れ全体をレシピYAMLでコントロールします。 実際には結合MDをもとにPDF化するなどの後加工工程が加わることもあってもう少し複雑ですが、当サンプルは 「原稿PPTXから結合MDを作る部分だけを示す」 のが目的なので、細かい部分には触れません。



![](images/100-slide-md5.webp){ width=100% }



レシピYAMLの書き方を知る前に、この工程設計が採用しているいくつかの基本的な考え方を説明します。

**ソース、素材、ビルドのフォルダを分ける** 
ソース以外のフォルダは自動生成されるため、業務完了後は削除できます。 後工程で使うものはビルドフォルダだけなので、後工程を別サーバーで行うような場合はビルドフォルダだけを切り出して渡します。 このような使い方ができるように、原則としてソース、素材、ビルドフォルダを分けます。

**素材のMDと画像も別フォルダに分ける** 
実際には素材フォルダもMD用と画像用で別にしています。これは作者の運用方針ではそのほうが扱いやすかったためです。

**素材に出力されても使われないファイルもある** 
原稿PPTXの中に 「実際には使わないページ」 があっても、素材切り出しはそれも含めて行います。 実際に使うもののみを結合またはコピーの操作でビルドフォルダに出力して使う、という流れになります。

**レシピYAMLには個別画像の記述はしない** 
レシピYAMLには 「使用する個別MDのリスト」 を書きますが、個別画像については書きません。 個別MDから参照されている個別画像のみをビルドフォルダにコピーします。

**個別MDが個別画像を参照するリンクを有効にしておく** 
個別MD内で個別画像を使用する際は、有効なパスで参照してください。 パスが無効だと、その画像ファイルはビルドフォルダにコピーされません。 個別MDをMDビューアーで開いたときに、参照している個別画像も見えればOKです。 この参照は原稿PPTX内のnoteに書くもので、タイプミス等で切れやすいので注意します。

**結合MDは後工程の共通起点** 
「後工程」としては、PDF化、GitHub仕様のMD出力、HTML化、PureMD化などがありますが、いずれも 「結合MD」 をもとにして処理を行います。

**fragmentは小さな断片** 
個別MDや個別画像は原稿PPTXを断片化したものにあたるので、この名前を使っています。

では、以上の各事項を踏まえてレシピYAMLの具体的な書き方を確認しましょう。　ただし当サンプルは 「原稿PPTXから結合MDを作る部分だけを示す」 のが目的なので、それに関係のある部分のみを解説し、その他の部分には触れません。





<!-- source: ../mds/100-slide-md6.md -->
<!-- md_merge_rawtitle: レシピYAML： 原稿PPTX -->
<!-- #id:section:100-slide-md:slide6 -->
## レシピYAML： 原稿PPTX

source.cropsrc.pptx には、原稿PPTXを指定します。 ここに書かれたPPTXファイルから、個別MDと個別画像ファイルが切り出されます。

![](images/100-slide-md6.webp){ width=100% }

pptx を複数使う場合はリストで記述します。

```plain
  cropsrc:  # リスト使用可能
    - pptx: 講師紹介_standard.pptx 
      pdf: ../temppdfs/講師紹介_standard.pdf           
    - pptx: ../../modules/src/問題・目標・原因・施策_standard.pptx
      pdf: ../temppdfs/問題・目標・原因・施策_standard.pdf

```

cropimagedirs は原稿PPTXから切り出した画像の後加工をする場所です。この値は原稿PPTX内の画像切り出し命令

```plain
export-image-mode: slide_with_rectpct
export-image-target: exportrange
export-image: ../images/apple_orange.webp
```

の出力先フォルダ (expor-image中のフォルダ名) に合わせてください。 ppt-md-mergerは  expor-image-mode が slide_with_rectpct であった場合に、 cropimagedirs のディレクトリを見にいって画像の後加工処理をします。





<!-- source: ../mds/100-slide-md7.md -->
<!-- md_merge_rawtitle: 生成処理の実行 -->
<!-- #id:section:100-slide-md:slide7 -->
## 生成処理の実行

以下の命令で生成を実行します。サブコマンド ppt_build の引数に生成指示書を指定します。



```bash
cd cases\100-slide-md\src
pptmdmerge ppt_build 100-slide-md_recipe.yaml
```



「WARNING: YAML ファイルが見つかりません」 という警告は出ても問題ありません。

この命令で生成されるのは renderedfilename で指定する Rendered MD です。

オプションを追加すると、PDFやGitHubMDも生成します。



```bash
cd cases\100-slide-md\src
pptmdmerge ppt_build 100-slide-md_recipe.yaml --pdf --github --transfer
```



**オプションなし** Rendered MD のみ生成する

**--pdf** Rendered MD をもとにPDFを生成する

**--github** Rendered MD をもとにGitHub用MDを生成する

**--transfer** 生成したMDを他の場所に転送するオプション。当サンプルでは、GitHubMD をもとに README.md を作るために使用する。

Rendered, PDF, GitHubMD 等の関係については次項の図をご覧ください。





<!-- source: ../mds/100-slide-md8.md -->
<!-- md_merge_rawtitle: ソースPPTX、生成指示YAML、および成果物MDとPDF -->
<!-- #id:section:100-slide-md:slide8 -->
## ソースPPTX、生成指示YAML、および成果物MDとPDF

当サンプルのソースと成果物を以下のリンクで確認できます。

### ソース

**生成指示** [100-slide-md_recipe.yaml](src/100-slide-md_recipe.yaml)

**原稿PPTX** [100-slide-md.pptx](src/100-slide-md.pptx)


### 成果物

MDは異なる仕様で数種類生成します。 Rendered MDはPPTXソースから切り出したMDにさまざまな加工を加えた生成物で、PDF用やHTML用の書式指示を含んでいます。 それらの書式指示をすべて落として GitHub での表示に特化したのがGitHub用MDです。

**Rendered MD** [100-slide-md_target_rendered.md](build/100-slide-md_target_rendered.md)

**GitHub用MD** [100-slide-md_target_github.md](build/100-slide-md_target_github.md)

**PDF** [100-slide-md_target.pdf](build/100-slide-md_target.pdf)

**README** 今、あなたがGitHubで読んでいるこのファイルです

![](images/100-slide-md8.webp){ width=100% }

当サンプルは主に 「PPTXに画像とMDを記載できる」 ことを説明するサンプルですので、「画像とMD」 のpptxを開いて画像とMDのブロックを確認し、それが 「Rendered」 MDでどのようになっているかを確認してみてください。