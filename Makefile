xcodeproj:
	xcrun --toolchain swift swift package generate-xcodeproj --xcconfig-overrides=Development.xcconfig
	xed .

linux-main:
	swift test --generate-linuxmain

test-linux: linux-main
	docker build --tag prelude-testing . \
		&& docker run --rm prelude-testing

test-macos: xcodeproj
	set -o pipefail && \
	xcodebuild test \
		-scheme Prelude-Package \
		-destination platform="macOS" \
		| xcpretty

test-ios: xcodeproj
	set -o pipefail && \
	xcodebuild test \
		-scheme Prelude-Package \
		-destination platform="iOS Simulator,name=iPhone 11 Pro Max,OS=13.2.2" \
		| xcpretty

test-swift:
	swift test

test-all: test-linux test-mac test-ios
