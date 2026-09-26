#!/usr/bin/env bash
# Motoko Code Validator & Linter (IcFalcon Standard)
# Like Python's black / flake8 for Motoko
# Run via: falcon audit code:motoko [--fix] [--strict]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
BACKEND_DIR="$ROOT/backend"
DEFAULT_TARGET="$BACKEND_DIR/src"

if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  DIM='\033[2m'
  NC='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  CYAN=''
  BOLD=''
  DIM=''
  NC=''
fi

AUTO_FIX=false
STRICT_MODE=false
CHECK_COMPILER=true
TARGET_PATHS=()

usage() {
  cat <<EOF
Usage:
  falcon audit code:motoko [options] [path...]
  ./ops/scripts/code/motoko/validate-code.sh [options] [path...]

Options:
  --fix, -f        Auto-format formatting issues (trailing spaces, CRLF, EOF newline)
  --strict, -s     Treat warnings as errors (exit 1 if warnings found)
  --no-compiler    Skip moc compiler syntax & typecheck
  --all, -a        Audit backend/src AND backend/pkg
  --help, -h       Show this help message

Checks:
  1. Formatting (trailing whitespace, CRLF line endings, final EOF newline)
  2. Architecture Layering (api -> storage forbidden, validators pure, etc.)
  3. Deprecated Libraries (forbid mo:base, require mo:core)
  4. Naming Conventions (PascalCase files, *Storage.mo, *Repository.mo, *Service.mo)
  5. File Size Constraints (warn on files > 300 lines)
  6. Safety & Best Practices (no Debug.trap for user errors, persistent actor)
  7. Compiler Verification (moc --check syntax & type validity)
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --fix|-f)
      AUTO_FIX=true
      shift
      ;;
    --strict|-s)
      STRICT_MODE=true
      shift
      ;;
    --no-compiler)
      CHECK_COMPILER=false
      shift
      ;;
    --all|-a)
      TARGET_PATHS+=("$BACKEND_DIR/src" "$BACKEND_DIR/pkg")
      shift
      ;;
    --help|-h)
      usage
      ;;
    *)
      TARGET_PATHS+=("$1")
      shift
      ;;
  esac
done

if [[ ${#TARGET_PATHS[@]} -eq 0 ]]; then
  TARGET_PATHS=("$DEFAULT_TARGET")
fi

errors=0
warnings=0
fixed=0
audited=0

err() {
  echo -e "  ${RED}✘ ERROR:${NC} $1" >&2
  errors=$((errors + 1))
}

warn() {
  echo -e "  ${YELLOW}⚠ WARN:${NC} $1" >&2
  warnings=$((warnings + 1))
}

info_fix() {
  echo -e "  ${CYAN}✔ FIXED:${NC} $1"
  fixed=$((fixed + 1))
}

format_fix_file() {
  local file="$1"
  local changed=false

  # 1. Remove carriage returns (CRLF -> LF)
  if grep -q $'\r' "$file" 2>/dev/null; then
    tr -d '\r' < "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
    changed=true
  fi

  # 2. Strip trailing whitespace
  if grep -qE '[ \t]+$' "$file" 2>/dev/null; then
    sed -i -E 's/[ \t]+$//' "$file"
    changed=true
  fi

  # 3. Ensure single newline at EOF
  if [[ -s "$file" ]]; then
    # Ensure file ends with newline
    if [[ $(tail -c 1 "$file" | wc -l) -eq 0 ]]; then
      echo "" >> "$file"
      changed=true
    fi
  fi

  if $changed; then
    info_fix "$file (normalized whitespace, line endings & EOF)"
  fi
}

echo -e "${BOLD}==> Motoko Code Validator (IcFalcon Standard)${NC}"

# Collect .mo files
MO_FILES=()
for target in "${TARGET_PATHS[@]}"; do
  if [[ -f "$target" && "$target" == *.mo ]]; then
    MO_FILES+=("$target")
  elif [[ -d "$target" ]]; then
    while IFS= read -r f; do
      [[ -n "$f" ]] && MO_FILES+=("$f")
    done < <(find "$target" -type f -name "*.mo" | sort)
  fi
done

if [[ ${#MO_FILES[@]} -eq 0 ]]; then
  echo -e "${YELLOW}No .mo files found in specified targets.${NC}"
  exit 0
fi

echo -e "${DIM}Auditing ${#MO_FILES[@]} Motoko file(s)...${NC}\n"

for file in "${MO_FILES[@]}"; do
  audited=$((audited + 1))
  file_rel="${file#"$ROOT"/}"
  filename="$(basename "$file")"
  parent_dir="$(basename "$(dirname "$file")")"
  file_errors_before=$errors
  file_warnings_before=$warnings

  # --- Auto-fix if requested ---
  if $AUTO_FIX; then
    format_fix_file "$file"
  fi

  # --- Check 1: Formatting ---
  # CRLF Check
  if grep -q $'\r' "$file" 2>/dev/null; then
    err "$file_rel — Contains Windows CRLF line endings (use LF)"
  fi

  # Trailing whitespace
  if grep -qE '[ \t]+$' "$file" 2>/dev/null; then
    err "$file_rel — Contains trailing whitespace on lines: $(grep -nE '[ \t]+$' "$file" | head -3 | cut -d: -f1 | tr '\n' ',' | sed 's/,$//')"
  fi

  # Missing final newline
  if [[ -s "$file" && $(tail -c 1 "$file" | wc -l) -eq 0 ]]; then
    err "$file_rel — Missing newline at end of file (EOF)"
  fi

  # Hard tabs in indentation
  if grep -qE '^[ ]*	' "$file" 2>/dev/null; then
    warn "$file_rel — Contains tab characters in indentation (use 2 spaces)"
  fi

  # --- Check 2: File Size ---
  line_count=$(wc -l < "$file")
  if [[ $line_count -gt 300 ]]; then
    warn "$file_rel — File has $line_count lines (prefer <300 lines; split into domain folder + facade)"
  fi

  # --- Check 3: Deprecated Libraries ---
  if grep -qE 'import[[:space:]]+[A-Za-z0-9_]+[[:space:]]+"mo:base' "$file" 2>/dev/null; then
    err "$file_rel — Uses deprecated 'mo:base'. Must use 'mo:core' (2.x)"
  fi

  # --- Check 4: Architecture Layering Rules ---
  # Rule 4a: api/ cannot import storage/ directly
  if [[ "$file" == */api/* ]]; then
    if grep -qE 'import[[:space:]]+[A-Za-z0-9_]+[[:space:]]+".*storage/' "$file" 2>/dev/null; then
      err "$file_rel — Layering violation: api/ must not import storage/ directly (must go through services/)"
    fi
  fi

  # Rule 4b: validators/ must be pure (no storage, repo, service, ledger)
  if [[ "$file" == */validators/* ]]; then
    if grep -qE 'import[[:space:]]+[A-Za-z0-9_]+[[:space:]]+".*(storage|repositories|services|ledger)/' "$file" 2>/dev/null; then
      err "$file_rel — Purity violation: validators/ must be pure logic only (cannot import storage, repositories, services, or ledger)"
    fi
  fi

  # Rule 4c: storage/ should not import services or api
  if [[ "$file" == */storage/* ]]; then
    if grep -qE 'import[[:space:]]+[A-Za-z0-9_]+[[:space:]]+".*(services|api)/' "$file" 2>/dev/null; then
      err "$file_rel — Layering violation: storage/ must not import services/ or api/"
    fi
  fi

  # Rule 4d: repositories/ should not import services or api
  if [[ "$file" == */repositories/* ]]; then
    if grep -qE 'import[[:space:]]+[A-Za-z0-9_]+[[:space:]]+".*(services|api)/' "$file" 2>/dev/null; then
      err "$file_rel — Layering violation: repositories/ must not import services/ or api/"
    fi
  fi

  # --- Check 5: Naming Conventions ---
  # In backend/src: files must be PascalCase.mo, except main.mo and types.mo
  if [[ "$file" == */backend/src/* && "$filename" != "main.mo" && "$filename" != "types.mo" ]]; then
    if [[ ! "$filename" =~ ^[A-Z][a-zA-Z0-9_]*\.mo$ ]]; then
      warn "$file_rel — File name should be PascalCase.mo (found: $filename)"
    fi
  fi

  # Suffix checks in specific folders
  if [[ "$file" == */backend/src/storage/* && "$filename" != *Storage.mo ]]; then
    warn "$file_rel — Storage files should end with *Storage.mo"
  fi
  if [[ "$file" == */backend/src/repositories/* && "$filename" != *Repository.mo ]]; then
    warn "$file_rel — Repository files should end with *Repository.mo"
  fi
  if [[ "$file" == */backend/src/services/* && "$filename" != *Service.mo && "$parent_dir" == "services" ]]; then
    warn "$file_rel — Top-level service files should end with *Service.mo"
  fi

  # --- Check 6: Actor & Upgrade Safety ---
  if [[ "$filename" == "main.mo" ]]; then
    if ! grep -qE 'persistent[[:space:]]+actor' "$file" 2>/dev/null; then
      warn "$file_rel — Should declare 'persistent actor' for native upgrade persistence"
    fi
    if grep -qE 'system[[:space:]]+func[[:space:]]+(preupgrade|postupgrade)' "$file" 2>/dev/null; then
      warn "$file_rel — Detected manual preupgrade/postupgrade in persistent actor. Ensure stable data uses persistent memory"
    fi
  fi

  # --- Check 7: Anti-patterns (Debug.trap for user errors) ---
  if [[ "$file" == */api/* || "$file" == */services/* ]]; then
    if grep -qE 'Debug\.trap\(' "$file" 2>/dev/null; then
      warn "$file_rel — Uses Debug.trap. Return #err(Types.ApiResult) for user errors instead of trapping canister execution"
    fi
  fi

  # Print per-file report if issues occurred
  if [[ $errors -gt $file_errors_before || $warnings -gt $file_warnings_before ]]; then
    echo -e "${RED}✘${NC} ${file_rel}"
  else
    echo -e "${GREEN}✓${NC} ${DIM}${file_rel}${NC}"
  fi
done

# --- Check 8: Compiler Typecheck (moc --check) ---
if $CHECK_COMPILER; then
  echo -e "\n${BOLD}==> Compiler Type Check (moc --check)${NC}"
  MOC_BIN=""
  if command -v mops >/dev/null 2>&1; then
    MOC_BIN="$(cd "$BACKEND_DIR" && mops toolchain bin moc 2>/dev/null || true)"
  fi
  if [[ -z "$MOC_BIN" ]] && command -v moc >/dev/null 2>&1; then
    MOC_BIN="$(which moc)"
  fi

  if [[ -n "$MOC_BIN" && -x "$MOC_BIN" ]]; then
    echo -e "${DIM}Running moc check on main.mo entry point...${NC}"
    if [[ -f "$BACKEND_DIR/src/main.mo" ]]; then
      local_sources=()
      if command -v mops >/dev/null 2>&1; then
        while IFS= read -r arg; do
          [[ -n "$arg" ]] && local_sources+=("$arg")
        done < <(cd "$BACKEND_DIR" && mops sources 2>/dev/null | xargs -n1 || true)
      fi
      if (cd "$BACKEND_DIR" && "$MOC_BIN" --check "${local_sources[@]}" --package pkg pkg --package app src src/main.mo 2>&1); then
        echo -e "${GREEN}✓${NC} moc compiler check passed for backend/src/main.mo"
      else
        err "moc compiler check failed for backend/src/main.mo"
      fi
    fi
  else
    echo -e "${YELLOW}Note: moc compiler binary not found. Skipping compiler typecheck.${NC}"
  fi
fi

# --- Final Summary ---
echo -e "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Files audited:  ${audited}"
if [[ $fixed -gt 0 ]]; then
  echo -e "Files fixed:    ${CYAN}${fixed}${NC}"
fi
echo -e "Warnings:       $([[ $warnings -gt 0 ]] && echo -e "${YELLOW}${warnings}${NC}" || echo "0")"
echo -e "Errors:         $([[ $errors -gt 0 ]] && echo -e "${RED}${errors}${NC}" || echo -e "${GREEN}0${NC}")"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [[ $errors -gt 0 ]]; then
  echo -e "${RED}${BOLD}motoko-validator FAILED with ${errors} error(s).${NC}"
  if ! $AUTO_FIX; then
    echo -e "${DIM}Tip: run 'falcon audit code:motoko --fix' to auto-resolve formatting issues.${NC}"
  fi
  exit 1
fi

if $STRICT_MODE && [[ $warnings -gt 0 ]]; then
  echo -e "${RED}${BOLD}motoko-validator FAILED (strict mode) with ${warnings} warning(s).${NC}"
  exit 1
fi

echo -e "${GREEN}${BOLD}motoko-validator PASSED successfully!${NC}"
exit 0