linux-main:
	sourcery \
		--sources ./Tests/ \
		--templates ./.sourcery-templates/ \
		--output ./Tests/ \
		--args testimports='@testable import PreludeTests; @testable import EitherTests; @testable import DerivingTests; @testable import FrpTests; @testable import NonEmptyTests; @testable import OpticsTests; @testable import ReaderTests; @testable import StateTests; @testable import TupleTests; @testable import ValidationNearSemiringTests; @testable import ValidationSemigroupTests; @testable import WriterTests;' \
		&& mv ./Tests/LinuxMain.generated.swift ./Tests/LinuxMain.swift

test-linux: linux-main
	docker build --tag snapshot-testing . \
		&& docker run --rm snapshot-testing

test-macos:
	set -o pipefail && \
	xcodebuild test \
		-scheme SnapshotTesting-Package \
		-destination platform="macOS" \
		| xcpretty

test-ios:
	set -o pipefail && \
	xcodebuild test \
		-scheme SnapshotTesting-Package \
		-destination platform="iOS Simulator,name=iPhone 8,OS=11.0" \
		| xcpretty

test-swift:
	swift test

test-all: test-linux test-mac test-ios
