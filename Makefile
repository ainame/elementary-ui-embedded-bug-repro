SWIFT_COMPILER_TAG := $(shell swift -print-target-info 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['swiftCompilerTag'])")

.PHOHNY: build

build:
	swift build \
		--swift-sdk $(SWIFT_COMPILER_TAG)_wasm-embedded \
		--configuration release \
		--product WebApp
