require 'yaml'
require 'time'
require 'ostruct'

module InternetUsageLimiter
  def self.config_path
    File.expand_path('~/.config/internet-usage-limiter.yml')
  end

  def self.config
    config = YAML.load_file(self.config_path)
    config['log_file_path'] = File.expand_path(config['log_file_path'] || '~/Desktop/Internet usage.log')
    OpenStruct.new(config)
  end

  def self.work_internet_usage_period
    unless Time.now.saturday? || Time.now.sunday?
      schedule = self.config.work_day_work_schedule
      Time.parse(schedule[0])..Time.parse(schedule[1])
    end
  end

  def self.personal_internet_usage_period
    if Time.now.saturday?
      schedule = self.config.saturday_schedule
      Time.parse(schedule[0])..Time.parse(schedule[1])
    elsif Time.now.sunday?
      # none
    else
      schedule = self.config.work_day_personal_schedule
      Time.parse(schedule[0])..Time.parse(schedule[1])
    end
  end
end
