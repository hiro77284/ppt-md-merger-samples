#!/usr/bin/env bash
# =============================================================================
# build_all_cases.sh
#   cases/ 配下の各事例を、case.yaml の build: に書かれた手順で一括ビルドする。
#
# 使い方 (どこから実行してもよい):
#   scripts/build_all_cases.sh -r [options] [PATTERN]   (実行)
#   scripts/build_all_cases.sh -n [options] [PATTERN]   (dry-run)
#
#   -r / -n のどちらも指定しないときは、このヘルプを表示して何も実行しない。
#
#   PATTERN を指定すると、事例フォルダ名またはレシピのファイル名に PATTERN を
#   含む (部分一致・大文字小文字区別) ものだけを実行する。省略時は全件。
#   例: scripts/build_all_cases.sh -r 101   /   scripts/build_all_cases.sh -r -k cover
#
# オプション:
#   -r, --run            ビルドを実行する
#   -k, --keep-going     pptmdmerge がエラーになっても続行する
#                        (既定: 最初のエラーで中断)
#   -i, --index          全件成功したら最後に python scripts/build_index.py を実行して
#                        ルート README.md の事例一覧を更新する
#   -l, --log            実行ログを保存する (既定ファイル名:
#                        build_all_cases_YYYYMMDD_HHMMSS.log, リポジトリルート)
#       --log-file FILE  実行ログを FILE に保存する (-l を兼ねる)
#   -n, --dry-run        実行するコマンドを表示するだけで実行しない
#                        (-r と同時指定はエラー)
#   -h, --help           このヘルプを表示する
#
# ビルド手順は cases/<id>/case.yaml の build: から読む (上から順に実行):
#   build:
#     - recipe: src/NAME_recipe.yaml      # cases/<id>/ 基準のパス
#       command: ppt_build                # pptmdmerge のサブコマンド (省略時 ppt_build)
#       options: --githubmd --transfer --pdf --yes-clear-dir   # 省略可
#   - build: が無い事例は SKIP と表示して数に入れない
#   - フォルダ名が _ で始まる事例 (_template など) は対象外
#   ※ 値に "|" は使えない。options 内で空白を含む値の引用は非対応。
#   case.yaml の読み込みには Python + PyYAML を使う (build_index.py と同じ)。
#   Python は環境変数 PYTHON で指定できる (既定: python、無ければ python3)。
#
# ログ保存時も標準出力に同じ内容を表示する (tee)。
# 終了コード: 全件成功 0 / 失敗あり 1 / 引数・case.yaml 不正 2
# =============================================================================

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CASES_ROOT="$REPO_ROOT/cases"
DEFAULT_COMMAND="ppt_build"

KEEP_GOING=0
SAVE_LOG=0
LOG_FILE=""
DRY_RUN=0
RUN=0
INDEX=0
PATTERN=""

usage() {
    sed -n '2,/^# =====/p' "${BASH_SOURCE[0]}" | sed '$d' | sed 's/^# \{0,1\}//'
}

while [ $# -gt 0 ]; do
    case "$1" in
        -k|--keep-going) KEEP_GOING=1 ;;
        -i|--index)      INDEX=1 ;;
        -l|--log)        SAVE_LOG=1 ;;
        --log-file)
            [ $# -ge 2 ] || { echo "error: --log-file には FILE が必要です" >&2; exit 2; }
            SAVE_LOG=1; LOG_FILE="$2"; shift ;;
        --log-file=*)    SAVE_LOG=1; LOG_FILE="${1#*=}" ;;
        -r|--run)        RUN=1 ;;
        -n|--dry-run)    DRY_RUN=1 ;;
        -h|--help)       usage; exit 0 ;;
        -*) echo "error: 不明なオプション: $1" >&2; usage >&2; exit 2 ;;
        *)
            [ -z "$PATTERN" ] || { echo "error: PATTERN は 1 つだけ指定できます" >&2; exit 2; }
            PATTERN="$1" ;;
    esac
    shift
done

if [ $RUN -eq 1 ] && [ $DRY_RUN -eq 1 ]; then
    echo "error: -r/--run と -n/--dry-run は同時に指定できません" >&2; exit 2
fi
if [ $RUN -eq 0 ] && [ $DRY_RUN -eq 0 ]; then
    usage; exit 0
fi

if [ -z "$PYTHON" ]; then
    if command -v python >/dev/null 2>&1; then PYTHON=python
    elif command -v python3 >/dev/null 2>&1; then PYTHON=python3
    else echo "error: python が見つかりません (環境変数 PYTHON で指定できます)" >&2; exit 2
    fi
fi

trim() {
    local s="$1"
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"
    printf '%s' "$s"
}

# case.yaml を読んで 1 手順 1 行 "id|recipe|command|options" を出力する。
# build: が無い事例は "id|-SKIP-||" を出す。不正があれば stderr に出して exit 2。
list_steps() {
    (cd "$CASES_ROOT" && PYTHONUTF8=1 PYTHONIOENCODING=utf-8 "$PYTHON" - "$DEFAULT_COMMAND" <<'PY'
import sys
from pathlib import Path
try:
    import yaml
except ImportError:
    sys.exit("error: PyYAML がありません (pip install pyyaml)")

default_cmd = sys.argv[1]
errors = []
for d in sorted(p for p in Path(".").iterdir() if p.is_dir() and not p.name.startswith(("_", "."))):
    yml = d / "case.yaml"
    if not yml.is_file():
        errors.append(f"{d.name}: case.yaml がない")
        continue
    try:
        data = yaml.safe_load(yml.read_text(encoding="utf-8")) or {}
    except yaml.YAMLError as e:
        errors.append(f"{d.name}/case.yaml: YAML として読めない: {e}")
        continue
    build = data.get("build") if isinstance(data, dict) else None
    if not build:
        print(f"{d.name}|-SKIP-||")
        continue
    if not isinstance(build, list):
        errors.append(f"{d.name}/case.yaml: build はリストにする")
        continue
    for i, step in enumerate(build, 1):
        if not isinstance(step, dict) or not step.get("recipe"):
            errors.append(f"{d.name}/case.yaml: build[{i}] に recipe がない")
            continue
        vals = [str(step["recipe"]), str(step.get("command") or default_cmd), str(step.get("options") or "")]
        if any("|" in v or "\n" in v for v in vals):
            errors.append(f"{d.name}/case.yaml: build[{i}] の値に | または改行がある")
            continue
        print("|".join([d.name] + [v.strip() for v in vals]))
for e in errors:
    print(f"ERROR: {e}", file=sys.stderr)
sys.exit(2 if errors else 0)
PY
    )
}

run_all() {
    local total=0 ok=0 ng=0 skipped=0
    local -a failed=()
    local steps line id path sub params dir file rc
    local -a args

    echo "=== build_all_cases.sh  $(date '+%Y-%m-%d %H:%M:%S') ==="
    echo "cases root: $CASES_ROOT"
    echo "on error: $([ $KEEP_GOING -eq 1 ] && echo continue || echo stop)"
    [ $DRY_RUN -eq 1 ] && echo "dry-run: yes"
    [ -n "$PATTERN" ] && echo "pattern: $PATTERN"
    echo

    [ -d "$CASES_ROOT" ] || { echo "ERROR: cases フォルダがありません: $CASES_ROOT"; return 2; }
    if ! steps=$(list_steps); then
        echo "case.yaml の読み込みでエラーがあったため中断しました"
        return 2
    fi

    # リストは fd 3 から読む (stdin は pptmdmerge の確認入力用に端末のまま残す)
    while IFS= read -r -u 3 line || [ -n "$line" ]; do
        [ -n "$line" ] || continue
        IFS='|' read -r id path sub params <<<"$line"
        id=$(trim "$id"); path=$(trim "$path"); sub=$(trim "$sub"); params=$(trim "$params")
        file=$(basename "$path")
        if [ -n "$PATTERN" ] && [[ "$id" != *"$PATTERN"* ]] && [[ "$file" != *"$PATTERN"* ]]; then
            continue
        fi
        if [ "$path" = "-SKIP-" ]; then
            skipped=$((skipped + 1))
            echo "----- SKIP $id (case.yaml に build: がない)"
            echo
            continue
        fi

        total=$((total + 1))
        dir=$(dirname "$path")
        read -r -a args <<<"$params"

        echo "----- [$total] $id/$path"
        if [ ! -f "$CASES_ROOT/$id/$path" ]; then
            echo "ERROR: レシピが見つかりません: cases/$id/$path"
            rc=2
        elif ! cd "$CASES_ROOT/$id/$dir"; then
            echo "ERROR: cd できません: cases/$id/$dir"
            rc=2
        else
            echo "\$ (cd cases/$id/$dir) pptmdmerge $sub $file${params:+ $params}"
            if [ $DRY_RUN -eq 1 ]; then
                rc=0
            else
                pptmdmerge "$sub" "$file" "${args[@]}" 2>&1
                rc=$?
            fi
            cd "$REPO_ROOT" || return 2
        fi

        if [ $rc -eq 0 ]; then
            ok=$((ok + 1))
            echo "OK"
        else
            ng=$((ng + 1))
            failed+=("$id/$path (exit $rc)")
            echo "FAILED (exit $rc)"
            if [ $KEEP_GOING -eq 0 ]; then
                echo
                echo "エラーのため中断しました (続行するには -k / --keep-going)"
                break
            fi
        fi
        echo
    done 3<<<"$steps"

    cd "$REPO_ROOT" || return 2
    if [ $total -eq 0 ]; then
        echo "ERROR: 対象のビルド手順がありません${PATTERN:+ (pattern: $PATTERN)}"
        return 2
    fi
    echo "=== summary: total(run)=$total ok=$ok failed=$ng skipped=$skipped ==="
    local f
    for f in "${failed[@]}"; do echo "  FAILED: $f"; done

    [ $ng -eq 0 ] || return 1

    if [ $INDEX -eq 1 ]; then
        echo
        echo "\$ $PYTHON scripts/build_index.py"
        if [ $DRY_RUN -eq 0 ]; then
            "$PYTHON" scripts/build_index.py 2>&1 || { echo "FAILED: build_index.py"; return 1; }
        fi
    fi
    return 0
}

if [ $SAVE_LOG -eq 1 ]; then
    [ -n "$LOG_FILE" ] || LOG_FILE="$REPO_ROOT/build_all_cases_$(date '+%Y%m%d_%H%M%S').log"
    echo "log file: $LOG_FILE"
    run_all 2>&1 | tee "$LOG_FILE"
    status=${PIPESTATUS[0]}
else
    run_all
    status=$?
fi

cd "$REPO_ROOT"
exit "$status"
