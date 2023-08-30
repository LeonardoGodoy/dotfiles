#!/bin/bash

fprx() {
  local message="deployment"

  while getopts ":r" flag
  do
    case "${flag}" in
      r) message="review";;
    esac
  done

  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local task_id=$(echo $current_branch | grep -E -o "^[A-Z]*[_-][0-9]*")
  local first_comment=$(git log main..HEAD --reverse --pretty=%s | head)

  echo "$task_id $first_comment"

  # local number=$(gh pr view --json number | jq -r .number)
  local number=$(gh pr view --json number | jq -r .number)
  local url=$(gh pr view --json url | jq -r .url)
  local body=$(cat ~/dotfiles/zsh/templates/$message\_message.txt | sed "s/FM-###/$task_id/ ; s/TASK-ID/$task_id/ ; s/MESSAGE/$first_comment/ ; s/NUMBER/$number/ ; s URL $url ")

  $(echo "$body" | pbcopy)
  echo "$body"
}
