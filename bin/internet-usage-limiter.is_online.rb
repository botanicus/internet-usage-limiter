#!/usr/bin/env ruby

require 'internet-usage-limiter'

log = InternetUsageLimiter::LogReader.new
last_log_entry = log.entries.reverse.find { |entry| entry.tags.include?(:online) }
within_an_active_period = last_log_entry.active?

if last_log_entry.tags.include?(:work)
  within_the_work_period = InternetUsageLimiter.work_internet_usage_period &&
    InternetUsageLimiter.work_internet_usage_period.member?(Time.now)

  STDERR.puts <<-EOF
Active work period: #{within_an_active_period} (last: #{last_log_entry.finishes_at})
internet allowancy period: #{within_the_work_period} (#{InternetUsageLimiter.work_internet_usage_period})
  EOF

  (within_an_active_period && within_the_work_period) ? exit(0) : exit(1)
else
  within_the_internet_allowancy_period = InternetUsageLimiter.personal_internet_usage_period &&
    InternetUsageLimiter.personal_internet_usage_period.member?(Time.now)

  STDERR.puts <<-EOF
Active period: #{within_an_active_period} (last: #{last_log_entry.finishes_at})
internet allowancy period: #{within_the_internet_allowancy_period} (#{InternetUsageLimiter.personal_internet_usage_period})
  EOF

  (within_an_active_period && within_the_internet_allowancy_period) ? exit(0) : exit(1)
end
