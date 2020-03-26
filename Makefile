.DELETE_ON_ERROR:

NODE_VERSION = 12

uid=$(shell id -u)
gid=$(shell id -g)

all: clean lint test build

.PHONY: clean
clean:
	rm -rf dist node_modules

node_modules:
	yarn install

.PHONY: container-install
container-install:
	docker run --rm -t -u $(uid):$(gid) -v $(CURDIR):/work -w /work -e HOME=/tmp node:$(NODE_VERSION) make node_modules

dist: node_modules src
	yarn run gulp copy

.PHONY: lint
lint: node_modules
	yarn run standard

.PHONY: container-lint
container-lint:
	docker run --rm -t -u $(uid):$(gid) -v $(CURDIR):/work -w /work -e HOME=/tmp node:$(NODE_VERSION) make lint

.PHONY: build
build: node_modules dist

.PHONY: test
test: node_modules
	yarn test

.PHONY: testci
testci: node_modules
	yarn testci

.PHONY: container-test
container-test:
	docker run --rm -t -u $(uid):$(gid) -v $(CURDIR):/work -w /work -e HOME=/tmp node:$(NODE_VERSION) make test

.PHONY: container-testci
container-testci:
	docker run --rm -t -u $(uid):$(gid) -v $(CURDIR):/work -w /work -e HOME=/tmp node:$(NODE_VERSION) make testci

.PHONY: container-build
container-build:
	docker run --rm -t -u $(uid):$(gid) -v $(CURDIR):/work -w /work -e HOME=/tmp node:$(NODE_VERSION) make build

.PHONY: container-deploy
container-deploy:
	docker run --rm -t -u $(uid):$(gid) -v $(CURDIR):/work -w /work -e HOME=/tmp node:$(NODE_VERSION) make deploy

.PHONY: deploy
deploy: node_modules
	yarn deploy
