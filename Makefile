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
	git submodule deinit -f tools/k9s
	git submodule deinit -f tools/golang-tools

NEOVIM=$(PWD)/tools/neovim/README.md
$(NEOVIM):
	git submodule update --init tools/neovim

neovim: $(NEOVIM)

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

PACKER=$(HOME)/.local/share/nvim/site/pack/packer/start/packer.nvim
$(PACKER):
	-[ ! -d $(dir $(PACKER)) ] && mkdir -p $(dir $(PACKER))
	-[ ! -d $(PACKER) ] && git clone --depth 1 https://github.com/wbthomason/packer.nvim $(PACKER)

NEOVIM_CONFIG=$(HOME)/.config/nvim
NEOVIM_CONFIG_SOURCE=$(PWD)/nvim
$(NEOVIM_CONFIG): $(NEOVIM_CONFIG_SOURCE) $(PACKER)
	-[ ! -d $(dir $(NEOVIM_CONFIG)) ] && mkdir -p $(dir $(NEOVIM_CONFIG))
	-[ -d $(NEOVIM_CONFIG) ] && mv $(NEOVIM_CONFIG) $(NEOVIM_CONFIG).backup
	-[ ! -L $(NEOVIM_CONFIG) ] && ln -s $(NEOVIM_CONFIG_SOURCE) $(NEOVIM_CONFIG)

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
ZSHRC_SOURCE=$(PWD)/.zshrc
$(ZSHRC): $(ZSHRC_SOURCE)
	-[ -f $(ZSHRC) ] && [ ! -L $(ZSHRC) ] && mv $(ZSHRC) $(ZSHRC).backup
	-[ ! -L $(ZSHRC) ] && ln -s $(ZSHRC_SOURCE) $(ZSHRC)

KITTY=$(HOME)/.config/kitty/kitty.conf
KITTY_SOURCE=$(PWD)/kitty.conf
$(KITTY): $(KITTY_SOURCE)
	-[ ! -d $(dir $(KITTY)) ] && mkdir -p $(dir $(KITTY))
	-[ -f $(KITTY) ] && [ ! -L $(KITTY) ] && mv $(KITTY) $(KITTY).backup
	-[ ! -L $(KITTY) ] && ln -s $(KITTY_SOURCE) $(KITTY)

LEIN_PROFILE=$(HOME)/.lein/profiles.clj
LEIN_PROFILE_SOURCE=$(PWD)/lein/profiles.clj
$(LEIN_PROFILE): $(LEIN_PROFILE_SOURCE)
	-[ ! -d $(dir $(LEIN_PROFILE)) ] && mkdir -p $(dir $(LEIN_PROFILE))
	-[ -f $(LEIN_PROFILE) ] && [ ! -L $(LEIN_PROFILE) ] && mv $(LEIN_PROFILE) $(LEIN_PROFILE).backup
	-[ ! -L $(LEIN_PROFILE) ] && ln -s $(LEIN_PROFILE_SOURCE) $(LEIN_PROFILE)

install: $(ZSHRC)
install: $(NEOVIM_CONFIG)
install: install-tmux install-ideavim install-material
install: $(KITTY)
install: $(LEIN_PROFILE)
	@echo "Dotfiles installed!"

MARKSMAN_URL=https://github.com/artempyanykh/marksman/releases/download/2022-09-08/marksman-macos

language-servers:
	sudo curl -SsL $(MARKSMAN_URL) --output /usr/local/bin/marksman && sudo chmod +x /usr/local/bin/marksman
