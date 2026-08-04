output ?= .agents/interfaces

.PHONY: swiftinterface
swiftinterface:
	@./scripts/generate-swiftinterfaces.sh --package-path . --output "$(output)"
