# Devtool for opening firstleaf pull requests

# - Opens the PR on githib
# - Adds a title including the Jira task reference
# - Creates a body message based on your commits heading. Linking the Jira task
# - Adds reviewers
# - Copies the task and pr links to your clipbor so you can personally ask for reviews
# - Opens the resulting pr on your browser

# You can adapt all that to your own use even in other githib projects

#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

DEFAULT_TEMPLATE = <<-TEMPLATE
## [TASK-ID](https://firstleaf.atlassian.net/browse/TASK-ID)

BODY
TEMPLATE

def get_current_branch
  `git rev-parse --abbrev-ref HEAD`.chomp
end

def get_commit_messages(branch)
  # command = "git log #{branch}..HEAD --reverse --pretty=%s"
  # system(command).chomp
  `git log main..HEAD --reverse --pretty=%s`.chomp
end

def project_template
  project_template_filename = '.github/pull_request_template.md'
  return nil unless File.exists?(project_template_filename)
  File.read(project_template_filename)
end

def exit_with(message)
  $stderr.puts(message)
  exit 1
end
# ARGV.push('--help') if ARGV.empty?

options = OpenStruct.new
OptionParser.new do |opts|
  opts.banner = "Usage: fpr [options] [title]"

  opts.on("-r", "--redy", "Sets 'Ready for review' tag. Which starts the test suite") do |r|
    options.ready = r
  end

  opts.on("-t", "--[no-]template", "Use project's PR body template") do |t|
    options.template = t
  end

  opts.on("-bBRANCH", "--base=BRANCH", "Base branch. Defaults to main") do |b|
    options.base_branch = b
  end

  opts.on("-o", "--open", "Open pr on your browser once it's created") do |o|
    options.open = o
  end

  opts.on("-c", "--copy-heading", "Copy PR heading message to your clipboard") do |c|
    options.copy_heading = c
  end

  opts.on("-d", "--dryrun", "Dryrun") do |d|
    options.dryrun = d
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

puts options

options.input_title = ARGV[0]

current_branch = get_current_branch
if ['main', 'master'].include?(current_branch)
  exit_with("Currently on main, aborting.")
end

task_id = current_branch.match(/^[A-Z]*[_-][0-9]*/)
if task_id.nil?
  exit_with("Branch name must start with TASK_ID (e.g FM-999-your-task), aborting.")
end
task_id = task_id.to_s

base_branch = options.base_branch || "main"

commit_messages = get_commit_messages(base_branch)
commit_message_lines =  commit_messages.lines

body = if options.template && project_template
  template = project_template
  template.gsub!('TASK-ID', task_id)
          .gsub!('FM-###', task_id)
else
  body_content = commit_message_lines.map { |line| "- #{line}" }.join

  template = DEFAULT_TEMPLATE
  template.gsub!('TASK-ID', task_id)
          .gsub!('BODY', body_content)
end

first_commit_message = commit_message_lines.first.chomp
title_message = options.input_title || first_commit_message
title = "[#{task_id}] #{title_message}"

commands = ["gh pr create --assignee \"@me\""]
commands.push("-B \"#{base_branch}\"")
commands.push("--title \"#{title}\"")

commands.push("-b \"#{body}\"")


# In case you keep adding the same reviewers to your PR's
# I encorage you to add them here, so you don't need to bother doing that every time

# commands.concat("--reviewer dafranco,brunoao86,jvalentino90")
default_reviewers = `head ~/firstleaf/reviewers.txt`.chomp
commands.push("-r #{default_reviewers}")

commands.push("--label \"Ready to merge\"") if options.ready


command = commands.join(" ")
puts command if options.dryrun
system(command) if !options.dryrun

system('ruby ~/dotfiles/zsh/functions/ruby/fprh.rb -r') if options.copy_heading

system("gh pr view --web") if options.open
