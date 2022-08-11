# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set my default editor.
export EDITOR="nvim";

# Path to your oh-my-zsh installation.
export ZSH="/Users/elliotcourant/.oh-my-zsh";
export GOPATH="/Users/elliotcourant/go"
export PATH="$GOPATH/bin:/usr/local/opt/make/libexec/gnubin:$PATH";
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


# For doing android development. Define our SDK root.
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
# Dumb hack, Fuck i hate android.
export JAVA_HOME="/Applications/Android Studio.app/Contents/jre/Contents/Home"
# Within our SDK root we need to add 2 folders to our path. The emulator (used for react native) and tools
export PATH="$PATH:$ANDROID_SDK_ROOT/emulator";
export PATH="$PATH:$ANDROID_SDK_ROOT/tools";
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools";
# We need this for java stuff within android development
export PATH="$JAVA_HOME/bin:$PATH";


# Stuff for PHP development.
export PATH="/usr/local/opt/php@7.4/bin:$PATH"
export PATH="/usr/local/opt/php@7.4/sbin:$PATH"


# These are dependencies for working on php-src
export PATH="/usr/local/opt/bison/bin:$PATH"
export PATH="/usr/local/opt/libiconv/bin:$PATH"

# This is stuff for cocoapods, and react-native
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"


# Gcloud stuff
export PATH="$PATH:$HOME/.gcloud/google-cloud-sdk/bin"


# This is needed for compilers that need access to the bison lib.
unset LDFLAGS;
export LDFLAGS="$LDFLAGS -L/usr/local/opt/bison/lib";
export LDFLAGS="$LDFLAGS -L/usr/local/opt/libiconv/lib";
export LDFLAGS="$LDFLAGS -L/usr/local/opt/zlib/lib"
export LDFLAGS="$LDFLAGS -L/usr/local/opt/openssl@3/lib"

unset CPPFLAGS;
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/libiconv/include";
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/zlib/include";
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/openssl@3/include"





#######################################################################################################################

export TEST_GOOGLE_KMS_CREDENTIALS="$HOME/.monetr/experimental-315918-5fabde83f903.json"
export TEST_GOOGLE_KMS_NAME="projects/experimental-315918/locations/us-central1/keyRings/local-development/cryptoKeys/monetr-development"

#######################################################################################################################


# export PATH="$HOME/.gcloud/google-cloud-sdk/bin:$PATH"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="material"
# ZSH_THEME=robbyrussell
DEFAULT_USER=$USER

export FZF_DEFAULT_COMMAND='rg --files'
#
# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git wakatime)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#

alias evt='nvim ~/.tmux.conf'
alias ev='nvim ~/.zshrc'
alias sv='source ~/.zshrc'
alias gitsearch='git branch --all | fzf'
alias gc='git checkout $(gitsearch)'
alias view='nvim -R'
alias gl='git log | nvim -R -c ":set ft=git"'
alias pipe='glab pipeline status --live'
alias docker-credential-gcloud='docker-credential-gcr'

alias gitpod-admin='kubectl kots admin-console --namespace gitpod'


# unset DOCKER_TLS_VERIFY
# unset DOCKER_CERT_PATH
# unset DOCKER_MACHINE_NAME
# unset DOCKER_HOST
export PGO_APISERVER_URL='https://127.0.0.1:8443'
export PATH=/Users/elliotcourant/.pgo/monetr-staging:$PATH
export PGOUSER=/Users/elliotcourant/.pgo/monetr-staging/pgouser
export PGO_CA_CERT=/Users/elliotcourant/.pgo/monetr-staging/client.crt
export PGO_CLIENT_CERT=/Users/elliotcourant/.pgo/monetr-staging/client.crt
export PGO_CLIENT_KEY=/Users/elliotcourant/.pgo/monetr-staging/client.key
export PGO_NAMESPACE=monetr-staging
#
#
#
# export PATH=/Users/elliotcourant/.pgo/monetr-acceptance:$PATH
# export PGOUSER=/Users/elliotcourant/.pgo/monetr-acceptance/pgouser
# export PGO_CA_CERT=/Users/elliotcourant/.pgo/monetr-acceptance/client.crt
# export PGO_CLIENT_CERT=/Users/elliotcourant/.pgo/monetr-acceptance/client.crt
# export PGO_CLIENT_KEY=/Users/elliotcourant/.pgo/monetr-acceptance/client.key
# export PGO_NAMESPACE=monetr-acceptance

export GITHUB_UPSTREAM=origin

function pr_for_sha {
  git log --merges --ancestry-path --oneline $1..master | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/$GITHUB_UPSTREAM/${PWD##*/}/pull/%
}

export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
source <(plz --completion_script)

# eval $(minikube docker-env)
# export VOLTA_HOME="$HOME/.volta"
# export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
