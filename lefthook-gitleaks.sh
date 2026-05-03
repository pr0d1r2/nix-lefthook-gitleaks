# shellcheck shell=bash
# Lefthook-compatible gitleaks wrapper.
# Usage: lefthook-gitleaks file1 [file2 ...]
# NOTE: sourced by writeShellApplication — no shebang or set needed.

if [ $# -eq 0 ]; then
    exit 0
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

count=0
for f in "$@"; do
    [ -f "$f" ] || continue
    dir="$tmpdir/$(dirname "$f")"
    mkdir -p "$dir"
    cp "$f" "$tmpdir/$f"
    count=$((count + 1))
done

if [ "$count" -eq 0 ]; then
    exit 0
fi

exec gitleaks dir --no-banner "$tmpdir"
