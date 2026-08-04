#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
package_path="."
output_path=".agents/interfaces"
configuration="release"
include_tests=false
list_declared_platforms=false
platform=""
triple=""
sdk=""
swift_sdk=""
scratch_path=""
declare -a selected_targets=()
declare -a build_arguments=()

usage() {
  sed -n '1,$p' <<'USAGE'
Generate public Swift interfaces for one SwiftPM platform.

Usage:
  generate-swiftinterfaces.sh --platform <platform> [options]
  generate-swiftinterfaces.sh --list-declared-platforms [options]

Options:
  --package-path <path>       Package root (default: .)
  --output <path>             Platform-parent destination, relative to the package root
                              unless absolute (default: .agents/interfaces)
  --platform <name>           Output/build platform, for example macos, ios, linux,
                              windows, or wasi; host resolves to the current platform
  --list-declared-platforms   Print the Apple/custom platforms declared by Package.swift
  --configuration <value>    debug or release (default: release)
  --include-tests             Include Swift test targets
  --target <name>             Generate one target; repeat to select several
  --triple <triple>           Forward a target triple to SwiftPM
  --sdk <path>                Forward an SDK path to SwiftPM
  --swift-sdk <name>          Forward an installed Swift SDK name to SwiftPM
  --scratch-path <path>       Use a specific SwiftPM scratch directory
  --build-arg <argument>      Forward one additional argument to `swift build`; repeatable
  -h, --help                  Show this help

The platform name becomes an output directory. For example, --platform ios writes
<output>/ios/<Module>.swiftinterface. Generate platforms in separate invocations so
one unsupported platform does not suppress successful platform snapshots.
USAGE
}

fail() {
  printf 'swiftinterfaces: %s\n' "$*" >&2
  exit 1
}

require_value() {
  [[ $# -ge 2 ]] || fail "$1 requires a value"
}

host_platform() {
  case "$(uname -s)" in
    Darwin) printf 'macos\n' ;;
    Linux) printf 'linux\n' ;;
    MINGW*|MSYS*|CYGWIN*|Windows_NT) printf 'windows\n' ;;
    *) fail "cannot infer a platform from host $(uname -s); pass --platform explicitly" ;;
  esac
}

normalize_platform() {
  local value
  value="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  case "$value" in
    osx|macosx) value="macos" ;;
    iphoneos|iphonesimulator) value="ios" ;;
    appletvos|appletvsimulator) value="tvos" ;;
    watchsimulator) value="watchos" ;;
    xros|xrsimulator) value="visionos" ;;
    catalyst|mac-catalyst|mac_catalyst) value="maccatalyst" ;;
    wasm|webassembly) value="wasi" ;;
    host) value="$(host_platform)" ;;
  esac
  [[ "$value" =~ ^[a-z0-9][a-z0-9._-]*$ ]] || fail "invalid platform name: $1"
  printf '%s\n' "$value"
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
    --platform)
      require_value "$@"
      [[ -z "$platform" ]] || fail "--platform may be passed only once"
      platform="$2"
      shift 2
      ;;
    --list-declared-platforms)
      list_declared_platforms=true
      shift
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

[[ "$list_declared_platforms" == false || -z "$platform" ]] || \
  fail "--platform and --list-declared-platforms are separate operations"
[[ "$list_declared_platforms" == true || -n "$platform" ]] || \
  fail "--platform is required; use --list-declared-platforms to inspect Package.swift"

command -v swift >/dev/null 2>&1 || fail "Swift is required"
[[ -f "$script_dir/list-swift-targets.swift" ]] || fail "missing package parser beside generator"
[[ -d "$package_path" ]] || fail "package path does not exist: $package_path"

package_root="$(cd "$package_path" && pwd -P)"
[[ -f "$package_root/Package.swift" ]] || fail "no Package.swift at $package_root"
package_identity="$(basename "$package_root" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]/_/g')"

if [[ -n "$platform" ]]; then
  platform="$(normalize_platform "$platform")"
fi

if [[ -z "$scratch_path" ]]; then
  scratch_root="$package_root/.build/swiftinterfaces/${platform:-metadata}/$configuration"
elif [[ "$scratch_path" = /* ]]; then
  scratch_root="$scratch_path"
else
  scratch_root="$package_root/$scratch_path"
fi

mkdir -p "$scratch_root/module-cache"

description_file="$(mktemp "${TMPDIR:-/tmp}/swiftinterfaces-description.XXXXXX")"
targets_file="$(mktemp "${TMPDIR:-/tmp}/swiftinterfaces-targets.XXXXXX")"
platforms_file="$(mktemp "${TMPDIR:-/tmp}/swiftinterfaces-platforms.XXXXXX")"
build_log="$(mktemp "${TMPDIR:-/tmp}/swiftinterfaces-build.XXXXXX")"
cleanup() {
  rm -f "$description_file" "$targets_file" "$platforms_file" "$build_log"
}
trap cleanup EXIT INT TERM

(
  cd "$package_root"
  swift package describe --type json >"$description_file"
)

CLANG_MODULE_CACHE_PATH="$scratch_root/module-cache" \
SWIFT_MODULECACHE_PATH="$scratch_root/module-cache" \
  swift "$script_dir/list-swift-targets.swift" \
    --list-platforms "$description_file" >"$platforms_file"

if [[ "$list_declared_platforms" == true ]]; then
  if [[ -s "$platforms_file" ]]; then
    cat "$platforms_file"
  else
    printf 'swiftinterfaces: Package.swift declares no platforms; support must be proven by a platform build\n' >&2
  fi
  exit 0
fi

host="$(host_platform)"
if [[ -z "$swift_sdk" ]]; then
  sdk_name=""
  default_triple=""
  case "$platform" in
    macos)
      [[ "$host" == "macos" || -n "$triple" || -n "$sdk" ]] || \
        fail "macos generation requires a macOS host or explicit cross-compilation options"
      ;;
    ios)
      sdk_name="iphonesimulator"
      default_triple="arm64-apple-ios-simulator"
      ;;
    tvos)
      sdk_name="appletvsimulator"
      default_triple="arm64-apple-tvos-simulator"
      ;;
    watchos)
      sdk_name="watchsimulator"
      default_triple="arm64-apple-watchos-simulator"
      ;;
    visionos)
      sdk_name="xrsimulator"
      default_triple="arm64-apple-xros-simulator"
      ;;
    maccatalyst)
      sdk_name="macosx"
      default_triple="arm64-apple-ios-macabi"
      ;;
    driverkit)
      sdk_name="driverkit"
      default_triple="arm64-apple-driverkit"
      ;;
    linux|windows)
      [[ "$host" == "$platform" || -n "$triple" || -n "$sdk" ]] || \
        fail "$platform generation requires a $platform host or explicit cross-compilation options"
      ;;
    wasi)
      [[ -n "$triple" || -n "$sdk" ]] || \
        fail "wasi generation requires --swift-sdk (recommended) or explicit --triple/--sdk options"
      ;;
    *)
      [[ -n "$triple" || -n "$sdk" ]] || \
        fail "custom platform $platform requires --swift-sdk or explicit --triple/--sdk options"
      ;;
  esac

  if [[ -n "$sdk_name" ]]; then
    [[ "$host" == "macos" ]] || fail "$platform generation requires Xcode on macOS"
    command -v xcrun >/dev/null 2>&1 || fail "xcrun is required for $platform generation"
    [[ -n "$sdk" ]] || sdk="$(xcrun --sdk "$sdk_name" --show-sdk-path)"
    [[ -n "$triple" ]] || triple="$default_triple"
  fi
fi

if [[ "$output_path" = /* ]]; then
  output_parent="$output_path"
else
  output_parent="$package_root/$output_path"
fi
output_root="$output_parent/$platform"
mkdir -p "$output_root"

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

  printf 'Generating %s (%s) for %s...\n' "$module_name" "$target_name" "$platform"

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
      fail "SwiftPM could not build target $target_name for $platform"
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
    fail "build succeeded but no public interface was found for $target_name ($module_name) on $platform"

  temporary_output="$output_root/.$module_name.swiftinterface.$$"
  cp "$interface_path" "$temporary_output"
  chmod 0644 "$temporary_output"
  mv "$temporary_output" "$output_root/$module_name.swiftinterface"
  generated_count=$((generated_count + 1))
done <"$targets_file"

[[ $generated_count -gt 0 ]] || fail "no interfaces were generated for $platform"
printf 'Generated %d interface(s) in %s\n' "$generated_count" "$output_root"
