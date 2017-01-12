#!/usr/bin/env ruby

exit 1 if ARGV.length < 2

minutes = ARGV.shift.to_i
reason = ARGV.join(" ")
log_file = File.join(ENV['HOME'], 'Desktop', 'Internet usage.log')
from, to = Time.now, Time.now + minutes * 60

File.open(log_file, 'a') do |file|
  file.puts("#{from.strftime("%d/%m/%Y %H:%M")} - #{to.strftime("%H:%M")} (#{minutes}min) #{reason}")
end
