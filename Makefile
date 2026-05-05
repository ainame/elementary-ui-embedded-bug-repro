.PHOHNY: build

build:
	swift build \
		--swift-sdk swift-6.3.2-RELEASE_wasm-embedded \
		--configuration release \
		--product WebApp
