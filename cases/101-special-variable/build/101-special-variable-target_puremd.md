<!-- source: ../mds/101-special-variable-1.md -->
<!-- md_merge_rawtitle: MDファイルと画像ファイルに名前をつけるのが面倒 -->
<!-- #id:section:101-special-variable-:1 -->
## MDファイルと画像ファイルに名前をつけるのが面倒

ppt-md-merger で画像入り長いMDファイルを作ろうとすると、数十ページのスライドごとに画像とMDファイルを切り出してから結合するので、それらに個別に違う名前をつけなければなりません。

これは単純作業ですが案外面倒です。



![](images/101-special-variable-1.webp){ width=100% }

具体的にどこが面倒かというと・・・？





<!-- source: ../mds/101-special-variable-2.md -->
<!-- md_merge_rawtitle: export 命令のファイル名書き換えを自動化したい -->
<!-- #id:section:101-special-variable-:2 -->
## export 命令のファイル名書き換えを自動化したい

問題は図中の赤線を引いた部分です。



![](images/101-special-variable-2.webp){ width=100% }

出力先の画像ファイル、MDファイルにページごとに違う名前をつけなければならず、画像参照部分はその名前に合わせて書き換える必要があります。　数十ページもあるとちょっと面倒な作業です。

そこで、ページ番号（スライド番号）を使ってこれを自動命名してしまいましょう。





<!-- source: ../mds/101-special-variable-3.md -->
<!-- md_merge_rawtitle: スライド番号を使ってファイル名を自動付与する例 -->
<!-- #id:section:101-special-variable-:3 -->
## スライド番号を使ってファイル名を自動付与する例

noteテキスト中で 

```
<__SLIDENUM__> 
```

という文字列を使うと、そのスライドの番号に自動置換されます。 したがって、下記のようにファイル名を表記すれば、ページ（スライド）ごとに別の名前になります。

この方式を使うとexport命令はほとんどがコピペだけで済むようになります。



![](images/101-special-variable-3.webp){ width=100% }

通常の画像参照は同一ページ内のMDテキストから画像を参照するので、この形で問題ありません。

別ページの画像を参照する際は、参照先の番号を調べてそれを使うか、あるいはそこだけは番号を使わず **apple_orange.webp** のような固有の名前をつけて使います。

ページの挿入・削除が今後もあると予想できるときは、別ページの画像参照には固有名方式を使うと良いでしょう。

なお、このスライド番号置換はスライド中の文字列についても行われます。





<!-- source: ../mds/101-special-variable-4.md -->
<!-- md_merge_rawtitle: 置換される特殊変数 -->
<!-- #id:section:101-special-variable-:4 -->
## 置換される特殊変数

置換される特殊変数には他に以下のようなものがあります。

| 記法 | 置換内容 |
|---|---|
| `<__BASEFILENAME__>` | 原稿pptx のファイル名（拡張子なし） |
| `<__FILENAME__>` | 原稿pptx のファイル名（拡張子あり） |
| `<__SLIDENUM__>` | 原稿pptx でのスライド番号（1 始まり） |
| `<__TITLE__>` | そのスライドのタイトル文字列 |





<!-- source: ../mds/101-special-variable-5.md -->
<!-- md_merge_rawtitle: 生成処理の実行 -->
<!-- #id:section:101-special-variable-:5 -->
## 生成処理の実行

以下の命令で生成を実行します。サブコマンド ppt_build の引数に生成指示書を指定します。



```bash
cd cases\101-special-variable\src
pptmdmerge ppt_build 101-slide-md_recipe.yaml 
```



「WARNING: YAML ファイルが見つかりません」 という警告は出ても問題ありません。

この命令で生成されるのは renderedfilename で指定する Rendered MD です。

オプションを追加すると、PDFやGitHubMDも生成します。



```bash
cd cases\101-special-variable\src
pptmdmerge ppt_build 100-slide-md_recipe.yaml --pdf --github --transfer
```



**オプションなし** Rendered MD のみ生成する

**--pdf** Rendered MD をもとにPDFを生成する

**--github** Rendered MD をもとにGitHub用MDを生成する

**--transfer** 生成したMDを他の場所に転送するオプション。当サンプルでは、GitHubMD をもとに README.md を作るために使用する。

Rendered, PDF, GitHubMD 等の関係については次項の図をご覧ください。





<!-- source: ../mds/101-special-variable-6.md -->
<!-- md_merge_rawtitle: ソースPPTX、生成指示YAML、および成果物MDとPDF -->
<!-- #id:section:101-special-variable-:6 -->
## ソースPPTX、生成指示YAML、および成果物MDとPDF

当サンプルのソースと成果物を以下のリンクで確認できます。

### ソース

**生成指示** [101-special-variable_recipe.yaml](src/101-special-variable_recipe.yaml)

**原稿PPTX** [101-special-variable.pptx](src/101-special-variable.pptx)


### 成果物

MDは異なる仕様で数種類生成します。 Rendered MDはPPTXソースから切り出したMDにさまざまな加工を加えた生成物で、PDF用やHTML用の書式指示を含んでいます。 それらの書式指示をすべて落として GitHub での表示に特化したのがGitHub用MDです。

**Rendered MD** [101-special-variable-target-rendered.md](build/101-special-variable-target-rendered.md)

**GitHub用MD** [101-special-variable-target-github.md](build/101-special-variable-target-github.md)

**PDF** [101-special-variable-target.pdf](build/101-special-variable-target.pdf)

**README** このファイルです

![](images/101-special-variable-6.webp){ width=100% }

当サンプルはnoteのexport命令でファイル名を自動付与するサンプルですので、「画像とMD」 のpptxを開いて note の export 命令を確認し、次いで Rendered のMDを開いて画像ファイル名がどうなっているかを確認してください。