xcodeproj:
	xcrun --toolchain swift swift package generate-xcodeproj

test-linux: 
	cp ~/.netrc ./.netrc
	docker build --tag swift-prelude-test . \
		&& docker run --rm swift-prelude-test
	rm ./.netrc

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
	swift test \
		--enable-test-discovery \
		--parallel

test-all: test-linux test-mac test-ios test-swift
