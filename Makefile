test:
	sourcery --sources ./Tests/ --templates ./.sourcery-templates/ --output ./Tests/ \
		&& mv ./Tests/LinuxMain.generated.swift ./Tests/LinuxMain.swift \
		&& swift test

test-linux:
	sourcery --sources ./Tests/ --templates ./.sourcery-templates/ --output ./Tests/ \
		&& mv ./Tests/LinusMain.generated.swift ./Tests/LinuxMain.swift \
		&& docker build --tag swift-prelude . \
		&& docker run --rm swift-prelude
