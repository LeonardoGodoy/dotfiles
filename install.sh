#!/bin/bash

if ! command -v rcup &>/dev/null
then
  echo 'Installing rcm to manage dotfiles'
  echo 'you can find more at https://github.com/thoughtbot/rcm'
  brew install rcm
  echo
fi

echo 'Installing dotfiles'

rcup -v -d ~/dotfiles -x install.sh -x README

