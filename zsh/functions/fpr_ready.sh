#!/bin/bash

fpr_ready() {
  gh pr edit --add-label "Ready to merge"
}

