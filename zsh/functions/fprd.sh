#!/bin/bash

fprd() {
  local isolated=false

  while getopts ":i" flag
  do
    case "${flag}" in
      i) isolated=true;;
    esac
  done

  echo "Deploying pull request to test env"

  if $isolated; then
    gh pr comment --body "/deploy db=isolated"
  else
    gh pr comment --body "/deploy"
  fi
}