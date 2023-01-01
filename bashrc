GREEN_FG="\[\033[01;32m\]"
RESETC="\[\033[0m\]"
export PS1="\$? \${PWD}\n${GREEN_FG}>>>${RESETC} "
LS_COLORS="di=93"
export MANPAGER="vi -M +MANPAGER -"
set -o vi
EDITOR=vi
