# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    echo " %{$fg_bold[green]%}${ref#refs/heads/}%{$reset_color%}"
  fi
}
setopt promptsubst
export PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%c%{$reset_color%}$(git_prompt_info) %# '

# load our own completion functions
fpath=(~/.zsh/completion $fpath)

# completion
autoload -U compinit
compinit

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode
bindkey jj vi-cmd-mode

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/bin:$PATH"

# mkdir .git/safe in the root of repositories you trust
export PATH=".git/safe/../../bin:$PATH"

# npm path
export PATH="$PATH:$HOME/npm/bin"
export NODE_PATH=$NODE_PATH:$HOME/npm/lib/node_modules

# load rbenv if available
if which rbenv &>/dev/null ; then
  eval "$(rbenv init - --no-rehash)"
fi

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/(N-.); do
      case "$config" in
        "$_dir"/pre/*)
          :
          ;;
        "$_dir"/post/*)
          :
          ;;
        *)
          if [ -f $config ]; then
            . $config
          fi
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

#aliases
alias tmux="TERM=screen-256color-bce tmux"

# Use OhMyZsh
export ZSH=$HOME/.oh-my-zsh

# OhMyZsh plugins
plugins=(git zsh_reload extract ssh-agent)

# ssh agent identities
zstyle :omz:plugins:ssh-agent identities id_rsa feedle.pem

source $ZSH/oh-my-zsh.sh

export SCALA_HOME="/usr/local/share/scala"
export PATH="$PATH:$SCALA_HOME/bin"

# Custom prompt config
ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}] "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}:${PWD/#$HOME/~} $(git_prompt_info) $ '

# Local work config if available
[[ -f ~/.workrc ]] && source ~/.workrc

# Loading Tmuxinator if available
[[ -f ~/.bin/tmuxinator.zsh ]] && source ~/.bin/tmuxinator.zsh

# Give windows in tmuxinator their right names
export DISABLE_AUTO_TITLE=true

source $HOME/.rvm/scripts/rvm

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Virtualenv Burrito
VENVBURRITO="$HOME/.venvburrito"
VENVBURRITO_esc="\$HOME/.venvburrito"

# startup virtualenv-burrito
if [ -f $HOME/.venvburrito/startup.sh ]; then
    . $HOME/.venvburrito/startup.sh
fi

# NVIM Gruvbox config
NVIM_TUI_ENABLE_TRUE_COLOR=1
