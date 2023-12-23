#!/bin/bash

fpr() {
  local complete=true
  local dryrun=false
  local open=false

  while getopts ":cdo" flag
  do
    case "${flag}" in
      c) complete=false;;
      d) dryrun=true;;
      o) open=true;;
    esac
  done

  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local task_id=$(echo $current_branch | grep -E -o "^[A-Z]*[_-][0-9]*")
  local first_comment=$(git log main..HEAD --reverse --pretty=%s | head -n 1)

  # local body=$(cat .github/pull_request_template.md | sed "s/FM-###/$task_id/ ; s/TASK-ID/$task_id/")
  local body=$(cat ~/dotfiles/zsh/templates/pr_body.txt | sed "s/FM-###/$task_id/ ; s/TASK-ID/$task_id/ ;  s/MESSAGE/$first_comment/ ")

  echo "[$task_id] $first_comment"

  if $dryrun; then
    echo "complete: $complete"
    echo "open: $open"
    echo "body: \n$body"
    echo "gh pr create --assignee \"@me\" -B main --title \"[$task_id] $first_comment\" --body \"$body\" -r $(cat ~/firstleaf/reviewers.txt) --label \"Ready to merge\""
  else
    gh pr create --assignee "@me" -B main --title "[$task_id] $first_comment" --body "$body" -r $(cat ~/firstleaf/reviewers.txt) --label "Ready to merge"
  
    if $complete; then
      fprx -r
      echo 'Review message copied to clipboard'
    fi

    if $open; then
      prv
    fi
  fi
}