#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'json'

# TODO: Check whether there is an open pr. Display a better error message in case there isn't

options = OpenStruct.new
OptionParser.new do |opts|
  opts.banner = "Usage: fpd [options]"

  opts.on("-i", "--isolated", "Deploys with an isolated database copied from staging") do |i|
    options.isolated = i
  end

  opts.on("-f", "--frontend", "Also deploys the front end project pointing to this backend pr") do |f|
    options.frontend = f
  end

  opts.on("-d", "--dryrun", "Dryrun") do |d|
    options.dryrun = d
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

body = ["/deploy"]
body.push("db=isolated") if options.isolated
body.push("frontend=true") if options.frontend

command = "gh pr comment --body \"#{body.join(' ')}\""

puts command if options.dryrun

system(command) if !options.dryrun
