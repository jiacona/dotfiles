# Prompt with VCS
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' unstagedstr "*"
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' formats "%b%u"
zstyle ':vcs_info:git*' actionformats "%b|%a"

autoload add-zsh-hook
add-zsh-hook precmd vcs_info

setopt prompt_subst
NEWLINE=$'\n'
PROMPT='[%*] %F{green}${vcs_info_msg_0_}%f %F{blue}%~%f${NEWLINE}$ '

# fuzzy finder
source "/Users/john/.fzf/shell/completion.zsh"
source "/Users/john/.fzf/shell/key-bindings.zsh"

# Completion
fpath=(
  /usr/local/share/zsh/site-functions
  $fpath
)

autoload -Uz compinit

# Keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey '^[b' backward-word
bindkey '^[f' forward-word
bindkey '^[[3~' delete-char

# History
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

source "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# project dir
SOURCE_DIRECTORY="$HOME/src"

# Aliases
source "$HOME/.common_aliases"

# dotfile bin
PATH="$HOME/.bin:${PATH}"

# Homebrew
PATH="/usr/local/sbin:${PATH}"

# mkdir .git/safe for trusted repositories
PATH=".git/safe/../../node_modules/.bin:${PATH}"
PATH=".git/safe/../../bin:${PATH}"

export -U PATH

# asdf
. $HOME/.asdf/asdf.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit
