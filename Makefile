output ?= .agents/interfaces
platform ?= host
swift_sdk ?=

.PHONY: swiftinterface
swiftinterface:
	@./scripts/generate-swiftinterfaces.sh --package-path . --output "$(output)" --platform "$(platform)" $(if $(swift_sdk),--swift-sdk "$(swift_sdk)")
