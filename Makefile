VERSION!= $${PWD}/calsnap --version | awk '{print $$3}'

package: dist/calsnap_$(VERSION)_all.deb

clean:
	rm -rf dist

dist/calsnap_$(VERSION)_all.deb: dist
	@ fpm \
		-s dir \
		-n calsnap \
		-t deb \
		-p dist/ \
		--version "$(VERSION)" \
		--maintainer "Jens Bannmann <jens.b@web.de>" \
		--license "public-domain" \
		--category "utils" \
		--architecture "all" \
		--url "https://github.com/bannmann/calsnap" \
		-d "bsdutils" \
		-d "coreutils >= 8.13" \
		--exclude .git \
		--deb-priority "extra" \
		--config-files "/etc/calsnap.conf" \
		--deb-no-default-config-files \
		"calsnap=/usr/bin/calsnap" \
		"calsnap.conf.sample=/etc/calsnap.conf" \
		"README.md=/usr/share/docs/calsnap/README.md" \
		"contrib/=/usr/share/doc/calsnap/contrib/"

dist:
	@ mkdir dist

check:
	if command -v shellcheck >/dev/null; then shellcheck -e SC1091 calsnap; fi
	if command -v shellcheck >/dev/null; then shellcheck -e SC2034 calsnap.conf.sample; fi
	if command -v shfmt >/dev/null; then shfmt -i 4 -d -kp calsnap; fi
	if command -v shfmt >/dev/null; then shfmt -i 4 -d -kp calsnap.conf.sample; fi

.PHONY: \
	check \
	clean \
	package
