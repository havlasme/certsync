PACKAGE ?= "certsync"
VERSION ?= "$(shell ./bin/certsync --version)"
PATCH ?= 0
DISTNAME ?= ""
DISTARCH ?= "any"

.PHONY: install
install:
	install --directory --group=0 --mode=0755 --owner=0 /etc/certsync
	install --directory --group=0 --mode=0755 --owner=0 /etc/certsync/live
	install --directory --group=0 --mode=0755 --owner=0 /etc/certsync/private
	install --directory --group=0 --mode=0755 --owner=0 /etc/certsync/sync
	install --directory --group=0 --mode=0755 --owner=0 /etc/certsync/sync-hook
	install --directory --group=0 --mode=0755 --owner=0 /etc/certsync/sync-hook/deploy
	install --directory --group=0 --mode=0755 --owner=0 /usr/local/bin
	install --group=0 --mode=0755 --owner=0 bin/certsync /usr/local/bin/certsync
	install --directory --group=0 --mode=0755 --owner=0 /usr/local/libexec
	install --group=0 --mode=0755 --owner=0 libexec/certsync-nethook /usr/local/libexec/certsync-nethook
	install --directory --group=0 --mode=0755 --owner=0 /usr/local/share/doc/certsync
	install --directory --group=0 --mode=0755 --owner=0 /usr/local/share/doc/certsync/script
	install --group=0 --mode=0644 --owner=0 support/libexec/certsync-restrict /usr/local/share/doc/certsync/script/certsync-restrict
	install --directory --group=0 --mode=0755 --owner=0 /etc/bash_completion.d
	install --group=0 --mode=0644 --owner=0 support/bash_completion.d/certsync /etc/bash_completion.d/certsync

.PHONY: uninstall
uninstall:
	-rm /usr/local/bin/certsync
	-rm /usr/local/libexec/certsync-nethook
	-rm --recursive /usr/local/share/doc/certsync
	-rm /etc/bash_completion.d/certsync
	-rm /etc/default/certsync-nethook
	-rm /etc/systemd/system/certsync-nethook.service
	systemctl daemon-reload

.PHONY: systemd
systemd:
	install --group=0 --mode=0644 --owner=0 support/systemd/certsync-nethook.default /etc/default/certsync-nethook
	install --group=0 --mode=0644 --owner=0 support/systemd/certsync-nethook.service /etc/systemd/system/certsync-nethook.service
	systemctl daemon-reload

.PHONY: build-deb
build-deb: check-build-env
	install --directory --mode=0755 build/deb-src/DEBIAN
	install --mode=0644 support/deb/DEBIAN/control build/deb-src/DEBIAN/control
	VERSION="$(VERSION)-$(PATCH)$(DISTNAME)" envsubst < support/deb/DEBIAN/control > build/deb-src/DEBIAN/control
	install --mode=0755 support/deb/DEBIAN/postinst build/deb-src/DEBIAN/postinst
	install --mode=0755 support/deb/DEBIAN/postrm build/deb-src/DEBIAN/postrm
	install --directory --mode=0755 build/deb-src/etc/bash_completion.d
	install --mode=0644 support/bash_completion.d/certsync build/deb-src/etc/bash_completion.d/certsync
	install --directory --mode=0755 build/deb-src/etc/certsync
	install --directory --mode=0755 build/deb-src/etc/certsync/live
	install --directory --mode=0755 build/deb-src/etc/certsync/private
	install --directory --mode=0755 build/deb-src/etc/certsync/sync
	install --directory --mode=0755 build/deb-src/etc/certsync/sync-hook
	install --directory --mode=0755 build/deb-src/etc/certsync/sync-hook/deploy
	install --directory --mode=0755 build/deb-src/etc/default
	install --mode=0644 support/systemd/certsync-nethook.default build/deb-src/etc/default/certsync-nethook
	install --directory --mode=0755 build/deb-src/lib/systemd/system
	install --mode=0644 support/systemd/certsync-nethook.service build/deb-src/lib/systemd/system/certsync-nethook.service
	install --directory --mode=0755 build/deb-src/usr/local/bin
	install --mode=0755 bin/certsync build/deb-src/usr/local/bin/certsync
	install --directory --mode=0755 build/deb-src/usr/local/libexec
	install --mode=0755 libexec/certsync-nethook build/deb-src/usr/local/libexec/certsync-nethook
	install --directory --mode=0755 build/deb-src/usr/share/doc/certsync
	install --directory --mode=0755 build/deb-src/usr/share/doc/certsync/script
	install --mode=0644 support/libexec/certsync-restrict build/deb-src/usr/share/doc/certsync/script/certsync-restrict
	fakeroot dpkg-deb --build build/deb-src/ "build/$(PACKAGE)-$(VERSION)-$(PATCH)$(DISTNAME)_$(DISTARCH).deb"

.PHONY: shellcheck
shellcheck:
ifeq (, $(shell which shellcheck))
	$(error "no shellcheck. try doing apt install shellcheck")
else
	shellcheck bin/certsync
	shellcheck libexec/certsync-nethook
	shellcheck support/libexec/certsync-restrict
endif

.PHONY: clean
clean:
	-rm --recursive build

.PHONY: version
version:
	@echo $(VERSION)-$(PATCH)

.PHONY: check-build-env
check-build-env:
ifndef VERSION
	$(error VERSION must be set!)
endif
ifndef PATCH
	$(error PATCH must be set!)
endif
