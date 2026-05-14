#############################################
################## HISTORY ##################
#############################################

export HISTTIMEFORMAT='%F %T - '
export HISTCONTROL=ignoreboth # ignore commands that start with a space, ignore duplicate commands and
export HISTFILESIZE=50G
export PROMPT_COMMAND='history -a'

##################################################
################### VARIABLES ####################
##################################################
export ANSIBLE_NOCOWS=1
export KUBECONFIG=$(find ~/.kube/clusters -type f | tr '\n' ':')
alias reset_kubeconfig="export KUBECONFIG=$(find ~/.kube/clusters -type f | tr '\n' ':')"

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
alias compose='docker-compose'
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

# vscode
#alias code="$HOME/windows/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"
alias code="/mnt/c/Program\ Files/Microsoft\ VS\ Code/Code.exe"

W() { watch "$*"; }

source $HOME/.bashrc_extra
