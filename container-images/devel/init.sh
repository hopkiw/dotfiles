#!/bin/bash

. $HOME/.bashrc

echo "Started init.sh."
if [[ -n "$GIT_REPO" ]]; then
  echo "GIT_REPO=${GIT_REPO}"
  echo "GIT_ORG=${GIT_ORG:=GoogleCloudPlatform}"
  echo "GIT_ROOT=${GIT_ROOT:=/host/git}"
  if [[ -z "$GIT_PATH" ]]; then
    GIT_PATH="${GIT_ROOT}/${GIT_ORG}/${GIT_REPO}"
  fi
  echo "GIT_PATH=${GIT_PATH}"
fi

if [[ -n "$GIT_REPO" ]]; then
  git clone "https://github.com/${GIT_ORG}/${GIT_REPO}.git"
  cd "$GIT_REPO"
  git remote add hopkiw "https://github.com/hopkiw/${GIT_REPO}.git"
  git fetch hopkiw
fi

# TODO: check if tini is running.
while true; do
  sleep 1;
done

exit 0
