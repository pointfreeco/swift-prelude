imports = \
	@testable import PreludeTests; \
	@testable import EitherTests; \
	@testable import FrpTests; \
	@testable import OpticsTests; \
	@testable import ReaderTests; \
	@testable import StateTests; \
	@testable import TupleTests; \
	@testable import ValidationNearSemiringTests; \
	@testable import ValidationSemigroupTests; \
	@testable import WriterTests;

xcodeproj:
	swift package generate-xcodeproj --xcconfig-overrides=Development.xcconfig
	xed .

linux-main:
	sourcery \
		--sources ./Tests/ \
		--templates ./.sourcery-templates/ \
		--output ./Tests/ \
		--args testimports='$(imports)' \
		&& mv ./Tests/LinuxMain.generated.swift ./Tests/LinuxMain.swift

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
		-destination platform="iOS Simulator,name=iPhone 8,OS=11.3" \
		| xcpretty

test-swift:
	swift test

test-all: test-linux test-mac test-ios
