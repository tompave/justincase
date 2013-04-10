require 'resources/templates'
require 'json'

module JustInCase
  class << self

    def config=(hash)
      @config = hash.symbolize_keys!
    end

    def config
      unless @config
        puts "no configuration file was found. I'm using the default configuration".colorize(:blue)
        conf_str = JustInCase::Templates::CONFIG_FILE
        conf_hash = JSON.parse(conf_str)
        self.config = conf_hash
      end
      return @config
    end

  end
end
