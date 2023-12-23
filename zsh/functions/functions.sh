#!/bin/bash

fprr() {
  # Wait for a while since there is an automation that removes the label after a code push
  (sleep 10 && gh pr edit --add-label "Ready to merge" > /dev/null 2>&1)&
}

fprh() {
  ruby ~/dotfiles/zsh/functions/ruby/fprh.rb $@
}

fprd() {
  ruby ~/dotfiles/zsh/functions/ruby/fprd.rb $@
}

fpr() {
  ruby ~/dotfiles/zsh/functions/ruby/fpr.rb $@
}