default-docker:
	$(error Please run a specific target)

ifndef MINIKUBE
wait-for-docker:
	@for i in 1 2 3 4 5; do (docker info > /dev/null 2>&1) && break || echo "Waiting for docker to start..." && sleep 15; done
else
wait-for-docker:
	@eval $$(minikube docker-env) && for i in 1 2 3 4 5; do (docker info > /dev/null 2>&1) && break || echo "Waiting for docker to start..." && sleep 15; done
endif

USERNAME=$(shell whoami)
DOCKER_IMAGE_NAME=ghcr.io/elliotcourant/dotfiles/ubuntu
VERSIONED=$(DOCKER_IMAGE_NAME):20.04
LATEST=$(DOCKER_IMAGE_NAME):latest
docker: wait-for-docker
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

NEOVIM=~/.config/nvim
PACKER=~/.local/share/nvim/site/pack/packer/start/packer.nvim

install-neovim:
	-[ -d $(NEOVIM) ] && mv $(NEOVIM) $(NEOVIM).backup
	-[ ! -f $(PACKER) ] && git clone --depth 1 https://github.com/wbthomason/packer.nvim $(PACKER)
	ln -s $(PWD)/nvim $(NEOVIM)