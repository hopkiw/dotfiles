#!/bin/bash

function _up() {
  shift
  local cur=$1

  COMPREPLY=( $( dirname "${cur:-$PWD}" ) )
  return 0
}
complete -F _up -o nospace up
alias up='cd'


function link_or_rm() {
  local env="$1"
  local tmp="$2"
  if [ -z "${env}" ]; then
    # No auth sock; remove symlink, if any.
    rm -f -- "${tmp}"
    return $?
  fi
  if [ "${env}" != "${tmp}" ]; then
    if [ -e "${tmp}" -a -e "$(readlink -f "${tmp}")" ]; then
      # Existing connection is still valid.
      return 0;
    fi
    # Construct expected symlink to point to auth sock.
    ln -snf -- "${env}" "${tmp}"
  fi
}

function new() {
  [[ $# -lt 1 ]] && return

  local image="$1"
  shift
  if ! [[ "$1" =~ ^\ *-- ]]; then
    local project="$1"
    shift
  fi
  local defaultproject="${image/[0-9]*/cloud}"
  local name="${image}-$(date +%Y%m%d)"
  local cmd="gcloud compute instances create ${name} --image-family ${image}"
  cmd+=" --image-project ${project:-${defaultproject}} $@"

  read -p "Running: ${cmd}"
  last="$name"
  $cmd
}

function _new() {
  local cmd=$1
  local cur=$2
  local prev=$3

  if [ $prev == $cmd ]; then
    local images="debian-{9,10} {centos,rhel}-{6,7,8} sles-{12,15} ubuntu-{1910,{1604,1804}-lts}"
    COMPREPLY=( $(compgen -W "$images" "$cur") )
  else
    local projects="bct-prod-images ubuntu-os-cloud"
    COMPREPLY=( $(compgen -W "$projects" "$cur") )
  fi
  return 0
}
complete -F _new -o nospace new

function attach() {
  [[ $# -eq 2 ]] || return

  local disk="$1"
  local instance="$2"

  if [[ "$disk" =~ ^\+ ]]; then
    local image="$disk"
    local project="${image/[0-9]*/cloud}"
    disk="${image}-$(date +%Y%m%d)"
    cmd="gcloud compute disks create ${disk} --image-family ${image} --image-project ${project}"
    read -p "${cmd} "
    $cmd
  fi

  cmd="gcin attach-disk ${instance} --disk ${disk}"
  read -p "${cmd} "
  $cmd
}

function gitclone() {
  local base=$(basename "$1")
  base="${base%.git}"
  dir="${2:-$base}"

  mkdir "$dir" && cd ./"$dir"
  git init
  git remote add origin "$1"
  git fetch --tags               # refs/remotes/origin/*
  git pack-refs --all            # set origin refs in packed-refs format
  git remote set-head origin -a  # refs/remotes/origin/HEAD, i.e. 'default'
  git checkout origin            # Checkout default branch
}
