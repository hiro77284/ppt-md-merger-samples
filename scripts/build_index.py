#!/usr/bin/env python3
"""cases/*/case.yaml から README.md の事例一覧を生成する。

使い方（リポジトリ直下で実行）:
    python scripts/build_index.py          # README.md の一覧部分を書き換える
    python scripts/build_index.py --check  # 書き換えが必要なら終了コード 1（CI 用）

README.md の次の 2 行の間だけを書き換え、それ以外は手書きのまま残す:
    <!-- BEGIN CASE INDEX -->
    <!-- END CASE INDEX -->

case.yaml の項目は _template/case.yaml を参照。必須項目が欠けている、id がフォルダ名と
違う、などの問題はエラーとして一覧を書き換えずに終了する（終了コード 2）。

依存: PyYAML（pip install pyyaml）
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
CASES_DIR = ROOT / "cases"
README = ROOT / "README.md"

BEGIN = "<!-- BEGIN CASE INDEX -->"
END = "<!-- END CASE INDEX -->"

REQUIRED = ("id", "title", "summary", "tags", "ppt_md_merger_version")
CASE_DIR_RE = re.compile(r"^\d{3}-[a-z0-9]+(?:-[a-z0-9]+)*$")
THUMBNAIL_CANDIDATES = ("thumbnail.png", "thumbnail.webp", "thumbnail.jpg")
THUMBNAIL_WIDTH = 400


def _cell(text: object) -> str:
    """Markdown 表のセルに入れられるよう、改行と | を処理する。"""
    s = " ".join(str(text).split())
    return s.replace("|", "\\|")


def load_case(case_dir: Path) -> tuple[dict | None, list[str]]:
    errors: list[str] = []
    name = case_dir.name
    if not CASE_DIR_RE.match(name):
        errors.append(f"{name}: フォルダ名は NNN-slug（数字3桁 + 英小文字・数字・-）にする")
    yml = case_dir / "case.yaml"
    if not yml.is_file():
        if (case_dir / "case.yml").is_file():
            errors.append(f"{name}: case.yml は case.yaml に名前を変える")
        else:
            errors.append(f"{name}: case.yaml がない")
        return None, errors
    try:
        data = yaml.safe_load(yml.read_text(encoding="utf-8")) or {}
    except yaml.YAMLError as e:
        errors.append(f"{name}/case.yaml: YAML として読めない: {e}")
        return None, errors
    if not isinstance(data, dict):
        errors.append(f"{name}/case.yaml: トップレベルがマッピングではない")
        return None, errors

    for key in REQUIRED:
        val = data.get(key)
        if val is None or val == "" or val == []:
            errors.append(f"{name}/case.yaml: 必須項目 {key} がない")
        elif isinstance(val, str) and "<" in val and ">" in val:
            errors.append(f"{name}/case.yaml: {key} が雛形のまま: {val}")
    if data.get("id") and data["id"] != name:
        errors.append(f"{name}/case.yaml: id ({data['id']}) がフォルダ名と違う")
    tags = data.get("tags")
    if tags is not None and not (isinstance(tags, list) and all(isinstance(t, str) for t in tags)):
        errors.append(f"{name}/case.yaml: tags は文字列のリストにする")
    elif tags and any("<" in t and ">" in t for t in tags):
        errors.append(f"{name}/case.yaml: tags が雛形のまま: {tags}")
    if not (case_dir / "README.md").is_file():
        errors.append(f"{name}: README.md がない")
    if not (case_dir / "src").is_dir():
        errors.append(f"{name}: src/ がない")

    thumb = data.get("thumbnail")
    if thumb:
        if not (case_dir / thumb).is_file():
            errors.append(f"{name}/case.yaml: thumbnail のファイルがない: {thumb}")
            thumb = None
    else:
        thumb = next((c for c in THUMBNAIL_CANDIDATES if (case_dir / c).is_file()), None)
    data["_thumbnail"] = thumb
    data["_dir"] = name
    return data, errors


def render_index(cases: list[dict]) -> str:
    lines = [BEGIN, "<!-- この部分は scripts/build_index.py が生成する。手で書き換えない。 -->", ""]
    if not cases:
        lines += ["（まだ事例はありません）", ""]
    else:
        lines += [
            f"全 {len(cases)} 件",
            "",
            "| | 事例 | 概要 | タグ | 確認バージョン |",
            "|---|---|---|---|---|",
        ]
        for c in cases:
            d = c["_dir"]
            thumb = (
                f'<img src="cases/{d}/{c["_thumbnail"]}" width="{THUMBNAIL_WIDTH}" alt="">'
                if c["_thumbnail"] else ""
            )
            title = f"[{_cell(c['title'])}](cases/{d}/)"
            tags = " ".join(f"`{_cell(t)}`" for t in c["tags"])
            lines.append(
                f"| {thumb} | {title}<br>`{d}` | {_cell(c['summary'])} | {tags} "
                f"| {_cell(c['ppt_md_merger_version'])} |"
            )
        lines.append("")

        tag_counts: dict[str, list[str]] = {}
        for c in cases:
            for t in c["tags"]:
                tag_counts.setdefault(t, []).append(c["_dir"])
        lines += ["### タグ別", ""]
        for t in sorted(tag_counts):
            links = ", ".join(f"[{d}](cases/{d}/)" for d in tag_counts[t])
            lines.append(f"- `{_cell(t)}` ({len(tag_counts[t])}): {links}")
        lines.append("")
    lines.append(END)
    return "\n".join(lines)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true", help="README.md を書き換えず、差分があれば終了コード 1")
    args = ap.parse_args()

    cases: list[dict] = []
    errors: list[str] = []
    if CASES_DIR.is_dir():
        for case_dir in sorted(p for p in CASES_DIR.iterdir() if p.is_dir()):
            data, errs = load_case(case_dir)
            errors += errs
            if data is not None:
                cases.append(data)
    if errors:
        for e in errors:
            print(f"error: {e}", file=sys.stderr)
        return 2

    text = README.read_text(encoding="utf-8")
    if BEGIN not in text or END not in text:
        print(f"error: README.md に {BEGIN} と {END} の行がない", file=sys.stderr)
        return 2
    head, rest = text.split(BEGIN, 1)
    _, tail = rest.split(END, 1)
    new_text = head + render_index(cases) + tail

    if new_text == text:
        print(f"README.md は最新です（{len(cases)} 件）")
        return 0
    if args.check:
        print("README.md の一覧が古い。python scripts/build_index.py を実行する", file=sys.stderr)
        return 1
    README.write_text(new_text, encoding="utf-8", newline="\n")
    print(f"README.md の一覧を更新しました（{len(cases)} 件）")
    return 0


if __name__ == "__main__":
    sys.exit(main())
