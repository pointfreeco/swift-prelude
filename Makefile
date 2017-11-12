test:
	docker build --tag swift-prelude . && docker run --rm swift-prelude
