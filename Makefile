PLAYGROUND=$(shell pwd)

DOCKER_IMG=nixos/nix
DOCKER_RUN_COMMON=docker run --rm -v ${PLAYGROUND}/nixpkgs:/nixpkgs

PKG?=osqp

help:
	@grep -v "^	" Makefile | grep -v "^ " | grep -v "^$$" | grep -v "^\."
	@echo "-----"
	@echo "https://nixos.org/guides/nix-language.html"
	@echo "https://nixos.org/manual/nixpkgs/stable"
	@echo "https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md"

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


# TODO
# https://devenv.sh/
# nix-prefetch-github --rev 1.3.0 asherikov qpmad
# https://github.com/nix-dot-dev/getting-started-devenv-template
