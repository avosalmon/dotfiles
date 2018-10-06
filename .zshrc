export LANG=ja_JP.UTF-8

# ----- zplug -----
if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

# enhancd config
export ENHANCD_COMMAND=ed
export ENHANCD_FILTER=ENHANCD_FILTER=fzy:fzf:peco

# Vanilla shell
zplug "yous/vanilli.sh"

# Additional completion definitions for Zsh
zplug "zsh-users/zsh-completions", lazy:true
zplug "felixr/docker-zsh-completion", lazy:true

# Load the Powerlevel9k theme
if [[ ! -d ~/powerlevel9k ]];then
  git clone https://github.com/bhilburn/powerlevel9k.git ~/powerlevel9k
  
  # Install nerd-font
  # https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#option-4-install-nerd-fonts
  brew tap caskroom/fonts
  brew cask install font-hack-nerd-font
fi
source  ~/powerlevel9k/powerlevel9k.zsh-theme
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
DISABLE_UPDATE_PROMPT=true

# Syntax highlighting bundle. zsh-syntax-highlighting must be loaded after
# excuting compinit command and sourcing other plugins.
zplug "zsh-users/zsh-syntax-highlighting", defer:3

# ZSH port of Fish shell's history search feature
zplug "zsh-users/zsh-history-substring-search", defer:3

# It suggests commands as you type, based on command history.
zplug "zsh-users/zsh-autosuggestions"

# Tracks your most used directories, based on 'frecency'.
zplug "rupa/z", use:"*.sh"

# A next-generation cd command with an interactive filter
zplug "b4b4r07/enhancd", use:init.sh

# This plugin adds many useful aliases and functions.
zplug "plugins/git",   from:oh-my-zsh, lazy:true

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

if zplug check "zsh-users/zsh-history-substring-search"; then
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
fi

# ----- zplug -----


# Add color to ls command
export CLICOLOR=1

# auto completion with color
autoload colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# auto completion with sudo
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# activate colors
autoload -Uz colors
colors

# history settings
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# Peco
# http://wayohoo.com/unix/zsh-oh-my-zsh-peco-of-installation-procedure.html
# http://qiita.com/uchiko/items/f6b1528d7362c9310da0
function peco-select-history() {
  local tac
  if which tac > /dev/null; then
      tac="tac"
  else
      tac="tail -r"
  fi
  BUFFER=$(\history -n 1 | \
              eval $tac | \
              peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# auto completion
autoload -Uz compinit
compinit

# display Japanese correctly on auto completion
setopt print_eight_bit

# treat sharp as comment in the command line
setopt interactive_comments

# some homebrew packages are installed in /usr/local/sbin
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# rbenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# composer binaries
export PATH=$HOME/.composer/vendor/bin:$PATH

# alias
alias ll="ls -laG"
alias git='/usr/local/bin/git'
alias composer='docker run -it --rm -v $PWD:/var/app/current -v ~/.composer:/root/.composer oliverlundquist/php7:latest composer'
alias commit='git status && npm run commit'
alias up="docker-compose up -d"
alias down="docker-compose down"

lookup() {
  whois "${1}" | grep "^Name Server" && dig "${1}" ANY +noall +answer | grep "^${1}"
}

