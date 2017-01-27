#!/usr/bin/env ruby

require 'internet-usage-limiter'

log_file_path = InternetUsageLimiter.config.log_file_path

last_log_entry = File.readlines(log_file_path).last.split(" ")
last_log_entry_with_date = "#{last_log_entry[0]} #{last_log_entry[3]}"
end_of_the_last_period = Time.parse(last_log_entry_with_date)
within_an_active_period = end_of_the_last_period > Time.now

if last_log_entry[5] == "Work:"
  within_the_work_period = InternetUsageLimiter.work_internet_usage_period &&
    InternetUsageLimiter.work_internet_usage_period.member?(Time.now)

  STDERR.puts <<-EOF
Active work period: #{within_an_active_period} (last: #{end_of_the_last_period})
internet allowancy period: #{within_the_work_period} (#{InternetUsageLimiter.work_internet_usage_period})
  EOF

  (within_an_active_period && within_the_work_period) ? exit(0) : exit(1)
else
  within_the_internet_allowancy_period = InternetUsageLimiter.personal_internet_usage_period &&
    InternetUsageLimiter.personal_internet_usage_period.member?(Time.now)

  STDERR.puts <<-EOF
Active period: #{within_an_active_period} (last: #{end_of_the_last_period})
internet allowancy period: #{within_the_internet_allowancy_period} (#{InternetUsageLimiter.personal_internet_usage_period})
  EOF

  (within_an_active_period && within_the_internet_allowancy_period) ? exit(0) : exit(1)
end
