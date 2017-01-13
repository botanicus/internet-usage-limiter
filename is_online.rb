#!/Users/botanicus/.rubies/ruby-2.3.1/bin/ruby

# System Ruby can't manage Range#include? with Time.

require 'time'
require_relative 'lib/internet-usage-limiter'

log_file_path = InternetUsageLimiter.config.log_file_path ||
  File.join(ENV['HOME'], 'Desktop', 'Internet usage.log')

def work_internet_usage_period
  unless Time.now.saturday? || Time.now.sunday?
    Time.parse('9:30')..Time.parse('14:00')
  end
end

def personal_internet_usage_period
  if Time.now.saturday?
    Time.parse('9:30')..Time.parse('18:20')
  elsif Time.now.sunday?
    # none
  else
    Time.parse('14:00')..Time.parse('18:20')
  end
end

last_log_entry = File.readlines(log_file_path).last.split(" ")
end_of_the_last_period = Time.parse(last_log_entry[3])
within_an_active_period = end_of_the_last_period > Time.now

if last_log_entry[5] == "Work:"
  within_the_work_period = work_internet_usage_period && work_internet_usage_period.member?(Time.now)

  STDERR.puts("Active work period: #{within_an_active_period} (last: #{end_of_the_last_period}), internet allowancy period: #{within_the_work_period} (#{work_internet_usage_period})")

  (within_an_active_period && work_internet_usage_period) ? exit(0) : exit(1)
else
  within_the_internet_allowancy_period = personal_internet_usage_period && personal_internet_usage_period.member?(Time.now)

  STDERR.puts("Active period: #{within_an_active_period} (last: #{end_of_the_last_period}), internet allowancy period: #{within_the_internet_allowancy_period} (#{personal_internet_usage_period})")

  (within_an_active_period && within_the_internet_allowancy_period) ? exit(0) : exit(1)
end
