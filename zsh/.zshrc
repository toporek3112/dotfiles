#############################################
################## HISTORY ##################
#############################################
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

##################################################
################### VARIABLES ####################
##################################################
export ANSIBLE_NOCOWS=1#
if [ -d "$HOME/.kube/clusters" ]; then
  export KUBECONFIG=$(find ~/.kube/clusters -type f | tr '\n' ':')
fi

##################################################
#################### ALIASES #####################
##################################################

# list
export LS_OPTIONS='--color=auto'
alias l='ls -lh $LS_OPTIONS'
alias ll='ls -lha $LS_OPTIONS'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# docker
alias compose='docker compose'
alias dockeri='docker images'
alias dockerir='docker image rm'
alias dockerp='docker ps'
alias dockerpa='docker ps -a'
alias dockerl='docker logs'
alias dockerlf='docker logs -f'
alias dockzap='f() { docker stop $1 && docker rm $1; }; f'
alias dockernl='docker network ls'
alias dockervl='docker volume ls'
alias dockervp='docker volume prune'
alias dockerprune='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'

# kubectl
alias k="kubectl"
alias kga="kubectl get all"
alias kgaa="kubectl get all --all-namespaces"
alias kvu="kubectl view-utilization -h"
alias watch_prometheus="k -n monitoring get prometheus -w"
alias clusters='l ~/.kube/clusters'

# global aliases (zsh specific)
alias -g NE="2>/dev/null"
alias -g SO="2>&1"
alias -g G="| grep"
alias -g JQ=" | jq"
alias -g YQ=" | yq"
alias -g BATY=" | batcat -l yaml"
alias -g BRANCH='$(git branch --show-current)'
alias -g WCL='| wc -l'
alias -g C=' |  wl-copy'

if command -v batcat >/dev/null 2>&1; then
  alias bat="batcat"
fi
if command -v wl-copy >/dev/null 2>&1; then
  alias -g C= "| wl-copy" # "| clip.exe"
fi

# suffix aliases 
for ext in yaml json yml py go js ts md txt; do
  alias -s $ext="nvim"
done

# because vscode changed how it handles stdout 
openpipe() {
  local f
  f="$(mktemp --suffix=.txt)"
  cat > "$f"
  code -r "$f"
}
alias -g OPEN='| openpipe'

# keybindings 
bindkey -s '^Gl' 'git log'
bindkey -s '^Gs' 'git status'
bindkey -s '^Ga' 'git add .'

# Git commit with commit type from repo
_git_commit_widget() {
 local type
 type=$(commit_type_from_repo)
 if [[ -n "$type" ]]; then
  BUFFER="git commit -m \"${type}\""
  CURSOR=$(( ${#BUFFER} - 4 )) # Position cursor inside ()
 fi
 zle redisplay
}
zle -N _git_commit_widget

bindkey '^Gc' _git_commit_widget
bindkey -s '^Gcc' 'echo "$(git remote get-url origin | sed 's/\.git$//')/commit/$(git rev-parse HEAD)" C'
bindkey -s '^Gt' 'git_token C'
bindkey -s '^Gp' 'git push origin BRANCH'  # Ctrl-g p
bindkey -s '^Q' '\\`\\`\C-b\C-b'  
bindkey -s '^Kk' 'kctx -re ""\C-b'  
bindkey -s '^Kc' 'kctx -re "crossplane"'  
bindkey -s '^kd' 'kctx -re "dev"'  
bindkey -s '^kn' 'kctx -re "nonprod"'  
bindkey -s '^kp' 'kctx -re "prod"'  

# other
autoload zmv

source $HOME/dotfiles/zsh/functions/.zshrc_functions

# zsh 
# for all options see ~/.oh-my-zsh/templates/zshrc.zsh-template
export ZSH="$HOME/.oh-my-zsh"
export ARCHFLAGS="-arch $(uname -m)"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# fzf 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
