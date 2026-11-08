<!-- source: var:FRONTMATTER -->
---
image_border: true
image_border_color: "#BBBBFF"
image_border_width: 2
---


<!-- source: mds/マルチステップ機能_slide1_md.md -->
<!-- md_merge_rawtitle: ステップ表示のあるPowerPoint 原稿をレシプロマーカーに載せるサンプル -->
<!-- #id:section:マルチステップ機能:slide1 -->
## ステップ表示のあるPowerPoint 原稿をレシプロマーカーに載せるサンプル

![](multisteps-exp/steps-exp-slide1.png){ width=100% }

<!-- source: mds/マルチステップ機能_slide2_md.md -->
<!-- md_merge_rawtitle: ステップ表示アニメーションを レシプロマーカーで使う方法 -->
<!-- #id:section:マルチステップ機能:slide2 -->
## ステップ表示アニメーションを レシプロマーカーで使う方法

PowerPoint の 「要素を順番に表示していく」 単純なアニメーション機能を Markdown 文書で
使うことができます。 これをMULTISTEP機能と言います。
以下、そのデータを作るための ppt-md-merger 記述の例です。



![](multisteps-exp/steps-exp-slide2.png){ width=100% }



次ページ以降に実際の使用例を掲載します。ページ送り操作（カーソル右、スペース、→ボタンなど）をすると、画像部分が差し替わります。

<!-- source: mds/マルチステップ機能_slide3_md.md -->
<!-- md_merge_rawtitle: Markdown長文のオンライン説明に役立つシンクロ機能 -->
<!-- #id:section:マルチステップ機能:slide3 -->
## Markdown長文のオンライン説明に役立つシンクロ機能

近年、Markdown形式文書の用途が広がっています。

技術文書、社内ナレッジ、Wiki、議事録、調査メモ、ブログ記事、講義ノート、教材、長めの解説文書などに使われることが多いですね。

そこで、こんなことをしたくなるわけです。

<!-- #steps -->
![](multisteps-exp/steps-exp-slide3_step0.png){ width=100% }
![](multisteps-exp/steps-exp-slide3_step1.png){ width=100% }
![](multisteps-exp/steps-exp-slide3_step2.png){ width=100% }
![](multisteps-exp/steps-exp-slide3_step3.png){ width=100% }
![](multisteps-exp/steps-exp-slide3_step4.png){ width=100% }
<!-- /steps -->


社内ナレッジをMarkdownで書いて、それをシェアするためにチーム内で口頭説明を加えるような場面です。

そんなとき、聞き手は全員各自の端末でMarkdownファイルを開いて、「ここを見てください」 という作者の指示を聞きながらミーティングを進めるわけです。

場合によっては全員社内に出社しているのに、ZoomやTeamsでオンライン会議しながらこれをやっていることもありますね。

そんなとき、作者が 「ここを見て」 と指示した、同じ部分が全員の端末に同期して表示されてほしいですね。　つまり 「シンクロ機能」 です。

<!-- source: mds/マルチステップ機能_slide4_md.md -->
<!-- md_merge_rawtitle: セクション単位でフィードバックが欲しい -->
<!-- #id:section:マルチステップ機能:slide4 -->
## セクション単位でフィードバックが欲しい

さらに、Markdown文書の中身は #, ## などの見出しでセクション分割できるので、そのようなセクションごとに 「分かる」「分からん」 といったフィードバックが取れると便利です。

「おっ、このセクションだけ理解度低いなあ。　ここを直す必要があるのか」 ということがわかります。

<!-- #steps -->
![](multisteps-exp/steps-exp-slide4_step0.png){ width=100% }
![](multisteps-exp/steps-exp-slide4_step1.png){ width=100% }
![](multisteps-exp/steps-exp-slide4_step2.png){ width=100% }
![](multisteps-exp/steps-exp-slide4_step3.png){ width=100% }
![](multisteps-exp/steps-exp-slide4_step4.png){ width=100% }
![](multisteps-exp/steps-exp-slide4_step5.png){ width=100% }
![](multisteps-exp/steps-exp-slide4_step6.png){ width=100% }
![](multisteps-exp/steps-exp-slide4_step7.png){ width=100% }
![](multisteps-exp/steps-exp-slide4_step8.png){ width=100% }
<!-- /steps -->

全体に対しておおまかに 「いいね」 と言ってもらうのではなく、 「どこを直すべきなのか、ピンポイントで特定したい」 という場面、ありますよね？　それには、こんなセクション単位のフィードバックが必要です。　これは 「セクション評価機能」 と呼びましょう。

<!-- source: mds/マルチステップ機能_slide5_md.md -->
<!-- md_merge_rawtitle: セクション単位でコメントを書ける -->
<!-- #id:section:マルチステップ機能:slide5 -->
## セクション単位でコメントを書ける

フィードバックとしては、ちょっとしたテキストコメントを書いてもらうほうがありがたいときもありますよね。 単に 「分かる/分からない」 だけではなく、

「○○の用語の説明が欲しい」

といった短いコメントがあると助かる、そんなケースがよくあります。

<!-- #steps -->
![](multisteps-exp/steps-exp-slide5_step0.png){ width=100% }
![](multisteps-exp/steps-exp-slide5_step1.png){ width=100% }
![](multisteps-exp/steps-exp-slide5_step2.png){ width=100% }
![](multisteps-exp/steps-exp-slide5_step3.png){ width=100% }
![](multisteps-exp/steps-exp-slide5_step4.png){ width=100% }
<!-- /steps -->

これは 「セクションコメント機能」 と呼んでおきます。

<!-- source: mds/マルチステップ機能_slide6_md.md -->
<!-- md_merge_rawtitle: 「ちょっと前の部分を見返す」 こともできる -->
<!-- #id:section:マルチステップ機能:slide6 -->
## 「ちょっと前の部分を見返す」 こともできる

そんな、Markdown 文書を共有してフィードバックを返せるツールにもう一つ欲しいのが、「シンクロ解除」 機能です。

通常は 「シンクロ機能」 によって、作者が指定する画面を表示するものの、必要に応じてそのシンクロを解除して、指定以外のセクションも見られるようにする機能です。

「さっき説明してくれたセクションをもう一度見たい」 「少し先のセクションを見たい」 という場合の他に、「前のセクションでつけたフィードバックを修正したい」というようなときに役立ちます。

<!-- #steps -->
![](multisteps-exp/markdown-walkthrough-tool-slide6_step0.png){ width=100% }
![](multisteps-exp/markdown-walkthrough-tool-slide6_step1.png){ width=100% }
![](multisteps-exp/markdown-walkthrough-tool-slide6_step2.png){ width=100% }
![](multisteps-exp/markdown-walkthrough-tool-slide6_step3.png){ width=100% }
![](multisteps-exp/markdown-walkthrough-tool-slide6_step4.png){ width=100% }
![](multisteps-exp/markdown-walkthrough-tool-slide6_step5.png){ width=100% }
<!-- /steps -->

シンクロ解除は聞き手が随時選択できます。シンクロを戻せば再び作者の指定に同期して表示が変わるようになります。

<!-- source: mds/マルチステップ機能_slide7_md.md -->
<!-- md_merge_rawtitle: 「ここが重要マーカー」 も欲しいよね？ -->
<!-- #id:section:マルチステップ機能:slide7 -->
## 「ここが重要マーカー」 も欲しいよね？

Markdown で書く文書はたいてい、情報量/文字数が多いものです。そのため、単におおまかに写して口頭説明を加えるだけだと、どこの話をしているのか聞き手が分かりづらくなることがあります。そこで欲しいのがマーカー機能。

元のMarkdown文書には手を加えず、臨時にちょっとしたマーキングをして一部を目立たせる機能です。

<!-- #steps -->
![](multisteps-exp/markdown-walkthrough-tool-slide7_step0.png){ width=100% }
![](multisteps-exp/markdown-walkthrough-tool-slide7_step1.png){ width=100% }
![](multisteps-exp/markdown-walkthrough-tool-slide7_step2.png){ width=100% }
![](multisteps-exp/markdown-walkthrough-tool-slide7_step3.png){ width=100% }
![](multisteps-exp/markdown-walkthrough-tool-slide7_step4.png){ width=100% }
![](multisteps-exp/markdown-walkthrough-tool-slide7_step5.png){ width=100% }
<!-- /steps -->

数秒で自動的に線が消えるように設定できたり、色分けできたりするとなお良いですね。 「数秒で自動消去」 は文書の作者が講習会モードで使用した場合に有効です。　視聴者側で使用した場合は消えません。

また、フリーハンドでのマーキングは画像部分にのみ有効です。MDテキスト部分へのマーキングは、文字単位で背景色がつきます。