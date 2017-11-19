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
zplug "zsh-users/zsh-completions"
zplug "felixr/docker-zsh-completion"

# Load the theme.
zplug "yous/lime"
export LIME_SHOW_HOSTNAME=1
export ZSH_THEME="lime"
export LIME_DIR_DISPLAY_COMPONENTS=0

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
zplug "plugins/git",   from:oh-my-zsh

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

# auto completion
autoload -Uz compinit
compinit

# display Japanese correctly on auto completion
setopt print_eight_bit

# treat sharp as comment in the command line
setopt interactive_comments

# rbenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# some homebrew packages are installed in /usr/local/sbin
export PATH=/usr/local/sbin:$PATH

# composer binaries
export PATH=$HOME/.composer/vendor/bin:$PATH

# alias
alias ll="ls -laG"
alias yarn='docker run -it --rm -v $PWD:/usr/src/app -v ~/.gitconfig:/root/.gitconfig -v ~/Library/Caches/Yarn:/usr/local/share/.cache/yarn -w /usr/src/app node:6.11 yarn'
alias composer='docker run -it --rm -v $PWD:/var/app/current -v ~/.composer/auth.json:/root/.composer/auth.json -v ~/.composer/cache:/root/.composer/cache oliverlundquist/php7:latest composer'
alias commit='git status && npm run commit'
