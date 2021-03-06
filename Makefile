VERSION=0.3.7
TARGETS_NOVENDOR=$(shell glide novendor)

all: bin/cachectl bin/cachectld

build-cross: cmd/cachectl/cachectl.go cmd/cachectld/cachectld.go cachectl/*.go
	GOOS=linux GOARCH=amd64 go build -ldflags '-s -w' -o bin/linux/amd64/cachectl-${VERSION}/cachectl cmd/cachectl/cachectl.go
	GOOS=linux GOARCH=amd64 go build -ldflags '-s -w' -o bin/linux/amd64/cachectl-${VERSION}/cachectld cmd/cachectld/cachectld.go

dist: build-cross
	cd bin/linux/amd64 && tar cvf cachectl-linux-amd64-${VERSION}.tar cachectl-${VERSION} && zopfli cachectl-linux-amd64-${VERSION}.tar

bundle:
	glide install

bin/cachectl: cmd/cachectl/cachectl.go cachectl/*.go
	go build $(GOFLAGS) -o bin/cachectl cmd/cachectl/cachectl.go

bin/cachectld: cmd/cachectld/cachectld.go cachectl/*.go
	go build $(GOFLAGS) -o bin/cachectld cmd/cachectld/cachectld.go

fmt:
	@echo $(TARGETS_NOVENDOR) | xargs go fmt

clean:
	rm -rf bin/*
