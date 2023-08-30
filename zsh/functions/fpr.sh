#!/bin/bash

fpr() {
  local ready=false

  while getopts ":r" flag
  do
    case "${flag}" in
      r) ready=true;;
    esac
  done

  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local task_id=$(echo $current_branch | grep -E -o "^[A-Z]*[_-][0-9]*")
  local first_comment=$(git log main..HEAD --reverse --pretty=%s | head)

  echo "$task_id $first_comment"

  local body=$(cat .github/pull_request_template.md | sed "s/FM-###/$task_id/ ; s/TASK-ID/$task_id/")

  if $ready; then
    gh pr create --assignee "@me" -B main --title "[$task_id] $first_comment" --body "$body" -r $(cat ~/firstleaf/reviewers.txt) --label "Ready to merge"
  else
    gh pr create --assignee "@me" -B main --title "[$task_id] $first_comment" --body "$body" -r $(cat ~/firstleaf/reviewers.txt)
  fi
}