#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
package_path="."
output_path=".agents/interfaces"
configuration="release"
include_tests=false
triple=""
sdk=""
swift_sdk=""
scratch_path=""
declare -a selected_targets=()
declare -a build_arguments=()

usage() {
  sed -n '1,$p' <<'USAGE'
Generate public Swift interfaces for SwiftPM targets.

Usage:
  generate-swiftinterfaces.sh [options]

Options:
  --package-path <path>     Package root (default: .)
  --output <path>           Destination, relative to the package root unless absolute
                            (default: .agents/interfaces)
  --configuration <value>  debug or release (default: release)
  --include-tests           Include Swift test targets
  --target <name>           Generate one target; repeat to select several
  --triple <triple>         Forward a target triple to SwiftPM
  --sdk <path>              Forward an SDK path to SwiftPM
  --swift-sdk <name>        Forward an installed Swift SDK name to SwiftPM
  --scratch-path <path>     Use a specific SwiftPM scratch directory
  --build-arg <argument>    Forward one additional argument to `swift build`; repeatable
  -h, --help                Show this help
USAGE
}

fail() {
  printf 'swiftinterfaces: %s\n' "$*" >&2
  exit 1
}

require_value() {
  [[ $# -ge 2 ]] || fail "$1 requires a value"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --package-path)
      require_value "$@"
      package_path="$2"
      shift 2
      ;;
    --output)
      require_value "$@"
      output_path="$2"
      shift 2
      ;;
    --configuration)
      require_value "$@"
      configuration="$2"
      shift 2
      ;;
    --include-tests)
      include_tests=true
      shift
      ;;
    --target)
      require_value "$@"
      selected_targets+=("$2")
      shift 2
      ;;
    --triple)
      require_value "$@"
      triple="$2"
      shift 2
      ;;
    --sdk)
      require_value "$@"
      sdk="$2"
      shift 2
      ;;
    --swift-sdk)
      require_value "$@"
      swift_sdk="$2"
      shift 2
      ;;
    --scratch-path)
      require_value "$@"
      scratch_path="$2"
      shift 2
      ;;
    --build-arg)
      require_value "$@"
      build_arguments+=("$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown option: $1"
      ;;
  esac
done

case "$configuration" in
  debug|release) ;;
  *) fail "--configuration must be debug or release" ;;
esac

command -v swift >/dev/null 2>&1 || fail "Swift is required"
[[ -f "$script_dir/list-swift-targets.swift" ]] || fail "missing target parser beside generator"
[[ -d "$package_path" ]] || fail "package path does not exist: $package_path"

package_root="$(cd "$package_path" && pwd -P)"
[[ -f "$package_root/Package.swift" ]] || fail "no Package.swift at $package_root"
package_identity="$(basename "$package_root" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]/_/g')"

if [[ "$output_path" = /* ]]; then
  output_root="$output_path"
else
  output_root="$package_root/$output_path"
fi

if [[ -z "$scratch_path" ]]; then
  scratch_root="$package_root/.build/swiftinterfaces/$configuration"
elif [[ "$scratch_path" = /* ]]; then
  scratch_root="$scratch_path"
else
  scratch_root="$package_root/$scratch_path"
fi

mkdir -p "$output_root" "$scratch_root/module-cache"

description_file="$(mktemp "${TMPDIR:-/tmp}/swiftinterfaces-description.XXXXXX")"
targets_file="$(mktemp "${TMPDIR:-/tmp}/swiftinterfaces-targets.XXXXXX")"
build_log="$(mktemp "${TMPDIR:-/tmp}/swiftinterfaces-build.XXXXXX")"
cleanup() {
  rm -f "$description_file" "$targets_file" "$build_log"
}
trap cleanup EXIT INT TERM

(
  cd "$package_root"
  swift package describe --type json >"$description_file"
)

declare -a parser_arguments=("$description_file")
if [[ "$include_tests" == true ]]; then
  parser_arguments+=(--include-tests)
fi
if (( ${#selected_targets[@]} > 0 )); then
  for target in "${selected_targets[@]}"; do
    parser_arguments+=(--target "$target")
  done
fi

CLANG_MODULE_CACHE_PATH="$scratch_root/module-cache" \
SWIFT_MODULECACHE_PATH="$scratch_root/module-cache" \
  swift "$script_dir/list-swift-targets.swift" "${parser_arguments[@]}" >"$targets_file"

generated_count=0
while IFS=$'\t' read -r target_name module_name target_type package_name; do
  [[ -n "$target_name" && -n "$module_name" ]] || continue

  printf 'Generating %s (%s)...\n' "$module_name" "$target_name"

  declare -a common_command=(
    swift build
    --package-path "$package_root"
    --scratch-path "$scratch_root"
    --configuration "$configuration"
    --enable-parseable-module-interfaces
  )

  [[ -z "$triple" ]] || common_command+=(--triple "$triple")
  [[ -z "$sdk" ]] || common_command+=(--sdk "$sdk")
  [[ -z "$swift_sdk" ]] || common_command+=(--swift-sdk "$swift_sdk")
  if (( ${#build_arguments[@]} > 0 )); then
    common_command+=("${build_arguments[@]}")
  fi

  declare -a command=("${common_command[@]}")
  if [[ "$target_type" == "test" ]]; then
    command+=(--build-tests -Xswiftc -enable-testing)
  else
    command+=(--target "$target_name")
  fi

  : >"$build_log"
  if ! CLANG_MODULE_CACHE_PATH="$scratch_root/module-cache" \
    SWIFT_MODULECACHE_PATH="$scratch_root/module-cache" \
      "${command[@]}" 2>&1 | tee "$build_log"; then
    if [[ "$target_type" != "test" ]] && \
      grep -Eiq 'multiple targets.*(name|named)' "$build_log"; then
      printf 'Target name is ambiguous; building root package products instead...\n'
      : >"$build_log"
      CLANG_MODULE_CACHE_PATH="$scratch_root/module-cache" \
      SWIFT_MODULECACHE_PATH="$scratch_root/module-cache" \
        "${common_command[@]}" 2>&1 | tee "$build_log"
    else
      fail "SwiftPM could not build target $target_name"
    fi
  fi

  interface_path="$(
    find "$scratch_root" -type f -name "$module_name.swiftinterface" \
      -path "*/$package_name.build/*" -exec ls -t {} + 2>/dev/null | head -n 1 || true
  )"
  if [[ -z "$interface_path" ]]; then
    interface_path="$(
      find "$scratch_root" -type f -name "$module_name.swiftinterface" \
        -exec grep -F -l -- "-package-name $package_identity" {} + 2>/dev/null | head -n 1 || true
    )"
  fi
  if [[ -z "$interface_path" ]]; then
    interface_path="$(
      find "$scratch_root" -type f -name "$module_name.swiftinterface" \
        -exec ls -t {} + 2>/dev/null | head -n 1 || true
    )"
  fi
  [[ -n "$interface_path" && -f "$interface_path" ]] || \
    fail "build succeeded but no public interface was found for $target_name ($module_name)"

  temporary_output="$output_root/.$module_name.swiftinterface.$$"
  cp "$interface_path" "$temporary_output"
  chmod 0644 "$temporary_output"
  mv "$temporary_output" "$output_root/$module_name.swiftinterface"
  generated_count=$((generated_count + 1))
done <"$targets_file"

[[ $generated_count -gt 0 ]] || fail "no interfaces were generated"
printf 'Generated %d interface(s) in %s\n' "$generated_count" "$output_root"
