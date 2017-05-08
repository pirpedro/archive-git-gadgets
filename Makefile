prefix:=/usr/local

datarootdir:=$(prefix)/gadgets

EXEC_FILES:=$(wildcard bin/*)
SCRIPT_FILES:=$(wildcard gadgets/git-bump-*)
SCRIPT_FILES+=$(wildcard gadgets/git-gadgets-*)
SCRIPT_FILES+=$(wildcard gadgets/git-activity-*)
SCRIPT_FILES+=$(wildcard gadgets/git-stats-*)
SCRIPT_FILES+=gadgets/git-common
SCRIPT_FILES+=gadgets/bash-common/bin/sh-common
SCRIPT_FILES+=gadgets/bash-common/bin/sh-extglob

all:
	@echo "usage: make install"
	@echo "       make uninstall"

install:
	install -d -m 0755 $(prefix)/bin
	install -m 0755 $(EXEC_FILES) $(prefix)/bin
	install -d -m 0744 $(datarootdir)
	install -m 0744 $(SCRIPT_FILES) $(datarootdir)
	install -m 0744 .version $(datarootdir)/.version
ifeq ($(SUDO_USER),)
	@echo "Installation complete."
else
	chown -R $(SUDO_USER) $(datarootdir)
	@echo "Installation complete."
endif

uninstall:
	test -d $(prefix)/bin && \
	cd $(prefix)/bin && \
	rm -f $(EXEC_FILES)
	test -d $(datarootdir) && \
	rm -rf $(datarootdir)
