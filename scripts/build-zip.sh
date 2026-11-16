#!/usr/bin/env bash
# Package every skill in skills/ for download, so users can install it without npx.
#
# For each skills/<name>/ it writes:
#   dist/<name>.zip  - the skill folder as the zip's single top-level directory (<name>/SKILL.md).
#                      This is the layout claude.ai / Claude Desktop require and the one the
#                      OpenAI skills spec asks for; unzipped, it drops straight into
#                      ~/.claude/skills/ or ~/.agents/skills/.
#   dist/<name>.md   - SKILL.md plus every references/*.md in one Markdown file, for chats
#                      without a Skills feature (attach to a project / custom GPT) and for
#                      single-file uploads (Gemini, Grok).
#   dist/<plugin>-claude-plugin.zip - the Claude plugin (Claude only): .claude-plugin/plugin.json (+ icon), skills/, the
#                      READMEs and LICENSE at the zip root, for uploading as a plugin in claude.ai /
#                      Claude Desktop, so the plugin carries the SePay MCP connector and the skills
#                      together. The MCP servers of the repo's .mcp.json are declared inline in the
#                      zip's plugin.json (`mcpServers`; the zip has no .mcp.json, one source only),
#                      with the OAuth client registered for claude.ai / Claude Desktop
#                      (CLAUDE_AI_CLIENT_ID, no localhost callback port). The repo's .mcp.json keeps
#                      the Claude Code client, used by /plugin install from the marketplace.
#   dist/SHA256SUMS  - checksums of the files above.
#   dist/VERSION     - the release version (semver), read from .claude-plugin/plugin.json.
#
# The version lives in .claude-plugin/plugin.json `version` (X.Y.Z) and every SKILL.md repeats it
# as `metadata.version`, so a downloaded zip or one-file .md can tell which release it is.
# The build fails when any of them disagree or the version is not X.Y.Z.
#
# The zip is reproducible: same skill content and same last commit time give the same bytes.
# Usage: scripts/build-zip.sh            (run from anywhere inside the repo)
# Needs: bash, git, zip, unzip, sha256sum, awk, jq.
set -euo pipefail

export LC_ALL=C.UTF-8 TZ=UTC

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_dir="$root/skills"
dist="$root/dist"

fail() { echo "build-zip: $*" >&2; exit 1; }

for cmd in git zip unzip sha256sum awk; do
  command -v "$cmd" >/dev/null || fail "missing command: $cmd"
done

# Read one top-level scalar field from a SKILL.md frontmatter block.
frontmatter_field() {
  awk -v key="$2" '
    NR == 1 && $0 != "---" { exit }
    NR > 1 && $0 == "---"  { exit }
    NR > 1 && index($0, key ": ") == 1 { print substr($0, length(key) + 3); exit }
  ' "$1"
}

# Read metadata.version from a SKILL.md frontmatter block (quotes stripped).
skill_version() {
  awk '
    NR == 1 && $0 != "---" { exit }
    NR > 1 && $0 == "---"  { exit }
    /^metadata:/ { m = 1; next }
    m && /^[^ ]/ { m = 0 }
    m && /^  version: / { v = substr($0, 12); gsub(/["\047]/, "", v); print v; exit }
  ' "$1"
}

validate_skill() {
  local dir="$1" name skill_md fm_name desc desc_len bad
  name="$(basename "$dir")"
  skill_md="$dir/SKILL.md"

  [[ -f "$skill_md" ]] || fail "$name: SKILL.md not found"
  [[ "$name" =~ ^[a-z0-9]([a-z0-9-]{0,62}[a-z0-9])?$ ]] \
    || fail "$name: folder name must be lowercase letters, digits and hyphens, at most 64 characters"

  fm_name="$(frontmatter_field "$skill_md" name)"
  [[ "$fm_name" == "$name" ]] || fail "$name: frontmatter name '$fm_name' does not match the folder name"

  desc="$(frontmatter_field "$skill_md" description)"
  [[ -n "$desc" ]] || fail "$name: frontmatter description is missing (it must be on one line)"
  desc_len="$(printf '%s' "$desc" | wc -m | tr -d ' ')"
  (( desc_len <= 1024 )) || fail "$name: description is $desc_len characters, the limit is 1024"

  # Skills here are Markdown only; hidden files (.DS_Store) break Gemini uploads.
  bad="$(cd "$dir" && find . \( -name '.*' ! -name . \) -o \( -type f ! -name '*.md' \) | sort)"
  [[ -z "$bad" ]] || fail "$name: only visible .md files are allowed, found: $(echo "$bad" | tr '\n' ' ')"

  local sv
  sv="$(skill_version "$skill_md")"
  [[ "$sv" == "$version" ]] \
    || fail "$name: SKILL.md metadata.version is '${sv:-missing}', .claude-plugin/plugin.json version is $version; keep them equal"

  # Every reference SKILL.md names must exist, or the one-file build points nowhere.
  local ref
  for ref in $(grep -oE '`[a-z0-9-]+\.md`' "$skill_md" | tr -d '`' | sort -u); do
    [[ -f "$dir/references/$ref" || -f "$dir/$ref" ]] || fail "$name: SKILL.md mentions $ref, which does not exist"
  done
}

build_zip() {
  local name="$1" epoch="$2" stage
  stage="$(mktemp -d)"
  cp -R "$skills_dir/$name" "$stage/$name"
  # Normalise what a checkout leaves behind (mode, mtime) so the archive is byte-stable.
  find "$stage/$name" -type d -exec chmod 755 {} +
  find "$stage/$name" -type f -exec chmod 644 {} +
  find "$stage/$name" -exec touch -h -d "@$epoch" {} +
  # -X drops uid/gid and extra time fields; sorted input fixes the entry order.
  (cd "$stage" && find "$name" | sort | zip -q -X -@ "$dist/$name.zip")
  rm -rf "$stage"

  # Claude only finds <name>/SKILL.md; a SKILL.md at the zip root is ignored.
  unzip -Z1 "$dist/$name.zip" | grep -qx "$name/SKILL.md" || fail "$name.zip: $name/SKILL.md missing"
  if unzip -Z1 "$dist/$name.zip" | grep -v "^$name/" | grep -q .; then
    fail "$name.zip: every entry must sit under $name/"
  fi
}

build_plugin_zip() {
  local epoch="$1" stage out="$dist/$plugin_name-claude-plugin.zip" f
  stage="$(mktemp -d)"
  mkdir -p "$stage/.claude-plugin"
  # The manifest and its icon; marketplace.json lists the plugin for a marketplace and is not part of it.
  for f in "$root"/.claude-plugin/*; do
    [[ "$(basename "$f")" == marketplace.json ]] || cp "$f" "$stage/.claude-plugin/"
  done
  # The servers of the repo's .mcp.json, inline in plugin.json, with the claude.ai OAuth client
  # (sign-in required) instead of the Claude Code one.
  if [[ -f "$root/.mcp.json" ]]; then
    jq --arg id "$CLAUDE_AI_CLIENT_ID" --slurpfile mcp "$root/.mcp.json" \
      '.mcpServers = ($mcp[0].mcpServers | with_entries(if .value.oauth then .value.oauth = {clientId: $id} else . end))' \
      "$root/.claude-plugin/plugin.json" > "$stage/.claude-plugin/plugin.json" \
      || fail "plugin.json: cannot add the MCP servers for claude.ai"
    jq -e --arg id "$CLAUDE_AI_CLIENT_ID" \
      '(.mcpServers | length) > 0 and ([.mcpServers[] | select(.oauth) | .oauth.clientId == $id] | all)' \
      "$stage/.claude-plugin/plugin.json" >/dev/null || fail "plugin.json: MCP servers missing or OAuth client is not $CLAUDE_AI_CLIENT_ID"
  fi
  # The plugin directory refuses a plugin without a README; the English one is linked from it.
  for f in LICENSE README.md README.en.md; do cp "$root/$f" "$stage/$f"; done
  cp -R "$skills_dir" "$stage/skills"
  find "$stage" -type d -exec chmod 755 {} +
  find "$stage" -type f -exec chmod 644 {} +
  find "$stage" -exec touch -h -d "@$epoch" {} +
  (cd "$stage" && find . -mindepth 1 | sed 's|^\./||' | sort | zip -q -X -@ "$out")
  rm -rf "$stage"

  # Claude needs the manifest at the zip root, not inside a folder.
  unzip -Z1 "$out" | grep -qx ".claude-plugin/plugin.json" || fail "$(basename "$out"): .claude-plugin/plugin.json missing at the root"
  unzip -Z1 "$out" | grep -q "^skills/[^/]*/SKILL.md$" || fail "$(basename "$out"): no skills/<name>/SKILL.md"
  echo "built: dist/$(basename "$out") ($(unzip -Z1 "$out" | wc -l | tr -d ' ') entries)"
}

build_single_md() {
  local name="$1" dir="$skills_dir/$1" out="$dist/$1.md" ref
  {
    # Frontmatter first, so the file still loads as a single-file skill.
    awk 'NR == 1 || !done { print } NR > 1 && $0 == "---" { done = 1 }' "$dir/SKILL.md"
    echo
    echo "> One-file edition of the \`$name\` skill, version $version: each file of \`references/\` follows below under a heading \`# references/<file>\`. When the instructions say to read a file, read that section."
    awk 'NR > 1 && $0 == "---" && !done { done = 1; next } done { print }' "$dir/SKILL.md"
    if [[ -d "$dir/references" ]]; then
      for ref in $(cd "$dir/references" && ls -1 *.md | sort); do
        printf '\n---\n\n# references/%s\n\n' "$ref"
        cat "$dir/references/$ref"
      done
    fi
  } > "$out"
}

[[ -d "$skills_dir" ]] || fail "skills/ not found at $skills_dir"

plugin_json="$root/.claude-plugin/plugin.json"
[[ -f "$plugin_json" ]] || fail ".claude-plugin/plugin.json not found"
version="$(jq -r '.version // empty' "$plugin_json")"
plugin_name="$(jq -r '.name // empty' "$plugin_json")"
[[ -n "$plugin_name" ]] || fail ".claude-plugin/plugin.json has no name"
# Claude rejects a plugin upload whose description is longer than 500 characters.
desc_len="$(jq -r '.description // ""' "$plugin_json" | tr -d '\n' | wc -m | tr -d ' ')"
(( desc_len <= 500 )) || fail ".claude-plugin/plugin.json description is $desc_len characters; Claude allows at most 500"
[[ "$version" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]] \
  || fail ".claude-plugin/plugin.json version '${version}' is not semver X.Y.Z"

# OAuth client id of the SePay MCP server for claude.ai / Claude Desktop (public identifier, not a secret).
CLAUDE_AI_CLIENT_ID="sepay-claude"

# Last commit time of skills/, so a rebuild of the same commit gives the same zip.
epoch="${SOURCE_DATE_EPOCH:-$(git -C "$root" log -1 --format=%ct -- skills 2>/dev/null || true)}"
[[ -n "$epoch" ]] || epoch=315532800   # 1980-01-01, the earliest time a zip can hold

rm -rf "$dist"
mkdir -p "$dist"

count=0
for dir in "$skills_dir"/*/; do
  dir="${dir%/}"
  name="$(basename "$dir")"
  validate_skill "$dir"
  build_zip "$name" "$epoch"
  build_single_md "$name"
  count=$((count + 1))
  echo "built: dist/$name.zip ($(unzip -Z1 "$dist/$name.zip" | wc -l | tr -d ' ') entries), dist/$name.md"
done
(( count > 0 )) || fail "no skill folders in skills/"
build_plugin_zip "$epoch"

(cd "$dist" && sha256sum -- *.zip *.md > SHA256SUMS)
echo "$version" > "$dist/VERSION"
echo "version: $version"
cat "$dist/SHA256SUMS"
