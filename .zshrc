# Path to your oh-my-zsh installation.
if [[ "$(uname -s)" == "Darwin" ]]; then
    export ZSH="/Users/trcm/.oh-my-zsh"
else
    export ZSH="/home/trcm/.oh-my-zsh"
    export GPG_TTY="$(tty)"
fi

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"
#ZSH_THEME="spaceship"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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
# HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  colored-man-pages
  git
  httpie
)
#  vim-plug

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   #export EDITOR='mvim'
   export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias hq="ssh -l trcm -p 8443 hq.axiom-partners.com"
alias kindle="ssh -l root 192.168.2.1"
fat () {
    du -sk * 2> /dev/null | sort -n | perl -ne 'if ( /^(\d+)\s+(.*$)/){$l=log($1+.1);$m=int($l/log(1024)); printf ("%6.1f\t%s\t%25s | %s\n",($1/(2**(10*$m))),(("K","M","G","T","P")[$m]),"*"x(1.5*$l),$2);}'
}
alias dup="find /data/docker -maxdepth 2 -type f -name docker-compose.yml -exec grep -H 'image:' {} \;"
alias l.="ls -d .[^.]*"
printzblock () {
    sudo zdb -ddddd $(df --output=source --type=zfs "$1" | tail -n +2) $(stat -c %i "$1") ;
}
alias banner="figlet"
alias f='vi `fzf -i`'

docker () {
  if [[ "${1}" = "tags" ]]; then
    docker_tag_search $2
  else
    command docker $@
  fi
}

docker_tag_search () {
  # Display help
  if [[ "${1}" == "" ]]; then
    echo "Usage: docker tags repo/image"
    echo "       docker tags image"
    return
  fi

  # Full repo/image was supplied
  if [[ $1 == *"/"* ]]; then
    name=$1

  # Only image was supplied, default to library/image
  else
    name=library/${1}
  fi
  printf "Searching first 5 pages of tags for 10 most recent ${name}"

  # Fetch all pages, because the only endpoint supporting pagination params
  # appears to be tags/lists, but that needs authorization
  results=""
  i=0
  has_more=0
  while [ $has_more -eq 0 ] && [ $i -lt 5 ]
  do
     i=$((i+1))
     result=$(curl "https://registry.hub.docker.com/v2/repositories/${name}/tags/?page=${i}" 2>/dev/null | jq -r '."results"[]["name"]' 2>/dev/null)
     has_more=$?
     if [[ ! -z "${result// }" ]]; then results="${results}\n${result}"; fi
     printf "."
  done
  printf "\n"

  # Sort all tags by version
  sorted=$(
    for tag in "${results}"; do
      echo $tag
    done | grep -E '[[:digit:]]' | grep -Ev 'arm|amd' | sort -V | tail -10
  )

  # Print all tags
  for tag in "${sorted[@]}"; do
    echo $tag
  done
}

function grab(){
    if [[ -x /usr/bin/tmux ]]; then
        declare -A SESSIONS
        while read -r; do
            IFS=":" read -r id description <<< "$REPLY"
            SESSIONS[$id]=$description
        done 2>/dev/null <<<$(tmux ls 2>/dev/null)
        if [[ "${#SESSIONS[@]}" -eq 1 ]]; then
            # If there's only one element, join that session by it's id
            tmux attach-sess -t "${(k)SESSIONS}";
        elif [[ "${#SESSIONS[@]}" -gt 1 ]] && [[ -n "$1" ]]; then
            tmux attach-sess -t "$1";
        elif [[ "${#SESSIONS[@]}" -gt 1 ]] && [[ ! -n "$1" ]]; then
            # Otherwise, prompt for the session name
            echo "Which one?"
            for key in "${(k)SESSIONS[@]}"; do
                echo "${key}"
            done
        fi
    else
        false
    fi
}


# MacOS and Linux specific shell configuration
if [[ "$(uname -s)" == "Darwin" ]]; then

    # Homebrew
    export PATH="$PATH:/usr/local/sbin:/usr/local/bin"
    export PATH="/usr/local/opt/curl/bin:$PATH"
    source /Users/trcm/.secrets   # HOMEBREW_GITHUB_API_TOKEN

    # OpenSSL
    export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
    export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
    export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
    export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

    # PYTHON
    export PYTHONPATH="$(brew --prefix)/lib/python3.9/site-packages:$PYTHONPATH"
    export PATH="$PATH:/User/trcm/Library/Python/3.9/bin/"

    # RUBY
    export PATH="/usr/local/opt/ruby/bin:$PATH"
    export PATH="$PATH:/home/trcm/.local/bin"
    export PATH="$PATH:/usr/local/lib/ruby/gems/2.7.0/bin"
    export PATH="/usr/lib/cargo/bin/:$PATH"
    export LDFLAGS="-L/usr/local/opt/ruby/lib"
    export CPPFLAGS="-I/usr/local/opt/ruby/include"
    export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

    # JAVA
    export PATH="/usr/local/opt/openjdk/bin:$PATH"
    export CPPFLAGS="-I/usr/local/opt/openjdk/include"

    # SRC
    export PATH="$PATH:/Users/trcm/.local/bin"
    export PATH="$PATH:/Users/trcm/Documents/src"

    # GO
    export GOPATH=$HOME/go
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:$GOBIN

    # FZF
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

    # ZSH auto-completion
    source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.zsh
    unalias gf

    if type brew &>/dev/null; then
        export FPATH=$(brew --prefix)/opt/curl/share/zsh/site-functions:$FPATH
        export FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    fi
    export FPATH=$FPATH:~/.zfunc

    zstyle ':completion:*' completer _complete _ignored
    zstyle :compinstall filename '/Users/trcm/.zshrc'
    autoload -Uz compinit
    compinit
else

    # Homebridge token
    source /home/trcm/.secrets   # samsung.smartthings.token

    # PYTHON
    export PYTHONPATH=/usr/local/lib/python3.9/dist-packages:$PYTHONPATH

    # SRC
    export PATH="$PATH:/home/trcm/.local/bin"
    export PATH="$PATH:/home/trcm/src"

    # GO
    export GOPATH=$HOME/go
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:/usr/lib/go/bin:$GOBIN

    # FZF
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

    # ZSH auto-completion
    source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.zsh
    unalias gf
    zstyle ':completion:*' completer _complete _ignored
    zstyle :compinstall filename '/home/trcm/.zshrc'
    autoload -Uz compinit
    compinit
fi
