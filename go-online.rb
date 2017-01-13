#!/usr/bin/env ruby

require_relative 'lib/internet-usage-limiter'

if ARGV.length < 2
  abort "Usage: #{$0} [time in minutes] [purpouse of the session]"
end

minutes = ARGV.shift.to_i
reason = ARGV.join(" ")

log_file_path = InternetUsageLimiter.config.log_file_path ||
  File.join(ENV['HOME'], 'Desktop', 'Internet usage.log')

from, to = Time.now, Time.now + minutes * 60

File.open(log_file_path, 'a') do |file|
  file.puts("#{from.strftime("%d/%m/%Y %H:%M")} - #{to.strftime("%H:%M")} (#{minutes}min) #{reason}")
end
