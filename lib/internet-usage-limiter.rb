require 'yaml'
require 'time'
require 'ostruct'

module InternetUsageLimiter
  def self.config_path
    File.expand_path('~/.config/internet-usage-limiter.yml')
  end

  def self.config
    config = YAML.load_file(self.config_path)
    config['log_file_path'] = File.expand_path(config['log_file_path'] || '~/Desktop/Pomodoro.log')
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

  class LogReader
    def self.log_file_path
      InternetUsageLimiter.config.log_file_path
    end

    def entries
      File.readlines(self.class.log_file_path).map do |entry_line|
        LogEntry.new(entry_line)
      end
    rescue Errno::ENOENT
      []
    end

    def day_entries(time = Time.now)
      beginning_of_the_day = Time.new(time.year, time.month, time.day)
      end_of_the_day = Time.new(time.year, time.month, time.day, 23, 59)
      self.entries.select do |entry|
        (beginning_of_the_day..end_of_the_day).member?(entry.starts_at)
      end
    end
  end

  class LogEntry
    def initialize(line)
      @line = line.split(' ')
    end

    def starts_at
      Time.parse(@line[0..1].join(' '))
    end

    def finishes_at
      self.starts_at + @line[2].match(/\d+/) { |m| m[0].to_i * 60 }
    end

    def active?
      self.finishes_at > Time.now
    end

    def time_till_the_end
      self.finishes_at - Time.now if self.active?
    end

    def description
      @line[3..-1].select { |word| ! word.match(/^#\w+$/) }.join(' ')
    end

    def tags
      @line[3..-1].select { |word| word.match(/^#\w+$/) }.map { |word| word[1..-1].to_sym }
    end

    def to_s
      @line[1..-1].join(' ')
    end
  end
end
