PREFIX ?= $(HOME)/.local

run:
	bash termsnake.sh

install:
	mkdir -p $(PREFIX)/bin
	cp termsnake.sh $(PREFIX)/bin/termsnake
	chmod +x $(PREFIX)/bin/termsnake

uninstall:
	rm -f $(PREFIX)/bin/termsnake

.PHONY: run install uninstall
