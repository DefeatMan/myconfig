export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

autoload bashcompinit
bashcompinit

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

# Ranger Export
export RANGER_LOAD_DEFAULT_RC=false
alias rr='ranger'
export EDITOR="vim"
export HIGHLIGHT_STYLE="base16/gruv_box-dark-hard"

# Bindkey
# for rxvt
bindkey '[3~' delete-char # NOTICE remove in ubuntu

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

bindkey '[1;5A' history-search-backward
bindkey '[1;5B' history-search-forward

bindkey '[1;5C' forward-word
bindkey '[1;5D' backward-word

autoload -U colors && colors

autoload -Uz compinit && compinit -u
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

if [ ${UID} -eq 0 ]; then
PROMPT="%F{red}%n%{$rest_color%}@%F{166}%m%{$reset_color%} %F{118}%1|%~%{$reset_color%} %# "
else
PROMPT="%F{135}%n%{$rest_color%}@%F{166}%m%{$reset_color%} %F{118}%1|%~%{$reset_color%} \$ "
fi
RPROMPT="[%{$fg_bold[yellow]%}%?%{$reset_color%}]"

# GO Proxy
export GOPROXY=https://goproxy.cn,direct
export GO111MODULE=on

# export PYTHONPATH=$PYTHONPATH:/usr/lib/python3.11/site-packages/
export PYENV_ROOT=${HOME}/.pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# FZF Export
alias fvim='vim $(fzf)'
# export FZF_DEFAULT_COMMAND="find ! -name '*.git,*.vscode,*.idea' -type f"
export FZF_DEFAULT_COMMAND='ag --hidden -p <(printf "%s/\n" .git .svn .vscode .idea .vim node_modules build .sass-cache) -l -g ""'
export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"

[[ -s /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -s /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# LDLibrary
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# Golang Export
export GOROOT=/usr/lib/go
export GOPATH=~/workspace/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:/usr/local/bin:$GOROOT/bin:$GOBIN
export ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH=go1.20

# Plugin
[[ -s /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -s /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Z
export _Z_CMD=j
# git clone https://github.com/rupa/z.git
[[ -s ${HOME}/gitrepo/z/z.sh ]] && source ${HOME}/gitrepo/z/z.sh

# Nvm
[ -z "$NVM_DIR" ] && export NVM_DIR="${HOME}/.nvm"
[[ -s /usr/share/nvm/nvm.sh ]] && source /usr/share/nvm/nvm.sh
[[ -s /usr/share/nvm/bash_completion ]] && source /usr/share/nvm/bash_completion
[[ -s /usr/share/nvm/install-nvm-exec ]] && source /usr/share/nvm/install-nvm-exec

# Alias
alias l='ls -a --color'
alias ll='ls -lah --color'
alias ls='ls --color'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias diff='diff --color'

# End of lines configured by zsh-newuser-install
alias 7z=7zz
alias ddir='du -h --max-depth=1'
