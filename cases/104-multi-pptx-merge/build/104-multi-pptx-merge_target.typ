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
#set document(title: "複数の原稿PPTXをマージしてPDFおよび単一のPPTXを生成する方法", author: ("開米瑞浩",), description: "複数の原稿PPTXをマージして、章節構造で付番されたPDFと単一のPPTXを同じ構成で生成する方法の解説とサンプル")
#set text(lang: "ja")
#sem-cover[
#v(16mm)
#align(center, text(font: sem-fonts.sans, weight: "bold", size: 23.9pt)[
複数の原稿PPTXをマージしてPDFおよび単一のPPTXを生成する方法

])
#v(-1mm)
#align(center, text(size: 16.6pt)[
複数の原稿PPTXをマージして、章節構造で付番されたPDFと単一のPPTXを同じ構成で生成する方法の解説とサンプル

])
#v(7.4mm)
#align(center, text(size: 11.5pt)[
作成日：2026-11-27 11:42:30

])
#v(6mm)
#align(center, text(size: 11.5pt)[
著者：開米瑞浩

所属：アイデアクラフト

])
#v(10mm)
マージするための merge.dirs と、PDFとPPTXを生成するための procedure
の設定方法を解説します

]
#sem-toc(depth: 2)

= 1) PPTXとPDFの同一構成マージ
<1-pptxとpdfの同一構成マージ>
#semcenter[
#sem-box("widequote", width: 70%)[
複数の原稿PPTXをマージして配布用PDFと講師用PPTXを作る際、両者を同じ章・節番号つきの同一構成で作る方法を解説します。

]
]
#v(2 * 1.65em)
#semcenter[
#sem-box("widequote", width: 80%)[
- 1.1) 複数の原稿PPTXから単一のPDFとPPTXを作りたい
- 1.2) 配布用PDFと講師用PPTXへの章節番号付与のしくみ
- 1.3) ユニークな id 付与のしくみ
- 1.4) 複数の原稿PPTXを source に指定する
- 1.5) 複数の原稿PPTXをマージ(結合)する
- 1.6) 生成処理の実行
- 1.7) ソースPPTX、生成指示YAML、および成果物MDとPDF

]
]
#v(1fr)
#pagebreak(weak: true)
== 1.1) 複数の原稿PPTXから単一のPDFとPPTXを作りたい
<11-複数の原稿pptxから単一のpdfとpptxを作りたい>
企業研修等で数時間以上の長い講座を行うときによくあるのがこんなニーズです。

ひとつの研修の中では複数の小テーマを扱う。
それらはそれぞれ別の原稿PPTXになっている。
けれど研修業務のオペレーションを回しやすくするためには、それを1冊のPDFにして印刷したい。
バラバラに印刷して組み合わせる手間を掛けたくないからです。

そこで、複数の原稿PPTXを自動的に結合・変換して1つのPDFにまとめるようにしたいんですね。

そのときついでに表紙と目次もつけます。　さらに章節番号もつけます。テーマごとにひとつの章にして、1章1節、2章1節・・・と、番号を付加する。

さらに・・・！！

#v(1 * 1.65em)
#semcenter[
#box(image("images/104-multi-pptx-merge_slide2.webp", width: 100.0%))

]
もうひとつ欲しいのが、同一構成の講師用PPTXです。
受講者に配付するPDFと同じ順番で1つにまとまり、同じ章節番号がついた講師用PPTXが欲しい。
それがあれば、次ページ・次ページと繰り返すだけで全ページをたどれます。
また、「次は3章4節です」
と、章節番号で案内で来て、その数字がプロジェクターの投影画面にも出るので受講者は迷わずに済みます。

さらに、PDF側には詳細説明テキストも含めたいですね。
投影して口頭説明を加える講師用PPTXの側には要点だけでいいとしても、
「今日の講座で省略した部分は、各自自分で読んで理解してください」
と案内できるようにするためには、配布用PDFには詳細説明が必要です。

こんなことができるのでしょうか？　もちろん、できます。
そもそもそのために ppt-md-merger を作ったのですから。

#v(1fr)
#pagebreak(weak: true)
== 1.2) 配布用PDFと講師用PPTXへの章節番号付与のしくみ
<12-配布用pdfと講師用pptxへの章節番号付与のしくみ>
しくみはこうです。

#v(1 * 1.65em)
#semcenter[
#box(image("images/104-multi-pptx-merge_slide3.webp", width: 100.0%))

]
原稿PPTXのnoteにMDテキストを書く際、そこに #semterm[id];
を付与しておきます。id
とは、そのMDがどの原稿PPTXファイルの、どのスライドのものかを特定するキーです。

その id
は原稿PPTXから切り出した個別MDにも含まれていて、それを結合した結合MDには複数のidが含まれます。

次いで、結合MDからidを収集したファイルを作り（idcollect
YAML）、そこに章節番号を付与します（idresolve　YAML、2.1は2章1節の例）。

結合MDを加工して rendered MD
を作る時に\#idをキーにして章節番号を反映させると rendered MD
は章節番号つきの状態になります。
それをPDFに変換するので、配布用PDFも章節番号つきになります。

一方、講師用PPTXも複数の原稿PPTXを結合して作ります。
この結合命令と個別MDの結合命令は同じレシピYAMLの同じ場所に記載できるので整合性を保てます。
このとき講師用PPTXにもidをキーにして番号を反映させることにより、配布用PDFと同一構成で同じ章節番号を付与した講師用PPTXを生成できます。

この動作は原稿PPTXが複数あっても id がユニークなら問題なく機能します。

#v(1fr)
#pagebreak(weak: true)
== 1.3) ユニークな id 付与のしくみ
<13-ユニークな-id-付与のしくみ>
複数の原稿PPTXにまたがってスライドごとにユニークな id
を付与するしくみを解説します。

#v(1 * 1.65em)
#semcenter[
#box(image("images/104-multi-pptx-merge_slide4.webp", width: 100.0%))

]
#v(1 * 1.65em)
note に MD を書き出す {{BLOCK:MD}} ブロックで、以下の表記を使えます。

```plain
<__BASEFILENAME__> 拡張子を除くファイル名へと置換される
<__SLIDENUM__> スライド番号へと置換される
```

そこで、id
を上図例のように記載すると、置換後はファイル名とスライド番号を組み合わせたユニークなidとなります。

id 行のフォーマットは TYPE, PART, LOCALの組合せです。

TYPE はその id が章・節・項のどのレベルかを示します。
以下の3種類のいずれかを使用でき、通常最もよく使うのはsectionです。

```plain
chapter : 章
section : 節
subsection : 項
```

つまり、章節番号といいつつ実際は「章・節・項」の3階層を使用可能です。

id, TYPE, PART, LOCALを区切る ':' は必須ですので、通常は ':' を3個使って
id 行を書きます。 ':' が2個未満だと id と認識されません。
4個以上あるのは問題ありません（4個目以降はすべてLOCALの一部となります）。

id の次行の '\#\# ユニークな id 付与のしくみ'
はスライドのタイトルに置換されます。 MDの見出しレベルを表す '\#\#'
の部分は id の後の chpater, section, subsection と合わせて '\#', '\#\#',
'\#\#\#' を選んでください。

このようなしくみにより、複数の原稿PPTXを使いつつ、idのユニーク性を容易に担保できるため、MDブロックの
ヘッダー部 (BLOCK:MD から \#\# TITLE 行まで)
は、ほぼコピペで済むようになります。

=== 制約事項
<制約事項>
異なるフォルダに存在する同じファイル名のPPTXを同時に原稿PPTXとして使うと、この方式でも
\#id のユニーク性は担保されませんのでご注意ください。

#v(1fr)
#pagebreak(weak: true)
== 1.4) 複数の原稿PPTXを source に指定する
<14-複数の原稿pptxを-source-に指定する>
複数の原稿PPTXを source に指定する方法です。

#v(1 * 1.65em)
#semcenter[
#box(image("images/104-multi-pptx-merge_slide5.webp", width: 100.0%))

]
#v(1 * 1.65em)
レシピYAMLの source.cropsrc セクションに、pptx で原稿PPTXを指定し、pdf
でワークPDFを指定します。　ワークPDFとは原稿PPTXを単純にPDF化したもので、原稿PPTXから画像を切り出すために使われます。　pdfの指定は省略可能ですが、省略すると
output.outputdir にワークPDFが作られます。

pptx、pdfの出力先パスはいずれもレシピYAMLを起点とする相対パス、または絶対パスです。

原稿PPTXを多数使うと、そのワークPDFがすべて output.outputdir
に出力されるのは煩わしいため、作者は レシピYAMLと原稿PPTXを src
フォルダに置き、ワークPDFの出力先はそれと同列の temppdfs
フォルダとする設定をよく使います。

cropimagedirs
は原稿PPTXから切り出した画像の後加工をする場所です。この値は原稿PPTX内の画像切り出し命令

```plain
export-image-mode: slide_with_rectpct
export-image-target: exportrange
export-image: ../images/apple_orange.webp
```

の出力先フォルダ (expor-image中のフォルダ名) に合わせてください。
ppt-md-mergerは expor-image-mode が slide\_with\_rectpct
であった場合に、 cropimagedirs
のディレクトリを見にいって画像の後加工処理をします。

#v(1fr)
#pagebreak(weak: true)
== 1.5) 複数の原稿PPTXをマージ(結合)する
<15-複数の原稿pptxをマージ結合する>
複数の原稿PPTXをマージ(結合)して、大きなPDFやPPTXを作る方法です。
原稿PPTXを結合して作るPDFとPPTXの名前を指定します。 targetbasefilename
を書いてあればそれをベースに自動補完されるので実際には下図中の該当項目は省略可能です。

#v(1 * 1.65em)
#semcenter[
#box(image("images/104-multi-pptx-merge_slide6.webp", width: 100.0%))

]
#v(1 * 1.65em)
procedure
セクションで、原稿PPTXの個別スライドや個別MDのマージ(結合)操作を記述します。上図例のように、insertpptx
と insertmdpages(または insertmd) を並べて書いておくと、どちらも "1-END"
や "1,2,3,5-END"
と、同じ部分をマージしているのがわかるため、両者を同一構成で生成できます。

"1,2,3,5-END" は4を飛ばしてマージしています。
このように、原稿PPTXのすべてを使わず、選択的にマージすることもできます。

#v(1fr)
#pagebreak(weak: true)
== 1.6) 生成処理の実行
<16-生成処理の実行>
以下の命令で生成を実行します。サブコマンド ppt\_build
の引数に生成指示書を指定します。

#v(1 * 1.65em)
```bash
cd cases\104-multi-pptx-merge\src
pptmdmerge ppt_build 104-multi-pptx-merge_recipe.yaml
```

#v(1 * 1.65em)
「WARNING: YAML ファイルが見つかりません」
という警告は出ても問題ありません。

この命令で生成されるのは renderedfilename で指定する Rendered MD です。

オプションを追加すると、PDFやGitHubMDも生成します。

#v(1 * 1.65em)
```bash
cd cases\104-multi-pptx-merge\src
pptmdmerge ppt_build 104-multi-pptx-merge_recipe.yaml --pdf --github --transfer --pptx
```

#v(1 * 1.65em)
#semterm[オプションなし]; Rendered MD のみ生成する

#semterm[--pdf]; Rendered MD をもとにPDFを生成する

#semterm[--github]; Rendered MD をもとにGitHub用MDを生成する

#semterm[--transfer];
生成したMDを他の場所に転送するオプション。当サンプルでは、GitHubMD
をもとに README.md を作るために使用する。

#semterm[--pptx]; PPTXファイルの結合を行います

Rendered, PDF, GitHubMD, PPTX 等の関係については次項の図をご覧ください。

#v(1fr)
#pagebreak(weak: true)
== 1.7) ソースPPTX、生成指示YAML、および成果物MDとPDF
<17-ソースpptx生成指示yamlおよび成果物mdとpdf>
当サンプルのソースと成果物を以下のリンクで確認できます。

=== ソース
<ソース>
#semterm[生成指示];
#link("src/104-multi-pptx-merge_recipe.yaml")[104-multi-pptx-merge\_recipe.yaml]

#semterm[原稿PPTX];
#link("src/104-multi-pptx-merge.pptx")[104-multi-pptx-merge.pptx],
#link("src/additional.pptx")[additional.pptx]

=== 成果物
<成果物>
MDは何種類か異なる仕様で生成します。 Rendered
MDはPPTXソースから切り出したMDにさまざまな加工を加えた生成物で、豊富な書式指示を含んでいます。
それらの書式指示をすべて落として GitHub
での表示に特化したのがGitHub用MDです。

#semterm[Rendered MD];
#link("build/104-multi-pptx-merge_target_rendered.md")[104-multi-pptx-merge\_target\_rendered.md]

#semterm[GitHub用MD];
#link("build/104-multi-pptx-merge_target_github.md")[104-multi-pptx-merge\_target\_github.md]

#semterm[PDF];
#link("build/104-multi-pptx-merge_target.pdf")[104-multi-pptx-merge\_target.pdf]

#semterm[結合PPTX];
#link("build/104-multi-pptx-merge_target.pptx")[104-multi-pptx-merge\_target.pptx]

#semterm[README]; このファイルです

#semcenter[
#box(image("images/104-multi-pptx-merge_slide8.webp", width: 100.0%))

]
当サンプルはPDF化時に改ページ、スペース調整を行うサンプルですので、「PDF」
のpdfを開いてそれらの状態を確認し、次いで 生成指示YAMLを開いて procedure
セクションと照らし合わせて確認してください。

= 2) 複数原稿PPTXの2ファイル目
<2-複数原稿pptxの2ファイル目>
#semcenter[
#sem-box("widequote", width: 70%)[
この章は複数原稿PPTXの2ファイル目です。
生成された単一のPDFおよびPPTXで第2章に掲載されていることを確認してください。

下記のセクションリストは飛ばした Contents C
を除外したリストになり、節番号は2.1～2.6まで連続していることを確認してください。

]
]
#v(2 * 1.65em)
#semcenter[
#sem-box("widequote", width: 80%)[
- 2.1) Contents A
- 2.2) Contents B
- 2.3) Contents D
- 2.4) Contents E
- 2.5) Contents F
- 2.6) Contents G

]
]
#v(1fr)
#pagebreak(weak: true)
== 2.1) Contents A
<21-contents-a>
contents A

#v(1 * 1.65em)
#semcenter[
#box(image("images/additional_slide2.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 2.2) Contents B
<22-contents-b>
contents B

#v(1 * 1.65em)
#semcenter[
#box(image("images/additional_slide3.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 2.3) Contents D
<23-contents-d>
contents D

#v(1 * 1.65em)
#semcenter[
#box(image("images/additional_slide5.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 2.4) Contents E
<24-contents-e>
contents E

#v(1 * 1.65em)
#semcenter[
#box(image("images/additional_slide6.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 2.5) Contents F
<25-contents-f>
contents F

#v(1 * 1.65em)
#semcenter[
#box(image("images/additional_slide7.webp", width: 100.0%))

]
#v(1fr)
#pagebreak(weak: true)
== 2.6) Contents G
<26-contents-g>
contents G

#v(1 * 1.65em)
#semcenter[
#box(image("images/additional_slide8.webp", width: 100.0%))

]
