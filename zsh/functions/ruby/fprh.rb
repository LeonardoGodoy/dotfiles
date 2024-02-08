#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'json'

# Feel free to modifty the messages
ASKING_PR_REVIEW_MESSAGE = 'Hi there, could you help me reviewing this ticket?'.freeze
COMUNICATING_DEPLOYMENT = 'Deploying solidus to *production*'.freeze

def get_pr_list_data
  `gh pr list --author "@me" --json number,url,title`
end

def get_pr_data
  `gh pr view --json number,url,title`
end

def parse_pr_to_text(pr)
  title = pr.title
  task_id_match = title.match(/^\[([A-Z]*[_-][0-9]*)\]/)

  if task_id_match.nil?
    exit_with("PR title must start with [TASK_ID] (e.g [FM-999] Your task), aborting.")
  end

  task_id = task_id_match[1]

  task_link = "[#{task_id}](https://firstleaf.atlassian.net/browse/#{task_id})"
  title_task_link = title.gsub(task_id_match[0], task_link)
  pr_link = "[##{pr.number}](#{pr.url})"

  "> #{title_task_link} #{pr_link}"
end

def exit_with(message)
  $stderr.puts(message)
  exit 1
end

options = OpenStruct.new
OptionParser.new do |opts|
  opts.banner = "Usage: fprh [options] [message]"

  opts.on("-l", "--list", "Lists all open prs") do |r|
    options.list = r
  end

  opts.on("-r", "--review", "Adds default review ask message") do |r|
    options.review = r
  end

  opts.on("-d", "--deploy", "Adds default deployment notification message") do |d|
    options.deploy = d
  end
end.parse!

options.message = ARGV[0]

if options.list
  pr_list = JSON.parse(get_pr_list_data)
  prs = pr_list.map { OpenStruct.new(_1) }
else
  # TODO: Check whether there is an open pr. Display a better error message in case there isn't

  pr = OpenStruct.new(JSON.parse(get_pr_data))
  prs = [pr]
end

rows = prs.map do |pr|
  parse_pr_to_text(pr)
end

message = if options.review
  ASKING_PR_REVIEW_MESSAGE
elsif options.deploy
  COMUNICATING_DEPLOYMENT
else
  options.message
end

content = [message, *rows].compact.join("\n")

puts content

IO.popen('pbcopy', 'w') { |pipe| pipe.puts content }

