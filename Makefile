PWD=$(shell git rev-parse --show-toplevel || pwd)

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

OS ?= $(shell uname -s | tr A-Z a-z)
UNAME_P := $(shell uname -p)
ifeq ($(UNAME_P),x86_64)
	ARCH=amd64
endif
ifneq ($(filter %86,$(UNAME_P)),)
	# This can happen on macOS with Intel CPUs, we get an i386 arch.
	ARCH=amd64
endif
ifneq ($(filter arm%,$(UNAME_P)),)
	ARCH=arm64
endif
# If we still didn't figure out the architecture, then just default to amd64
ARCH ?= amd64

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

I3CONFIG=$(HOME)/.config/i3/config
I3CONFIG_SOURCE=$(PWD)/i3.conf
$(I3CONFIG): $(I3CONFIG_SOURCE)
	-[ ! -d $(dir $(I3CONFIG)) ] && mkdir -p $(dir $(I3CONFIG))
	-[ -f $(I3CONFIG) ] && [ ! -L $(I3CONFIG) ] && mv $(I3CONFIG) $(I3CONFIG).backup
	-[ ! -L $(I3CONFIG) ] && ln -s $(I3CONFIG_SOURCE) $(I3CONFIG)

KITTY=$(HOME)/.config/kitty/kitty.conf
KITTY_SOURCE=$(PWD)/kitty.conf
$(KITTY): $(KITTY_SOURCE)
	-[ ! -d $(dir $(KITTY)) ] && mkdir -p $(dir $(KITTY))
	-[ -f $(KITTY) ] && [ ! -L $(KITTY) ] && mv $(KITTY) $(KITTY).backup
	-[ ! -L $(KITTY) ] && ln -s $(KITTY_SOURCE) $(KITTY)

DUNST=$(HOME)/.config/dunst/dunstrc
DUNST_SOURCE=$(PWD)/dunst.conf
$(DUNST): $(DUNST_SOURCE)
	-[ ! -d $(dir $(DUNST)) ] && mkdir -p $(dir $(DUNST))
	-[ -f $(DUNST) ] && [ ! -L $(DUNST) ] && mv $(DUNST) $(DUNST).backup
	-[ ! -L $(DUNST) ] && ln -s $(DUNST_SOURCE) $(DUNST)

LEIN_PROFILE=$(HOME)/.lein/profiles.clj
LEIN_PROFILE_SOURCE=$(PWD)/lein/profiles.clj
$(LEIN_PROFILE): $(LEIN_PROFILE_SOURCE)
	-[ ! -d $(dir $(LEIN_PROFILE)) ] && mkdir -p $(dir $(LEIN_PROFILE))
	-[ -f $(LEIN_PROFILE) ] && [ ! -L $(LEIN_PROFILE) ] && mv $(LEIN_PROFILE) $(LEIN_PROFILE).backup
	-[ ! -L $(LEIN_PROFILE) ] && ln -s $(LEIN_PROFILE_SOURCE) $(LEIN_PROFILE)


ifeq ($(OS),linux)
MY_FONTS_DIR=$(PWD)/fonts
MY_FONTS=$(wildcard $(MY_FONTS_DIR)/*.ttf)
FONTS_DIR=$(HOME)/.fonts/f
OTHER_FONTS_DIR=$(HOME)/.local/share/fonts
USR_FONTS_DIR=/usr/share/fonts/truetype/jetbrains
FONTS=$(addprefix $(FONTS_DIR)/,$(notdir $(MY_FONTS))) $(addprefix $(OTHER_FONTS_DIR)/,$(notdir $(MY_FONTS))) $(addprefix $(USR_FONTS_DIR)/,$(notdir $(MY_FONTS)))
$(FONTS): $(MY_FONTS)
	-[ ! -d $(dir $@) ] && mkdir -p $(dir $@)
	-cp $(MY_FONTS_DIR)/$(notdir $@) $@

install-fonts: $(FONTS)
else
install-fonts:
	@echo "Fonts can only be installed on linux at this time."
endif

install: $(ZSHRC)
install: $(NEOVIM_CONFIG)
install: install-tmux install-ideavim install-material install-fonts
install: $(KITTY)
install: $(I3CONFIG)
install: $(DUNST)
install: $(LEIN_PROFILE)
	@echo "Dotfiles installed!"

