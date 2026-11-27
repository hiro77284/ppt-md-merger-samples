// report_template.typst
// PDF（typst）用の pandoc テンプレート（旧 report_template.tex の Typst 版）。
// pandoc の既定 Typst テンプレートから、Typst writer が前提にする定義（horizontalrule・
// terms・table・figure・ハイライト）だけを残し、ページ設計は include-in-header の
// semantic_macros.typ / report_style.typ に任せる（既定テンプレートの conf() は使わない）。

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#show terms.item: it => block(breakable: false)[
  #text(weight: "bold")[#it.term]
  #block(inset: (left: 1.5em, top: -0.4em))[#it.description]
]

// 表の標準: 罫線 0.5pt・セルは左揃え。pandoc は表を #align(center)[#table(...)] で包み、
// 揃え指定の無い列（`---`）は align: auto（＝周囲の center を継承）になるため、
// セルの既定を left にする。md の列揃え（`:---:` / `---:`）は pandoc が列ごとに
// center / right を明示するので、そちらが優先される。表そのものの配置は中央のまま。
#set table(
  inset: 6pt,
  stroke: 0.5pt
)
#show table.cell: set align(left)
// 見出し行（1 行目）は太字＋薄い灰色の背景にして、中身の行と区別する。
#set table(fill: (x, y) => if y == 0 { luma(90%) })
#show table.cell.where(y: 0): set text(weight: "bold")

#show figure.where(
  kind: table
): set figure.caption(position: top)

#show figure.where(
  kind: image
): set figure.caption(position: bottom)

// semantic_macros.typ
// セマンティック記法（[text]{.term} / ::: {.note} 等）の Typst 関数定義。
// 旧 LaTeX 版の semantic_macros.tex と report_header.tex の tcolorbox 定義（撤去済み）を移したもの。
// pandoc の include-in-header で .typ のプリアンブルに取り込む（
// report_style.typ より先に読む）。変換は filters/semantic-spans.lua・divboxes.lua 等が行い、
// 本ファイルは見た目だけを定義する（見た目は調整前提。色・余白は LaTeX 版に合わせている）。

// ── 共通の定数 ───────────────────────────────────────────────────────────
// 欧文は Times New Roman / Arial（latin-in-cjk で欧文だけに当てる）、和文は BIZ UDGothic。
// LaTeX 版の和文は BIZ UDPGothic だが、luatexja は全角幅で組むので、Typst では
// 非プロポーショナルの BIZ UDGothic を使うと見た目がそろう（design_typst_migration.md §Phase 2）。
#let sem-fonts = (
  main: ((name: "Times New Roman", covers: "latin-in-cjk"), "BIZ UDGothic"),
  sans: ((name: "Arial", covers: "latin-in-cjk"), "BIZ UDGothic"),
  mono: ("Consolas", "BIZ UDGothic"),
)
// 行送り。LaTeX 11pt の \baselineskip 13.6pt を和文 10.5pt で割った 1.295em を
// stretch 1 の行送りとし、本文は \setstretch{1.2} 相当。text の top/bottom-edge を
// 1em の箱にしている（report_style.typ）ので、leading = 行送り − 1em。
#let sem-pitch = 1.295em
#let sem-leading(stretch) = stretch * sem-pitch - 1em
#let sem-body-stretch = 1.2

// ── インライン（[text]{.class}）────────────────────────────────────────
#let sem-term-color = rgb("#1A5FB4")    // 用語: 落ち着いた青
#let sem-keyword-bg = rgb("#FFF3B0")    // キーワード: 淡い黄ハイライト

// .term     専門用語・定義語 -> 青＋太字
#let semterm(body) = text(fill: sem-term-color, strong(body))
// .keyword  キーワード・重要語 -> 太字＋淡色ハイライト
#let semkeyword(body) = highlight(fill: sem-keyword-bg, strong(body))
// .path     ファイル名・パス -> 等幅
#let sempath(body) = text(font: sem-fonts.mono, body)
// .kbd      キー入力 -> キーキャップ風（枠＋小さめ等幅）
#let semkbd(body) = box(
  stroke: 0.5pt, inset: (x: 2pt), outset: (y: 2pt), radius: 1pt,
  text(size: 0.9em, font: sem-fonts.mono, body),
)
// .emph は Typst ネイティブ emph を使用（本ファイルでは定義しない）
// .rightlabel  行末ラベルの右寄せ -> 残り幅を埋めてから内容
#let semrightlabel(body) = [#h(1fr)#body]

// ── 囲み（::: {.note} / {.warning} / {.leadline} / {.widequote}）──────────
// divboxes.lua が #sem-box("kind", 属性...)[中身] を出す。frame を付けない既定は
// 枠も背景も描かない（tcolorbox の blanker 相当。LaTeX 版の <kind>/noframe）。
// frame: true で枠と背景を描く（<kind>/frame）。属性で上書きできる。
#let _sem-box-kinds = (
  leadline: (
    inset: (x: 0mm, y: 1mm), frame-inset: (x: 0mm, y: 0.5mm),
    fill: white, stroke-color: black, rule: 0.4pt,
    above: 10pt, below: 8pt, bold: true, size: 1.44em, stretch: none,
  ),
  note: (
    inset: (x: 2mm, y: 1mm), frame-inset: (x: 2mm, y: 1mm),
    fill: luma(97%), stroke-color: luma(70%), rule: 0.3pt,
    above: 8pt, below: 8pt, bold: false, size: 1em, stretch: none,
  ),
  warning: (
    inset: (x: 2mm, y: 1mm), frame-inset: (x: 2mm, y: 1mm),
    fill: luma(95%), stroke-color: black, rule: 0.5pt,
    above: 10pt, below: 10pt, bold: true, size: 1em, stretch: none,
  ),
  widequote: (
    inset: (left: 4mm, right: 2mm, y: 1.5mm), frame-inset: (left: 4mm, right: 2mm, y: 1.5mm),
    fill: white, stroke-color: black, rule: 0.4pt,
    above: 11pt, below: 11pt, bold: false, size: 1em, stretch: 1.4,
  ),
)

// inset の辞書（x / y / left ...）を left / right / top / bottom に展開する。
#let _sem-sides(d) = (
  left: d.at("left", default: d.at("x", default: 0pt)),
  right: d.at("right", default: d.at("x", default: 0pt)),
  top: d.at("top", default: d.at("y", default: 0pt)),
  bottom: d.at("bottom", default: d.at("y", default: 0pt)),
)

#let sem-box(
  kind,
  frame: false, width: 100%, center: false,
  fill: auto, stroke-color: auto, rule: auto,
  left: auto, right: auto, top: auto, bottom: auto,
  size: auto, stretch: auto, above: auto, below: auto,
  body,
) = {
  let k = _sem-box-kinds.at(kind)
  let sides = _sem-sides(if frame { k.frame-inset } else { k.inset })
  for (key, v) in (left: left, right: right, top: top, bottom: bottom) {
    if v != auto { sides.insert(key, v) }
  }
  let pick(v, dflt) = if v == auto { dflt } else { v }
  let st = pick(stretch, k.stretch)
  let b = block(
    width: width,
    breakable: true,
    inset: sides,
    above: pick(above, k.above),
    below: pick(below, k.below),
    fill: if frame { pick(fill, k.fill) } else { none },
    stroke: if frame { pick(rule, k.rule) + pick(stroke-color, k.stroke-color) } else { none },
    {
      // 囲みの中は両端揃えに戻す（外側の :::center の中央寄せを持ち込まない。tcolorbox と同じ）
      set align(start)
      set par(justify: true)
      set text(size: pick(size, k.size))
      // set … if は条件付きの set（if ブロックの中に書くとブロック内でしか効かない）
      set text(font: sem-fonts.sans, weight: "bold") if k.bold
      let lead = sem-leading(if st == none { sem-body-stretch } else { st })
      set par(leading: lead, spacing: lead) if st != none
      body
    },
  )
  // 引数 center / left / right / top / bottom が同名の配置値を隠すので std. を付ける
  if center { align(std.center, b) } else { b }
}

// ── その他のブロック ─────────────────────────────────────────────────────
// ::: {.center}        中央寄せ（LaTeX の center 環境と同じく両端揃えはしない）。
// 前後の空きは center 環境の \topsep ＋ \parskip 相当。
#let semcenter(body) = block(
  width: 100%, above: 12pt, below: 12pt,
  align(center, { set par(justify: false); body }),
)
// ::: {.blockindent}   左字下げ（既定 2em）
#let semblockindent(indent: 2em, body) = pad(left: indent, body)
// ::: {.largefontblock} 大きめの文字（\Large 相当）
#let semlargefontblock(body) = { set text(size: 1.44em); body }
// ::: {.keep-together}  ページ途中で分割しない
#let semkeeptogether(body) = block(breakable: false, width: 100%, body)

// {{br}}  見出し内の強制改行（filters/semantic-break.lua が #linebreak() に lower する）。
// 見出し本体では改行し、目次では消す（日本語見出しなので空白も入れない。GFM と同じ扱い）。
#show outline.entry: it => {
  show linebreak: none
  it
}

// report_style.typ
// PDF（typst）のページ設計。旧 LaTeX 版の report_header.tex（titlesec / fancyhdr / 目次。撤去済み）を移したもの。
// pandoc の include-in-header で semantic_macros.typ の後に読む（sem-fonts / sem-leading を使う）。
// report_template.typst が #sem-cover / #sem-toc を呼ぶ。見た目は基準 PDF（lualatex 版）に合わせて
// あるが調整前提。寸法の出典は旧 report_header.tex と report_semantic_style.yaml（geometry）。

// ── 用紙・本文 ───────────────────────────────────────────────────────────
// 用紙は A4（2026-10-25 決定。LaTeX 版＝report クラスの既定の US Letter とはページ送りが変わる）。
// geometry: top/bottom 15mm、left/right 20mm、headsep 8mm。
#set page(
  paper: "a4",
  margin: (top: 15mm, bottom: 15mm, x: 20mm),
  header-ascent: 8mm,
  footer-descent: 8mm,
)
// 和文 10.5pt（LaTeX 11pt を luatexja の和文スケール 0.962 で縮めた大きさ）。
// top/bottom-edge を 1em の箱にして、行送りを sem-leading で決められるようにする。
#set text(font: sem-fonts.main, size: 10.5pt, lang: "ja", top-edge: 0.88em, bottom-edge: -0.12em)
// 段落間は \parskip 0.5em。
#set par(
  justify: true,
  leading: sem-leading(sem-body-stretch),
  spacing: sem-leading(sem-body-stretch) + 0.5em,
)
#show raw: set text(font: sem-fonts.mono)
#set list(marker: text(size: 0.7em)[●])
#show strong: set text(font: sem-fonts.sans)

// ── 見出し ───────────────────────────────────────────────────────────────
// 番号は idresolve が見出しの文字列に書き込み済みなので、Typst では番号を付けない。
#let sem-heading-text(size, body) = text(font: sem-fonts.sans, weight: "bold", size: size, body)

// 章（#）: 改ページ、上に 70pt（＋ titlesec の display 形式の分。基準 PDF に合わせて 87pt）、
// 中央寄せ 28pt、本文幅の 80% の箱で折り返し、直下 2mm に 2pt の線。
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(87pt)
  align(center, block(width: 80%, {
    set par(justify: false, leading: 0.25em)
    sem-heading-text(26.8pt, it.body)
    v(2mm, weak: true)
    line(length: 100%, stroke: 2pt)
  }))
  v(10pt)
}
// 節（##）: 14pt、上 23pt・下 11pt（LaTeX 版の 18pt / 6pt から前後 5pt ずつ広げた。2026-10-22）。
#show heading.where(level: 2): it => block(
  above: 23pt, below: 11pt, sticky: true,
  { set par(justify: false); sem-heading-text(13.4pt, it.body) },
)
// 項（###）: 12pt、上 12pt・下 4pt。
#show heading.where(level: 3): it => block(
  above: 12pt, below: 4pt, sticky: true,
  { set par(justify: false); sem-heading-text(11.5pt, it.body) },
)
#show heading.where(level: 4): it => block(
  above: 10pt, below: 4pt, sticky: true, sem-heading-text(10.5pt, it.body),
)

// ── 柱とノンブル ─────────────────────────────────────────────────────────
// 右柱に節タイトル（fancyhdr の \rightmark 相当: そのページの最初の節、無ければ直前の節。
// 章が始まった後で節がまだ無ければ空）。章の開始ページと目次の 1 ページ目は柱なし
// （LaTeX 版の plain）。目次の 2 ページ目以降の柱は「目次」。
#let sem-header-box(body) = block(
  width: 100%, inset: (bottom: 2pt), stroke: (bottom: 0.4pt),
  {
    set text(font: sem-fonts.sans, size: 9.6pt)
    show linebreak: none
    align(right, body)
  },
)

#let _sem-header() = context {
  let pg = here().page()
  let on-page(h) = h.location().page() == pg
  let toc-a = query(<sem-toc-start>)
  let toc-b = query(<sem-toc-end>)
  let in-toc = toc-a.len() > 0 and toc-b.len() > 0 and pg >= toc-a.first().location().page() and pg <= toc-b.first().location().page()
  let toc-first = toc-a.len() > 0 and pg == toc-a.first().location().page()
  let heads = query(heading.where(level: 1).or(heading.where(level: 2)))
  if toc-first or heads.any(h => h.level == 1 and on-page(h)) {
    none
  } else if in-toc {
    sem-header-box[目次]
  } else {
    let here-secs = heads.filter(h => h.level == 2 and on-page(h))
    let before = heads.filter(h => h.location().page() < pg)
    let mark = if here-secs.len() > 0 {
      here-secs.first()
    } else if before.len() > 0 and before.last().level == 2 {
      before.last()
    } else {
      none
    }
    if mark != none { sem-header-box(mark.body) }
  }
}

#set page(
  header: _sem-header(),
  footer: context align(center, text(size: 10.5pt, counter(page).display())),
)

// ── 表紙・目次（report_template.typst から呼ぶ）──────────────────────────
// 表紙は柱・ノンブルなしの 1 ページ。次のページからノンブル 1 始まり。
#let sem-cover(body) = {
  page(header: none, footer: none, body)
  counter(page).update(1)
}

// 目次: 新しいページから、「目次」20pt 中央 → 0.5pt の線 → 一覧。
#show outline.entry.where(level: 1): it => {
  v(0.6em, weak: true)
  strong(it)
}
#let sem-toc(depth: 3) = {
  pagebreak(weak: true)
  [#metadata("toc") <sem-toc-start>]
  align(center, sem-heading-text(19.2pt)[目次])
  v(1.5mm, weak: true)
  line(length: 100%, stroke: 0.5pt)
  v(10pt)
  outline(title: none, depth: depth)
  [#metadata("toc") <sem-toc-end>]
  pagebreak(weak: true)
}

// PDF の文書プロパティ（pptmdmerge が COVER_* と metadata: から作る。_pdf_metadata.py）
#set document(title: "PDF生成時に表紙と目次をつける方法", author: ("開米瑞浩",), description: "Markdown からPDFを生成するときに 表紙と目次をつける方法の解説とサンプル")
#set text(lang: "ja")
#sem-cover[
#v(16mm)
#semcenter[
#box(image("images/cover_image.webp", width: 80.0%))

]
#v(22.7mm)
#align(center, text(font: sem-fonts.sans, weight: "bold", size: 23.9pt)[
PDF生成時に表紙と目次をつける方法

])
#v(-1mm)
#align(center, text(size: 16.6pt)[
Markdown
からPDFを生成するときに#linebreak();表紙と目次をつける方法の解説とサンプル

])
#v(7.4mm)
#align(center, text(size: 11.5pt)[
作成日：2026-11-28 07:50:54

])
#v(6mm)
#align(center, text(size: 11.5pt)[
著者：開米瑞浩

所属：アイデアクラフト

])
#v(10mm)
indexer.pptxnumbering の設定で表紙と目次をつける方法を指定できます。

#v(10mm)
#semcenter[
#box(image("images/cover_footerimage.webp", width: 80.0%))

]

]
#sem-toc(depth: 2)

= 1) 表紙と目次をつける方法
<1-表紙と目次をつける方法>
#semcenter[
#sem-box("widequote", width: 70%)[
Markdown文書をPDF化する際に表紙と目次をつける方法について解説します。

]
]
#v(2 * 1.65em)
#semcenter[
#sem-box("widequote", width: 80%)[
- 1.1) PDF生成時に表紙と目次をつけたい
- 1.2) 表紙と目次をつけるためのレシピYAML
- 1.3) 目次設定項目
- 1.4) 章節番号付与のしくみ
- 1.5) 「章とびら」 のしくみ
- 1.6) 生成処理の実行
- 1.7) ソースPPTX、生成指示YAML、および成果物MDとPDF

]
]
#v(1fr)
#pagebreak(weak: true)
== 1.1) PDF生成時に表紙と目次をつけたい
<11-pdf生成時に表紙と目次をつけたい>
たとえば集合研修やイベント講演時にテキスト/資料を配付するときなど、Markdownファイルのままで読者に見てもらうのではなく、印刷して紙媒体で、あるいはPDF化して配付したい場合があります。

PDF形式なら印刷もすぐできますから、 「とりあえずPDF化」
だけでもいいのですが、このときに 「表紙と目次をつけたいなあ・・・」
ということがよくあります。

#v(1 * 1.65em)
Markdown
にはページという概念がなく、延々とスクロールする縦長のコンテンツであり、リンクを使って自由にジャンプできるし検索もできるのに対して、紙媒体ではリンクも検索も効きません。そのため長くなればなるほど目次が重要であり、
紙はページ単位ですので目次を付けるためにはページの管理が必要です。
また、表紙と目次があるだけでも文書の信頼性は一段階上がるものです。

#v(1 * 1.65em)
#semcenter[
#box(image("images/102-cover-index_slide2.webp", width: 100.0%))

]
#v(1 * 1.65em)
つまり、

- 表紙をつけたい
- 目次をつけたい
- ページ単位に区切りたい

というニーズがあります。
3つめは実際に技術解説テキストのような教材を作ってみるとわかりますが、できるだけコンテンツを小テーマごとにページ単位で完結するように作りたくなるのです。そのほうが読者の脳に余計な負担を掛けずに済むからです。
そのため、PDF化の際にページ区切りを調整する必要があります。そこで
ppt-md-merger
にはこれらの機能を持たせています。　当サンプルでは表紙と目次の付与について解説します。
ページ区切りについては別サンプルで扱います。

#v(1fr)
#pagebreak(weak: true)
== 1.2) 表紙と目次をつけるためのレシピYAML
<12-表紙と目次をつけるためのレシピyaml>
表紙と目次をつけるには、レシピYAMLに必要項目を設定します。

#v(1 * 1.65em)
#semcenter[
#box(image("images/102-cover-index_slide3.webp", width: 100.0%))

]
vars: は任意の変数を定義するセクションで、 COVER\_\*
変数は表紙テンプレート用の変数です。この内容を書き換えると表紙の文言が変わります。

report\_base\_defaults\_toc2level.yaml
はPDF生成に使用する文書変換プログラム、Pandoc
関係の標準設定ファイルで、２階層（章・節レベルまで）の目次を作る設定を含むものです。

この種の設定項目は複数の文書で共通になることが多いため、通常は文書とは別のフォルダに共通設定ファイルとしてまとめておき、複数の文書レシピYAMLから参照できるようにします。その共通設定フォルダが
data-dir: で、その中の defaults: が Pandoc設定ファイルです。

表紙をつけるには cover\_md: を設定します。 cover\_standard.md は
ppt-md-merger 同梱のシンプルな表紙レイアウトです。 COVER\_\*
変数は、この cover\_standard.md の中で参照されます。
独自の表紙レイアウトを作る際はこのファイルをコピーして修正するとよいでしょう。

#v(1fr)
#pagebreak(weak: true)
== 1.3) 目次設定項目
<13-目次設定項目>
=== 1.3.1) レシピYAML内の章節番号付与方式設定部分
<131-レシピyaml内の章節番号付与方式設定部分>
pptxnumbering: idresolve を設定すると、 MD ファイル中の \#id
マーカーを認識して章節番号を付与します。

autoid: true は、MDファイル中の \#, \#\#, \#\#\# 見出しに自動的に \#id
マーカーを付与します。
trueをコーテーションで囲わないように注意してください。

#v(1 * 1.65em)
#semcenter[
#box(image("images/102-cover-index_slide4_range1.webp", width: 70.0%))

]
=== 1.3.2) report\_base\_defaults\_toc2level.yaml 内の目次設定項目
<132-report_base_defaults_toc2levelyaml-内の目次設定項目>
data-dir: と defaults: で参照する pandoc
設定ファイル、report\_base\_defaults\_toc2level.yaml
内の目次設定項目です。

toc: true で目次あり、falseで目次なしです。

toc-depth:
は目次の階層数です。数字を大きくすると、より深い目次（小さな項目まで含む目次）を作ります。

#v(1 * 1.65em)
#semcenter[
#box(image("images/102-cover-index_slide4_range2.webp", width: 70.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 1.4) 章節番号付与のしくみ
<14-章節番号付与のしくみ>
この章節番号付与のしくみは以下のようなものです。 原稿pptx
から切り出された素材MD(mds/102-cover-index\_slide1.md)
の段階ではMD見出しのみがあり、番号はついていません。

次に結合処理の途中で(build/work\_102-cover-index\_target\_merged.md)、\#,
\#\#, \#\#\# の各レベルの見出しに \#id を自動付与します。これは autoid:
true の作用です。 なお、work\_102-cover-index\_target\_merged.md
というファイルはMD結合処理の途中で生成される作業用ファイルで、すぐに削除されるため通常はビルドの中には残りません。pptmdmerge
コマンド実行時に --keep-work
というオプションをつけると削除されずに残ります。

その後、この \#id を解析して章節番号を付与します。
最終的に生成される結合MD(build/102-cover-index\_target\_rendered.md)では、\#id
がコメント化されてMDビューアーやPDF上では見えなくなる一方、見出しには
"\# 1) 表紙" のように番号が付与されています。

#v(1 * 1.65em)
#semcenter[
#box(image("images/102-cover-index_slide5.webp", width: 80.0%))

]
#v(1 * 1.65em)
これが pptxnumbering: idresolve と autoid: true の効果です。
MDの章節番号を手打ちするのは加筆や削除に弱いのですが、この方式なら自動付与なので手間が省けます。

#v(1fr)
#pagebreak(weak: true)
== 1.5) 「章とびら」 のしくみ
<15-章とびら-のしくみ>
章ごとに先頭に 「章とびら」
という独立ページをつけて、その章の概要と、含まれる節のリストを載せると、プロが編集した書籍のように見えるし読みやすくもなります。

ppt-md-merger には章とびらを作るための sectionlist
という機能があります。

実際に作られる章とびらの例が下記です。

#v(1 * 1.65em)
#semcenter[
#box(image("images/102-cover-index_slide6.webp", width: 80.0%))

]
#v(1 * 1.65em)
このようなとびらページを作るには、MD上の 見出しレベルを最上位 '\#'
にします。 通常のコンテンツは '\#\#' で記述しますが、 '\#'
を使うとページ自体のレイアウトが変わり、章とびら用のレイアウトになってタイトル部分が中央に大きく表示されます。

節リストを表示するには MDテキスト中に

```
{{sectionlist}}
```

と書きます。具体例は当サンプルの原稿PPTXを開いて、章とびらに該当するページの
note を確認してください。

#v(1fr)
#pagebreak(weak: true)
== 1.6) 生成処理の実行
<16-生成処理の実行>
以下の命令で生成を実行します。サブコマンド ppt\_build
の引数に生成指示書を指定します。

#v(1 * 1.65em)
```bash
cd cases\102-cover-index\src
pptmdmerge ppt_build 102-cover-index_recipe.yaml
```

#v(1 * 1.65em)
「WARNING: YAML ファイルが見つかりません」
という警告は出ても問題ありません。

この命令で生成されるのは renderedfilename で指定する Rendered MD です。

オプションを追加すると、PDFやGitHubMDも生成します。

#v(1 * 1.65em)
```bash
cd cases\102-cover-index\src
pptmdmerge ppt_build 102-cover-index_recipe.yaml --pdf --github --transfer
```

#v(1 * 1.65em)
#semterm[オプションなし]; Rendered MD のみ生成する

#semterm[--pdf]; Rendered MD をもとにPDFを生成する

#semterm[--github]; Rendered MD をもとにGitHub用MDを生成する

#semterm[--transfer];
生成したMDを他の場所に転送するオプション。当サンプルでは、GitHubMD
をもとに README.md を作るために使用する。

Rendered, PDF, GitHubMD 等の関係については次項の図をご覧ください。

#v(1fr)
#pagebreak(weak: true)
== 1.7) ソースPPTX、生成指示YAML、および成果物MDとPDF
<17-ソースpptx生成指示yamlおよび成果物mdとpdf>
当サンプルのソースと成果物を以下のリンクで確認できます。

=== 1.7.1) ソース
<171-ソース>
#semterm[生成指示];
#link("src/102-cover-index_recipe.yaml")[102-cover-index\_recipe.yaml]

#semterm[原稿PPTX];
#link("src/102-cover-index.pptx")[102-cover-index.pptx]

=== 1.7.2) 成果物
<172-成果物>
MDは何種類か異なる仕様で生成します。 Rendered
MDはPPTXソースから切り出したMDにさまざまな加工を加えた生成物で、豊富な書式指示を含んでいます。
それらの書式指示をすべて落として GitHub
での表示に特化したのがGitHub用MDです。

#semterm[Rendered MD];
#link("build/102-cover-index_target_rendered.md")[102-cover-index\_target\_rendered.md]

#semterm[GitHub用MD];
#link("build/102-cover-index_target_github.md")[102-cover-index\_target\_github.md]

#semterm[PDF];
#link("build/102-cover-index_target.pdf")[102-cover-index\_target.pdf]

#semterm[README]; 今、あなたがGitHubで読んでいるこのファイルです

#semcenter[
#box(image("images/102-cover-index_slide8.webp", width: 100.0%))

]
当サンプルはPDF化時に表紙・目次・章節番号を自動付与するサンプルですので、「PDF」
のpdfを開いてそれらの状態を確認し、次いで 生成指示YAMLを開いて vars: と
cover-md:, defaults: , indexer: を確認してください。
また、原稿PPTXを開いて章とびらページのMDテキスト、表紙用画像の章を確認してください。

#v(1fr)
#pagebreak(weak: true)
= 2) 表紙用画像の章
<2-表紙用画像の章>
#semcenter[
#sem-box("widequote", width: 70%)[
この章は表紙用画像制作用で、本文のコンテンツとしては不要なパートですが、章・節番号を付与して目次をつけるサンプルとしては意味があるので、PDFにも掲載しておきます。

]
]
#v(2 * 1.65em)
#semcenter[
#sem-box("widequote", width: 80%)[
- 2.1) COVER\_IMAGE
- 2.2) COVER\_FOOTERIMAGE

]
]
#v(1fr)
#pagebreak(weak: true)
== 2.1) COVER\_IMAGE
<21-cover_image>
表紙上部に載せたい画像をこのスライドで制作し、cover\_image.webp
という名前で切り出します。 そのファイルをレシピYAMLの COVER\_IMAGE:
変数で指定すると、表紙上部に差し込まれます。

#v(1 * 1.65em)
#semcenter[
#box(image("images/cover_image.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 2.2) COVER\_FOOTERIMAGE
<22-cover_footerimage>
表紙上部に載せたい画像をこのスライドで制作し、cover\_footerimage.webp
という名前で切り出します。 そのファイルをレシピYAMLの
COVER\_FOOTERIMAGE: 変数で指定すると、表紙下部に差し込まれます。

#v(1 * 1.65em)
#semcenter[
#box(image("images/cover_footerimage.webp", width: 100.0%))

]
