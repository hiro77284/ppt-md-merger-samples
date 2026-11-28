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

// ── 巻末索引（bookindex。docs/design_book_index.md）──────────────────────
// filters/bookindex.lua が印の位置に #metadata("見出し語")<sem-index> を置き、
// pandoc 段が {{printindex}} を #sem-bookindex(groups: ...) に展開する（並び順と
// グループは bookindexcollect が決めたもの）。ページ番号は組版時に query で集める。
#let sem-index-head-color = luma(30%)

// 見出し語 key のページ番号（本文へのリンク付き）。同じページは 1 回だけ。
// page-range: true なら連続するページを「12–14」にまとめる。表示はそのページの番号形式に従う。
#let sem-index-pages(key, page-range: true) = context {
  let items = ()
  let seen = ()
  for m in query(<sem-index>) {
    if m.value != key { continue }
    let loc = m.location()
    let phys = loc.page()
    if phys in seen { continue }
    seen.push(phys)
    let fmt = loc.page-numbering()
    let nums = counter(page).at(loc)
    let disp = if fmt == none { str(nums.first()) } else { numbering(fmt, ..nums) }
    items.push((phys: phys, n: nums.first(), fmt: fmt, disp: disp, loc: loc))
  }
  let runs = ()
  for it in items {
    let joined = false
    if page-range and runs.len() > 0 {
      let prev = runs.last().last()
      if it.phys == prev.phys + 1 and it.n == prev.n + 1 and it.fmt == prev.fmt {
        runs.last().push(it)
        joined = true
      }
    }
    if not joined { runs.push((it,)) }
  }
  if runs.len() == 0 {
    [—]
  } else {
    runs.map(r => {
      let a = r.first()
      let b = r.last()
      if r.len() == 1 { link(a.loc, a.disp) } else { link(a.loc, a.disp) + [–] + link(b.loc, b.disp) }
    }).join([, ])
  }
}

// 索引ページの本体。groups は ((head: "A" | none, keys: ("語", ...)), ...)。
#let sem-bookindex(groups: (), columns: 2, page-range: true) = {
  set par(first-line-indent: 0pt, justify: false, leading: 0.5em, spacing: 0.5em)
  let body = for g in groups {
    if g.head != none {
      block(above: 1.1em, below: 0.5em, sticky: true,
        text(font: sem-fonts.sans, weight: "bold", fill: sem-index-head-color, g.head))
    }
    for k in g.keys {
      block(above: 0.35em, below: 0.35em, breakable: false,
        [#k#box(width: 1fr, inset: (x: 0.3em), repeat[.])#sem-index-pages(k, page-range: page-range)])
    }
  }
  if columns > 1 { std.columns(columns, gutter: 2em, body) } else { body }
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
#set document(title: "大きなPPTXファイルに章・節番号を付番する", author: ("アイデアクラフト",), description: "ページ数の多いPPTXファイルに自動的に章・節番号を付番する方法の解説とサンプル")
#set text(lang: "ja")
#sem-cover[
#v(16mm)
#align(center, text(font: sem-fonts.sans, weight: "bold", size: 23.9pt)[
大きなPPTXファイルに章・節番号を付番する

])
#v(-1mm)
#align(center, text(size: 16.6pt)[
ページ数の多いPPTXファイルに自動的に章・節番号を付番する方法の解説とサンプル

])
#v(7.4mm)
#align(center, text(size: 11.5pt)[
作成日：2026-11-28 13:24:56

])
#v(6mm)
#align(center, text(size: 11.5pt)[
著者：アイデアクラフト

])

]
#sem-toc(depth: 2)

= 1) PPTXへの章節番号付番のみ(PDF化しない)
<1-pptxへの章節番号付番のみpdf化しない>
#semcenter[
#sem-box("widequote", width: 70%)[
MarkdownやPDF出力を行わず、PPTXへの章節番号付番のみ行う方法を解説します。

]
]
#v(2 * 1.65em)
#semcenter[
#sem-box("widequote", width: 80%)[
- 1.1) 単にPPTXに章節番号をつけたいだけ
- 1.2) 複数のPPTXをひとつにまとめて章節番号をつけたい
- 1.3) 基本は「章・節」方式
- 1.4) CHAPT マーカーで章を切替える
- 1.5) 章とびら無しなら CHAPT と SECTION を書く
- 1.6) 番号カウントの抑制
- 1.7) 番号付与の抑制
- 1.8) PPTXのみの番号付与を行うレシピYAML
- 1.9) 注意！　MD、PDF生成時はchapt\_sectionは使えない
- 1.10) 注意！　付番されるのは「タイトル」属性を持つシェイプのみ
- 1.11) 生成処理の実行
- 1.12) ソースPPTX、生成指示YAML、および成果物PPTX

]
]
#v(1fr)
#pagebreak(weak: true)
== 1.1) 単にPPTXに章節番号をつけたいだけ
<11-単にpptxに章節番号をつけたいだけ>
大きなPPTXを作っているとよく遭遇するのが、
「単に章・節番号をつけたいだけなのに自動的にできない」 という問題です。

Word
にはアウトラインで自動的に章・節・項以下の番号を振る機能がありますが、それに該当する機能がPowerPointにはありません。
そこでやむなく手作業で番号を振るのはなかなかにうんざりする作業です。

#v(1 * 1.65em)
#semcenter[
#box(image("images/105-pptx-numbering_slide2.webp", width: 80.0%))

]
#v(1 * 1.65em)
作者は必要に迫られて何度となくこの作業をやりましたが、率直に言って
「もうやりたくねえ！」 というのが本音です。

#v(1fr)
#pagebreak(weak: true)
== 1.2) 複数のPPTXをひとつにまとめて章節番号をつけたい
<12-複数のpptxをひとつにまとめて章節番号をつけたい>
さらに、元ネタになるPPTXが複数あって、それらをまとめて1つの長いPPTXを作り、そこに付番したいというケースもよくあります。

#v(1 * 1.65em)
#semcenter[
#box(image("images/105-pptx-numbering_slide3.webp", width: 80.0%))

]
#v(1 * 1.65em)
単純なタスクではありますが、それだけにやりたくない作業です。
なんとか結合と付番を自動的に行う方法はないのでしょうか？　というわけで
ppt-md-merger
にはその機能もつけました。この機能は画像やMarkdownの切り出し、結合、PDF化等を行わないので、noteを書く必要もなく、レシピYAMLの設定も簡単です。

#v(1fr)
#pagebreak(weak: true)
== 1.3) 基本は「章・節」方式
<13-基本は章節方式>
基本的なしくみとしては、章・節
の2階層でスライドタイトルに番号を付与します。 PowerPoint
の一般的な用法では 「節」
に該当するスライドを書く比率が最も高いと思われるため、節番号は何もしなくても自動的に増えていく仕様です。

#v(1 * 1.65em)
#semcenter[
#box(image("images/105-pptx-numbering_slide4.webp", width: 100.0%))

]
では、章が変わるときはどうすればよいのでしょうか？

#v(1fr)
#pagebreak(weak: true)
== 1.4) CHAPT マーカーで章を切替える
<14-chapt-マーカーで章を切替える>
新しい章の最初のスライドのどこかに CHAPT
というマーカー文字列を書いておきます（実際は '\#'
記号で挟んで書きます)。すると自動付番後は章番号が変わり、マーカーは消えます。

次のスライドからは再び節番号が増えていくようになります。

#v(1 * 1.65em)
#semcenter[
#box(image("images/105-pptx-numbering_slide5.webp", width: 100.0%))

]
ただしこれは 「章とびら」 を置くスタイルです。 章とびらは
「その章全体の概要を示すページ」
であり、節とは異質なページなので番号仕様も "2)"
のように章番号だけを使います。

一方、編集方針によっては章とびらを置かずに、1.2) からいきなり 2.1)
へ変わるようなスタイルもあります。その場合はどうすればよいのでしょうか？

#v(1fr)
#pagebreak(weak: true)
== 1.5) 章とびら無しなら CHAPT と SECTION を書く
<15-章とびら無しなら-chapt-と-section-を書く>
章とびらを置かないスタイルの時は、新章開始スライドで CHAPT と SECTION
の両方を書くと、章とびらなしで節から始まります。(SECTION
を単独で使うと、節番号を1にリセットします）

#v(1 * 1.65em)
#semcenter[
#box(image("images/105-pptx-numbering_slide6.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 1.6) 番号カウントの抑制
<16-番号カウントの抑制>
番号のカウントアップを止めたい場合は STAY と書きます。
複数のスライドに同一番号を付与したい場合に使います。

#v(1 * 1.65em)
#semcenter[
#box(image("images/105-pptx-numbering_slide7.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 1.7) 番号付与の抑制
<17-番号付与の抑制>
一部のスライドに番号を付与しない場合は NONUMBERING と書きます。
そのスライドでのみ、タイトルへの番号付与が止まります。
ただし番号カウントアップ自体は行うので、「抜け番」がある状態になります。

#v(1 * 1.65em)
#semcenter[
#box(image("images/105-pptx-numbering_slide8.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 1.8) PPTXのみの番号付与を行うレシピYAML
<18-pptxのみの番号付与を行うレシピyaml>
PPTXのみの番号付与を行うレシピYAMLの例です。
PDF関係の設定は必要ありません。

#v(1 * 1.65em)
#semcenter[
#box(image("images/105-pptx-numbering_slide9.webp", width: 100.0%))

]
#v(1 * 1.65em)
indexer.pptxnumbering: に　"chapt\_section" を指定します。

output.pptxfilename:
に、最終生成されるPPTXファイル名を指定してください。
原稿PPTXとダブらないようにします。

force: true は既存ファイルがあっても上書きします。

procedure.insertPPTX: に原稿PPTXを指定します。

全スライドを出力する場合は slides: all
です。一部のスライドのみ必要な場合は、 1-99 のような From-to 記法か、
1,2,5,6 とカンマで区切って列挙してください。　3-END
と書くと、3番目以降全部になります。 ただし -END
という記法の最大値は既定で99なので、それを超えるスライド数がある場合は
range-max で明示します。

原稿PPTXは複数あってもかまいません。

#v(1fr)
#pagebreak(weak: true)
== 1.9) 注意！　MD、PDF生成時はchapt\_sectionは使えない
<19-注意-mdpdf生成時はchapt_sectionは使えない>
#sem-box("warning")[
chapt\_section方式が使えるのは、PDFのみを生成する場合です。MD、PDFも生成するときは
idresolve を使ってください。

]
#semcenter[
#box(image("images/105-pptx-numbering_slide10.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 1.10) 注意！　付番されるのは「タイトル」属性を持つシェイプのみ
<110-注意-付番されるのはタイトル属性を持つシェイプのみ>
#sem-box("warning")[
付番されるのは「タイトル」属性を持つシェイプのみ

]
#semcenter[
#box(image("images/105-pptx-numbering_slide11.webp", width: 100.0%))

]
シェイプ（PowerPointの図形）の中にはスライドごとに1つ、タイトル属性を持つものがあります。
未入力時に 「タイトルを入力」
というガイドメッセージが出るものがそれです。
通常、新スライドを追加すると一番上にあって目立ちますね。

ppt-md-merger
の番号付番はタイトルシェイプに対して行うので、それがないときは付番されません。　いったんタイトルシェイプを削除して、代わりに同じ位置に長方形シェイプを置くと、一見タイトルに見えてもそれはタイトル属性を持たないただの長方形なので付番されません。

タイトルシェイプをコピペしてもタイトル属性が外れます。
スライドの内容をコピペしてタイトルを作り直したときに、この問題が起きやすいのでご注意ください。
一部のスライドのみ番号付番が行われない場合はこの現象を疑ってください。

#v(1fr)
#pagebreak(weak: true)
== 1.11) 生成処理の実行
<111-生成処理の実行>
以下の命令で生成を実行します。 このサンプルでは chapt\_section 方式の
PPTX のみの生成を行うので、サブコマンドは pptmerge です。

#v(1 * 1.65em)
```bash
cd cases\105-pptx-numbering\src
pptmdmerge pptmerge 105-example_recipe.yaml
```

#v(3 * 1.65em)
付番前と付番後のPPTXファイルの一部を示します。

#v(1 * 1.65em)
#semcenter[
#box(image("images/105-pptx-numbering_slide12.webp", width: 100.0%))

]
#v(1 * 1.65em)
#v(1fr)
#pagebreak(weak: true)
== 1.12) ソースPPTX、生成指示YAML、および成果物PPTX
<112-ソースpptx生成指示yamlおよび成果物pptx>
当サンプルのソースと成果物を以下のリンクで確認できます。

=== ソース
<ソース>
#semterm[生成指示];
#link("src/105-example_recipe.yaml")[105-example\_recipe.yaml]

#semterm[原稿PPTX]; #link("src/105-example1.pptx")[105-example1.pptx],
#link("src/105-example2.pptx")[105-example2.pptx]

=== 成果物
<成果物>
当サンプルはPPTXの生成のみを行い、MDやPDFは生成しません。

#semterm[付番後PPTX];
#link("build/105-example_target.pptx")[105-example\_target.pptx]

#semterm[README]; 今、あなたがGitHubで読んでいるこのファイルです

#semcenter[
#box(image("images/105-pptx-numbering_slide13.webp", width: 100.0%))

]
原稿PPTXと付番後PPTXを開いて CHAPT や NONUMBERING, SUBSECTION
がどう働くかを確認してください。

また、原稿PPTXにはnoteが書かれていないことも確認してください。

複数の原稿PPTXが結合されて、それらが続き番号として一貫した付番が行われていることを確認してください。
