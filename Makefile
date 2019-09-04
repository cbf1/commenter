product = commenter
config ?= release
prefix ?= /usr/local

.PHONY: clean
clean:
	swift package clean

.PHONY: build
build:
	swift build -c $(config) --disable-sandbox

.PHONY: install
install: build
	mkdir -p "$(prefix)/bin"
	install ".build/Release/$(product)" "$(prefix)/bin"

.PHONY: uninstall
uninstall:
	rm -f "$(prefix)/bin/$(product)"
