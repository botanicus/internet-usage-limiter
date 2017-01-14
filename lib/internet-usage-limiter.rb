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
      Time.parse('9:30')..Time.parse('14:00')
    end
  end

  def self.personal_internet_usage_period
    if Time.now.saturday?
      Time.parse('9:30')..Time.parse('18:20')
    elsif Time.now.sunday?
      # none
    else
      Time.parse('14:00')..Time.parse('18:20')
    end
  end
end
