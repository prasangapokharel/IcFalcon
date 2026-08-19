#!/usr/bin/env bash
set -euo pipefail

ROOT="${FALCON_ROOT:?}"
NAME_RAW="${1:-}"

fail() { echo "error: $1" >&2; exit 1; }

[[ -n "$NAME_RAW" ]] || fail "usage: falcon make:feature <Name>  (e.g. Order, Product)"

to_pascal() {
  echo "$1" | sed -E 's/(^|[-_])([a-z])/\U\2/g' | sed 's/[-_]//g'
}

to_camel() {
  local pascal
  pascal="$(to_pascal "$1")"
  echo "$(tr '[:upper:]' '[:lower:]' <<< "${pascal:0:1}")${pascal:1}"
}

to_kebab() {
  echo "$1" | sed -E 's/([a-z])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]' | tr '_' '-'
}

NAME="$(to_pascal "$NAME_RAW")"
name="$(to_camel "$NAME_RAW")"
kebab="$(to_kebab "$NAME")"

TPL="$ROOT/ops/templates/feature"
BACKEND="$ROOT/backend/src"
FRONTEND="$ROOT/frontend"

render() {
  local src="$1"
  local dest="$2"
  sed -e "s/{{Name}}/$NAME/g" \
      -e "s/{{name}}/$name/g" \
      -e "s/{{kebab}}/$kebab/g" \
      "$src" > "$dest"
}

step() { echo "  + $1"; }

step "backend/storage/${NAME}Storage.mo"
render "$TPL/Storage.mo.tpl" "$BACKEND/storage/${NAME}Storage.mo"

step "backend/repositories/${NAME}Repository.mo"
render "$TPL/Repository.mo.tpl" "$BACKEND/repositories/${NAME}Repository.mo"

step "backend/validators/${NAME}Validator.mo"
render "$TPL/Validator.mo.tpl" "$BACKEND/validators/${NAME}Validator.mo"

step "backend/services/${NAME}Service.mo"
render "$TPL/Service.mo.tpl" "$BACKEND/services/${NAME}Service.mo"

step "backend/api/v1/${NAME}.mo"
render "$TPL/Api.mo.tpl" "$BACKEND/api/v1/${NAME}.mo"

if ! grep -q "public type ${NAME} =" "$BACKEND/types.mo"; then
  step "types.mo — add ${NAME} type"
  sed -i "/public type UserProfile = {/i\\
  public type ${NAME} = {\\
    id : Text;\\
    name : Text;\\
    owner : Principal;\\
    createdAt : Int;\\
  };\\
" "$BACKEND/types.mo"
fi

mkdir -p "$FRONTEND/services/$kebab" "$FRONTEND/components/$kebab"

step "frontend/services/${kebab}/${kebab}.ts"
render "$TPL/service.ts.tpl" "$FRONTEND/services/$kebab/$kebab.ts"

step "frontend/components/${kebab}/${kebab}-panel.tsx"
render "$TPL/panel.tsx.tpl" "$FRONTEND/components/$kebab/${kebab}-panel.tsx"

MAIN="$BACKEND/main.mo"
if ! grep -q "${NAME}Api" "$MAIN"; then
  step "main.mo — wire ${NAME} module"
  sed -i "/import FeatureApi/a import ${NAME}Api \"api/v1/${NAME}\";" "$MAIN"
  sed -i "/import FeatureService/a import ${NAME}Service \"services/${NAME}Service\";" "$MAIN"
  sed -i "/import FeatureStorage/a import ${NAME}Storage \"storage/${NAME}Storage\";" "$MAIN"
  sed -i "/let features = FeatureStorage.createFeatureMap();/a\\
  let ${name}s = ${NAME}Storage.create${NAME}Map();" "$MAIN"
  sed -i "/transient let featureService = FeatureService.create(features, users);/a\\
  transient let ${name}Service = ${NAME}Service.create(${name}s, users);" "$MAIN"
  sed -i "/include FeatureApi(featureService, mwConfig);/a\\
  include ${NAME}Api(${name}Service, mwConfig);" "$MAIN"
fi

echo ""
echo "Created module: ${NAME}"
echo ""
echo "Next:"
echo "  falcon b:test --local"
echo "  falcon b:deploy --local"
echo ""
echo "Frontend: import { ${NAME}Panel } from \"@/components/${kebab}/${kebab}-panel\""
