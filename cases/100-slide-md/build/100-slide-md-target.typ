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
#set document(title: "パワポで画像とMarkdownを一括制作", author: ("開米瑞浩",), description: "技術解説画像入りMarkdown制作のメンドクササを解消")
#set text(lang: "ja")
#sem-cover[
#v(16mm)
#align(center, text(font: sem-fonts.sans, weight: "bold", size: 23.9pt)[
パワポで画像とMarkdownを一括制作

])
#v(-1mm)
#align(center, text(size: 16.6pt)[
技術解説画像入りMarkdown制作のメンドクササを解消

])
#v(7.4mm)
#align(center, text(size: 11.5pt)[
作成日：2026-11-22 10:50:54

])
#v(6mm)
#align(center, text(size: 11.5pt)[
著者：開米瑞浩

])
#v(10mm)
スライドに画像を描き、noteにMarkdownを書いてそれを組み合わせた Markdown
原稿を自動生成する事例です。

]
#sem-toc(depth: 2)

== パワポスライドにMDテキストをつけて一括合成
<パワポスライドにmdテキストをつけて一括合成>
技術解説文書を書くときは、要点箇条書きスライドだけでは足りません。精密な図解に加えて文章による詳細解説も必要なのが普通です。

そこで欲しくなるのが図解入りMarkdownファイルです。

本書はPPTXで図解＋Markdownを制作した後、それを自動的に分解結合して１つの長い図解入りMarkdownファイルを作るサンプルです。

#v(1 * 1.65em)
#semcenter[
#box(image("images/100-slide1.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== スライドに図を書き、noteにMarkdownを書く
<スライドに図を書きnoteにmarkdownを書く>
基本的なしくみは、スライドに図を書いてnoteにMarkdownを書き、Markdownテキスト内で図を参照するというものです。

#v(1 * 1.65em)
#semcenter[
#box(image("images/100-slide2.webp", width: 100.0%))

]
#v(1 * 1.65em)
noteというのはPowerPointファイル(PPTX)のスライドごとに付属する、文章でちょっとしたメモ書きを書いておける領域です。そこに図の詳細解説をMarkdownで書きます。

このときに一定の書式を使うことで、Markdown中でスライドの図を参照します。

#v(1fr)
#pagebreak(weak: true)
== 長方形シェイプを使って画像切り出し範囲を示す
<長方形シェイプを使って画像切り出し範囲を示す>
スライド側では、切り出したい画像の背後に切り出し範囲を示す長方形シェイプを置き、そこに名前をつけます。
シェイプに名前をつけるには、シェイプ選択後に
「編集→選択→オブジェクトの選択と表示」 で出てくる名前を変更します。

他のシェイプと区別できればどんな名前でもかまいませんが、当サンプルでは例として
exportrange という名前を使います。

#v(1 * 1.65em)
#semcenter[
#box(image("images/100-slide3.webp", width: 100.0%))

]
#v(1 * 1.65em)
ppt-md-merger
はこの範囲を単独の画像ファイルとして自動的に切り出します。それをMarkdownテキストで参照すればよいわけです。

では次に Markdownテキスト側の書き方を確認しましょう。

#v(1fr)
#pagebreak(weak: true)
== noteに画像切り出し指示とMarkdownを書く
<noteに画像切り出し指示とmarkdownを書く>
note側に画像切り出し指示とMarkdownを書きます。

1行目の "NOTE\_CONTENT\_FORMAT: 1.0" は、この note の内容を
ppt-md-merger への指示として解析しろ、という命令です。

note のテキストは "===BLOCK===" で区切り、各ブロックの1行目は
“{{BLOCK:\*}}” の書式でブロックの種類を示します。

"{{BLOCK:IMAGE}}"
はそのブロックが画像切り出し指示であることを意味します。ここで、画像として切り出す範囲
exportrange と、ファイル名（パス）も指定します。

#v(1 * 1.65em)
#semcenter[
#box(image("images/100-slide4.webp", width: 100.0%))

]
#v(1 * 1.65em)
"{{BLOCK:MD}}" はそのブロックがMarkdownテキストであることを意味します。
出力するMarkdownファイルのパスを "export-note" で指定します。

次の行から次のブロックまで（またはnote末尾まで)をMarkdownテキストとして出力します。

このMarkdownテキストの中に画像参照コードを書くことで、切り出したスライド画像を参照できます。

#v(1fr)
#pagebreak(weak: true)
== ソースPPTX、生成指示YAML、および成果物MDとPDF
<ソースpptx生成指示yamlおよび成果物mdとpdf>
当サンプルのソースと成果物を以下のリンクで確認できます。

=== ソース
<ソース>
#semterm[生成指示];
#link("src/100-slide-md_pdf_recipe.yaml")[100-slide-md\_pdf\_recipe.yaml]

#semterm[画像とMD]; #link("src/100-slide-md.pptx")[100-slide-md.pptx]

=== 成果物
<成果物>
MDは何種類か異なる仕様で生成します。 Rendered
MDはPPTXソースから切り出したMDにさまざまな加工を加えた生成物で、豊富な書式指示を含んでいます。
それらの書式指示をすべて落として GitHub
での表示に特化したのがGitHub用MDです。

#semterm[Rendered MD];
#link("build/100-slide-md-target-rendered.md")[100-slide-md-target-rendered.md]

#semterm[GitHub用MD];
#link("build/100-slide-md-target-github.md")[100-slide-md-target-github.md]

#semterm[PDF];
#link("build/100-slide-md-target.pdf")[100-slide-md-target.pdf]

#semcenter[
#box(image("images/100-slide5.webp", width: 100.0%))

]
当サンプルは主に 「PPTXに画像とMDを記載できる」
ことを説明するサンプルですので、「画像とMD」
のpptxを開いて画像とMDのブロックを確認し、それが 「Rendered」
MDでどのようになっているかを確認してみてください。
