require 'thor'
require 'justincase'
require 'justincase/thor_overrides'
require 'colorize'
require 'json'

module JustInCase
  
  class Cli < Thor

    default_task :welcome

    desc "welcome", "prints the welcome message with the commands list"
    def welcome
      puts JustInCase::Templates::WELCOME_MESSAGE
      self.help
    end



    desc "generate_config",
    "generates a configuration file containing the default settings, ready to be overridden"
    def generate_config
      puts "generating config file".colorize(:cyan)
      if File.exists?('justincase.conf.json')
        puts "error: config file already exists in the current directory.".colorize(:red)
      else
        File.open('justincase.conf.json', 'w') { |file| file.puts(JustInCase::Templates::CONFIG_FILE) }
      end
    end




    desc "read_config CONF_FILE", "reads CONF_FILE and inports the options"
    def read_config(conf_file)
      conf_str = File.open(conf_file).read
      hash = JSON.parse(conf_str)
      JustInCase.config = hash
    rescue JSON::ParserError => e
      puts "Couldn't parse the configuration file. Please check the syntax (the commas!).".colorize(:red)
    end




    desc "configuration","prints the current configuration"
    def configuration
      conf_hash = JustInCase.config
      puts "Current configuration:"
      conf_hash.each_pair do |key, value|
        puts "  #{key}: #{value}"
      end
    end




    desc "version","prints the version"
    def version
      puts JustInCase::Meta::VERSION
    end

  end




end
