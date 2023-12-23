#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'json'

# Feel free to modifty the messages
ASKING_PR_REVIEW_MESSAGE = 'Hi there, could you help me reviewing this ticket?'.freeze
COMUNICATING_DEPLOYMENT = 'Deploying solidus to *production*'.freeze

def get_pr_data
  `gh pr view --json number,url,title`
end

def exit_with(message)
  $stderr.puts(message)
  exit 1
end

options = OpenStruct.new
OptionParser.new do |opts|
  opts.banner = "Usage: fprh [options] [message]"

  opts.on("-r", "--review", "Adds default review ask message") do |r|
    options.review = r
  end

  opts.on("-d", "--deploy", "Adds default deployment notification message") do |d|
    options.deploy = d
  end
end.parse!

options.message = ARGV[0]

# TODO: Check whether there is an open pr. Display a better error message in case there isn't

pr = OpenStruct.new(JSON.parse(get_pr_data))

title = pr.title
task_id_match = title.match(/^\[([A-Z]*[_-][0-9]*)\]/)

if task_id_match.nil?
  exit_with("PR title must start with [TASK_ID] (e.g [FM-999] Your task), aborting.")
end

task_id = task_id_match[1]

task_link = "[#{task_id}](https://firstleaf.atlassian.net/browse/#{task_id})"
title_task_link = title.gsub(task_id_match[0], task_link)
pr_link = "[##{pr.number}](#{pr.url})"

message = if options.review
  ASKING_PR_REVIEW_MESSAGE
elsif options.deploy
  COMUNICATING_DEPLOYMENT
else
  options.message
end

first_line = message ? "#{message}\n" : nil
heading = "#{first_line}> #{title_task_link} #{pr_link}"

puts heading

IO.popen('pbcopy', 'w') { |pipe| pipe.puts heading }
