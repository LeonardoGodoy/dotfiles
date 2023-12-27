#!/bin/bash

if ! command -v rcdn &>/dev/null
then
  echo 'Installing rcm to manage dotfiles'
  echo 'you can find more at https://github.com/thoughtbot/rcm'
  brew install rcm
  echo
fi

echo 'Uninstalling dotfiles'

rcdn -v -d ~/dotfiles -x install.sh -x uninstall.sh -x README -u 'firstleaf/editorconfig' -U firstleaf
