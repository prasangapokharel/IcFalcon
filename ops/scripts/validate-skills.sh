#!/usr/bin/env bash
# Validate .agents/skills structure — run via: falcon skills:validate
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SKILLS_ROOT="$ROOT/.agents/skills"
INDEX="$ROOT/.agents/SKILLS.md"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

errors=0
warnings=0

err() { echo -e "${RED}error:${NC} $1" >&2; errors=$((errors + 1)); }
warn() { echo -e "${YELLOW}warn:${NC} $1" >&2; warnings=$((warnings + 1)); }
ok() { echo -e "${GREEN}ok:${NC} $1"; }

skill_path_to_index_key() {
  local rel="${1#"$SKILLS_ROOT"/}"
  rel="${rel%/SKILL.md}"
  echo "$rel"
}

[[ -d "$SKILLS_ROOT" ]] || { err "skills root not found: $SKILLS_ROOT"; exit 1; }
[[ -f "$INDEX" ]] || { err "SKILLS.md not found: $INDEX"; exit 1; }

echo "==> validate-skills ($SKILLS_ROOT)"

declare -A INDEXED=()
while IFS= read -r line; do
  key="${line#skills/}"
  key="${key%/SKILL.md}"
  INDEXED["$key"]=1
done < <(grep -oE 'skills/[a-zA-Z0-9_/]+/SKILL.md' "$INDEX" | sort -u)

declare -A SEEN_NAMES=()
skill_count=0

while IFS= read -r skill_file; do
  skill_count=$((skill_count + 1))
  rel_dir="$(dirname "${skill_file#"$SKILLS_ROOT"/}")"
  folder="$(basename "$rel_dir")"
  index_key="$(skill_path_to_index_key "$skill_file")"

  if [[ "$(basename "$skill_file")" != "SKILL.md" ]]; then
    err "$skill_file — must be named SKILL.md"
    continue
  fi

  name_line="$(grep -m1 '^name:' "$skill_file" 2>/dev/null || true)"
  desc_line="$(grep -m1 '^description:' "$skill_file" 2>/dev/null || true)"

  if [[ -z "$name_line" ]]; then
    err "$index_key — missing frontmatter name:"
    continue
  fi
  if [[ -z "$desc_line" ]]; then
    err "$index_key — missing frontmatter description:"
    continue
  fi

  name="${name_line#name: }"
  name="${name//$'\r'/}"

  if [[ "$name" =~ ^IcFalcon- ]] || [[ "$name" =~ ^icFalcon- ]]; then
    err "$index_key — name must match folder (no IcFalcon- prefix): $name"
  fi

  if [[ "$folder" != "$name" ]]; then
    err "$index_key — name '$name' does not match folder '$folder'"
  fi

  if [[ "$folder" != *Standard ]]; then
    err "$index_key — folder name must end with Standard (camelCase)"
  fi

  if [[ -n "${SEEN_NAMES[$name]+x}" ]]; then
    err "duplicate skill name '$name' (${SEEN_NAMES[$name]} and $index_key)"
  else
    SEEN_NAMES["$name"]="$index_key"
  fi

  if [[ -z "${INDEXED[$index_key]+x}" ]]; then
    err "$index_key — not indexed in .agents/SKILLS.md"
  fi

  lines="$(wc -l < "$skill_file")"
  exempt_long="writingMotokoStandard|integrationStandard|migratingMotokoEnhancedStandard|errorHandlingStandard|codingStandard|frontendStandard"
  if [[ "$lines" -gt 350 ]] && ! [[ "$index_key" =~ ^motoko/($exempt_long)$|^(codingStandard|errorHandlingStandard|frontendStandard|integrationStandard)$ ]]; then
    warn "$index_key — $lines lines (prefer <300; split or trim)"
  fi

  strict=0
  if [[ "$rel_dir" == financeStandard/* ]] || [[ "$index_key" == "logoStandard" ]]; then
    strict=1
  fi

  if [[ $strict -eq 1 ]]; then
    grep -q '^## Purpose' "$skill_file" || err "$index_key — missing ## Purpose"
    grep -q '^## When to use' "$skill_file" || err "$index_key — missing ## When to use"
    grep -q '^## Related' "$skill_file" || err "$index_key — missing ## Related"
  else
    if ! grep -qE '^## (Purpose|When to use)' "$skill_file"; then
      if ! grep -q '^description:' "$skill_file"; then
        warn "$index_key — add ## Purpose or ## When to use (has description only)"
      fi
    fi
  fi

  while IFS= read -r link; do
    [[ -z "$link" ]] && continue
    if [[ "$link" == frontend/* ]]; then
      target="$ROOT/frontend/.agents/$link/SKILL.md"
    else
      target="$SKILLS_ROOT/$link/SKILL.md"
    fi
    if [[ ! -f "$target" ]]; then
      err "$index_key — broken link: $link/SKILL.md"
    fi
  done < <(
    grep -oE '\(skills/[a-zA-Z0-9_/]+/SKILL\.md\)' "$skill_file" 2>/dev/null \
      | sed 's|^(skills/||;s|/SKILL\.md)||' \
      | sort -u
  )

done < <(find "$SKILLS_ROOT" -name 'SKILL.md' | sort)

for key in "${!INDEXED[@]}"; do
  target="$SKILLS_ROOT/$key/SKILL.md"
  if [[ ! -f "$target" ]]; then
    err "SKILLS.md indexes missing skill: $key"
  fi
done

echo ""
echo "skills checked: $skill_count"
echo "errors: $errors"
echo "warnings: $warnings"

if [[ $errors -gt 0 ]]; then
  echo -e "${RED}validate-skills FAILED${NC}"
  exit 1
fi

if [[ $warnings -gt 0 ]]; then
  echo -e "${YELLOW}validate-skills passed with $warnings warning(s)${NC}"
else
  ok "validate-skills passed"
fi
