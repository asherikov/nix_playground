PLAYGROUND=$(shell pwd)

DOCKER_IMG=nixos/nix
DOCKER_RUN_COMMON=docker run --rm -v ${PLAYGROUND}/nixpkgs:/nixpkgs

PKG?=qpmad

help:
	@grep -v "^	" Makefile | grep -v "^ " | grep -v "^$$" | grep -v "^\."
	@echo "-----"
	@echo "https://nixos.org/guides/nix-language.html"
	@echo "https://nixos.org/manual/nixpkgs/stable"
	@echo "https://nixos.org/manual/nix/stable/"
	@echo "https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md"
	@echo "https://nix.dev/tutorials/declarative-and-reproducible-developer-environments"
	@echo "https://nixos.org/manual/nix/stable/command-ref/env-common.html"

pull:
	docker pull ${DOCKER_IMG}

run:
	${DOCKER_RUN_COMMON} -it ${DOCKER_IMG}

build:
	${DOCKER_RUN_COMMON} ${DOCKER_IMG} /bin/sh -c "\
		cd /nixpkgs \
		&& nix-build --keep-failed --attr ${PKG} \
		&& nix-env -f . -iA ${PKG} \
		&& nix-env --query --installed ${PKG} \
		&& nix-env --uninstall ${PKG}"

sha256:
	${DOCKER_RUN_COMMON} ${DOCKER_IMG} /bin/sh -c "\
		nix-prefetch-git --url https://github.com/asherikov/qpmad --quiet --rev v1.3.0"


#nix-shell -p nix-prefetch-git jq --run "nix hash to-sri sha256:\$(nix-prefetch-git --url https://github.com/cli/cli --quiet --rev v2.20.2 | jq -r '.sha256')"

test:
	${DOCKER_RUN_COMMON} ${DOCKER_IMG} /bin/sh -c "cd /nixpkgs && nix-build -v -A ${PKG}.tests"

install:
	bash -c "sh <(curl -L https://nixos.org/nix/install) --no-daemon"

# TODO
# nix-prefetch-github --rev 1.3.0 asherikov qpmad
# https://github.com/nix-dot-dev/getting-started-devenv-template
# nix-store --gc
# https://github.com/tfc/nix_cmake_example
# https://nixos.wiki/wiki/Nix_Installation_Guide#Installing_without_root_permissions
# https://discourse.nixos.org/t/how-to-use-a-local-directory-as-a-nix-binary-cache/655/16
# https://github.com/lopsided98/nix-ros-overlay
# https://nixos.org/guides/ad-hoc-developer-environments.html
# https://nixos.org/guides/how-nix-works.html
# https://ianthehenry.com/posts/how-to-learn-nix/
# https://www.janestreet.com/tech-talks/janestreet-code-review/
# https://stackoverflow.com/questions/58243712/how-to-install-systemd-service-on-nixos
