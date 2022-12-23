PWD=$(shell git rev-parse --show-toplevel)

default-docker:
	$(error Please run a specific target)

ifndef MINIKUBE
wait-for-docker:
	@for i in 1 2 3 4 5; do (docker info > /dev/null 2>&1) && break || echo "Waiting for docker to start..." && sleep 15; done
else
wait-for-docker:
	@eval $$(minikube docker-env) && for i in 1 2 3 4 5; do (docker info > /dev/null 2>&1) && break || echo "Waiting for docker to start..." && sleep 15; done
endif

clean:
	git submodule deinit -f tools/neovim

NEOVIM=$(PWD)/tools/neovim/README.md
$(NEOVIM):
	git submodule update --init tools/neovim

USERNAME=$(shell whoami)
HOME=$(shell echo ~$(USERNAME))
DOCKER_IMAGE_NAME=ghcr.io/elliotcourant/dotfiles/debian
VERSIONED=$(DOCKER_IMAGE_NAME):11.6
LATEST=$(DOCKER_IMAGE_NAME):latest
docker: wait-for-docker $(NEOVIM)
	docker build \
		--cache-from=$(LATEST) \
		--build-arg USERNAME=$(USERNAME) \
		-t $(VERSIONED) \
		-t $(LATEST) \
		-f Dockerfile .

docker-push: docker
	docker push $(VERSIONED)
	docker push $(LATEST)

read:
	cp ~/.zshrc $(PWD)/.zshrc
	cp ~/.tmux.conf $(PWD)/.tmux.conf
	cp ~/.tmux.conf $(PWD)/.tmux.conf
	cp -r ~/.config/nvim/. $(PWD)/nvim

NEOVIM=$(HOME)/.config/nvim
PACKER=$(HOME)/.local/share/nvim/site/pack/packer/start/packer.nvim
install-neovim:
	-[ -d $(NEOVIM) ] && mv $(NEOVIM) $(NEOVIM).backup
	-[ ! -d $(PACKER) ] && git clone --depth 1 https://github.com/wbthomason/packer.nvim $(PACKER)
	-[ ! -L $(NEOVIM) ] && ln -s $(PWD)/nvim $(NEOVIM)

TMUX=$(HOME)/.tmux.conf
install-tmux:
	-[ -f $(TMUX) ] && [ ! -L $(TMUX) ] && mv $(TMUX) $(TMUX).backup
	-[ ! -L $(TMUX) ] && ln -s $(PWD)/.tmux.conf $(TMUX)


IDEAVIM=$(HOME)/.ideavimrc
install-ideavim:
	-[ -f $(IDEAVIM) ] && [ ! -L $(IDEAVIM) ] && mv $(IDEAVIM) $(IDEAVIM).backup
	-[ ! -L $(IDEAVIM) ] && ln -s $(PWD)/.ideavimrc $(IDEAVIM)

MATERIAL=$(HOME)/.oh-my-zsh/themes/material.zsh-theme
install-material:
	-[ -f $(MATERIAL) ] && [ ! -L $(MATERIAL) ] && mv $(MATERIAL) $(MATERIAL).backup
	-[ ! -L $(MATERIAL) ] && ln -s $(PWD)/material.zsh-theme $(MATERIAL)

ZSHRC=$(HOME)/.zshrc
install-zshrc:
	-[ -f $(ZSHRC) ] && [ ! -L $(ZSHRC) ] && mv $(ZSHRC) $(ZSHRC).backup
	-[ ! -L $(ZSHRC) ] && ln -s $(PWD)/.zshrc $(ZSHRC)

LEIN_PROFILE=$(HOME)/.lein/profiles.clj
install-lein-profile:
	-[ ! -d $(dir $(LEIN_PROFILE)) ] && mkdir -p $(dir $(LEIN_PROFILE))
	-[ -f $(LEIN_PROFILE) ] && [ ! -L $(LEIN_PROFILE) ] && mv $(LEIN_PROFILE) $(LEIN_PROFILE).backup
	-[ ! -L $(LEIN_PROFILE) ] && ln -s $(PWD)/lein/profiles.clj $(LEIN_PROFILE)


install: install-tmux install-neovim install-ideavim install-material install-zshrc install-lein-profile
	@echo "Dotfiles installed!"

MARKSMAN_URL=https://github.com/artempyanykh/marksman/releases/download/2022-09-08/marksman-macos

language-servers:
	sudo curl -SsL $(MARKSMAN_URL) --output /usr/local/bin/marksman && sudo chmod +x /usr/local/bin/marksman
