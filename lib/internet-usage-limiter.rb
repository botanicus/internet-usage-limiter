require 'yaml'
require 'ostruct'

module InternetUsageLimiter
  def self.config_path
    File.join(File.dirname(__FILE__), '..', 'internet-usage-limiter.yml')
  end

  def self.config
    config = YAML.load_file(self.config_path)
    config['log_file_path'] = File.expand_path(config['log_file_path'])
    OpenStruct.new(config)
  end
end
