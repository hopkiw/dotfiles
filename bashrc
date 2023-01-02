# Prompt
GREEN_FG="\[\033[01;32m\]"
RESETC="\[\033[0m\]"
export PS1="\$? \${PWD}\n${GREEN_FG}>>>${RESETC} "
PROMPT_COMMAND='RET=$?;\
BRANCH=$(git branch --show-current 2>/dev/null);\
PS1="\$RET \w${BRANCH:+" [${RED_FG}${BRANCH}${RESETC}]"} ${SHLVL}\n${CYAN_FG}>>>${RESETC} ";'

# Variables
export GOPATH=~/go
export PATH=~/.local/bin:~/goroot/bin:$GOPATH/bin:$PATH
export EDITOR=vi
export CGO_ENABLED=0
export LS_COLORS="di=93"
export MANPAGER="vi -M +MANPAGER -"

# Settings
set -o vi
