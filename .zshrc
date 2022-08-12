# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export EDITOR=nvim

export ZSH="$HOME/.oh-my-zsh";

# If go is setup in the home directory then add stuff to the path and setup other variables.
if [[ -d $HOME/go ]]
then
  export GOPATH="$HOME/go";
  export PATH="$GOPATH/bin:$PATH";
fi

# Make sure brew's make is ahead of other stuff in the path.
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
# Put libpq ahead of stuff for path variable.
export PATH="/opt/homebrew/opt/libpq/bin:$PATH";
export PATH="/usr/local/sbin:$PATH"

# For work computer, make sure libsodium makes its way into the path.
if [[ $(hostname | grep "\-TP\-") ]]
then
  export PATH="$PATH:/opt/homebrew/Cellar/libsodium/1.0.18_1/lib"
  # Add libsodium to LD library.
  export LD_LIBRARY_PATH="/opt/homebrew/Cellar/libsodium/1.0.18_1/lib:$LD_LIBRARY_PATH";
fi

# If krew is installed then include that in the PATH as well.
if [[ -d ${KREW_ROOT:-$HOME/.krew}/bin ]]
then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# If the android SDK is present then setup our environment variables.
if [[ -d $HOME/Library/Android/sdk ]]
then
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
end

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

# If its not the work computer enable wakatime. If it is the work computer though then only use git.
if [[ ! $(hostname | grep "\-TP\-") ]]
then
  plugins=(git wakatime)
else
  plugins=(git)
fi

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
eval "$(/opt/homebrew/bin/brew shellenv)"

alias evt='nvim ~/.tmux.conf'
alias ev='nvim ~/.zshrc'
alias sv='source ~/.zshrc'
alias gitsearch='git branch --all | fzf'
alias gc='git checkout $(gitsearch)'
alias view='nvim -R'
alias gl='git log | nvim -R -c ":set ft=git"'
alias docker-credential-gcloud='docker-credential-gcr'

alias gitpod-admin='kubectl kots admin-console --namespace gitpod'

# unset DOCKER_TLS_VERIFY
# unset DOCKER_CERT_PATH
# unset DOCKER_MACHINE_NAME
# unset DOCKER_HOST

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

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
