require 'thor'
require 'justincase'
require 'justincase/thor_overrides'
require 'colorize'
require 'json'

module JustInCase
  
  class Cli < Thor

    default_task :welcome

    desc "welcome", "Print the welcome message with the commands list"
    def welcome
      puts JustInCase::Templates::WELCOME_MESSAGE
      self.help
    end



    desc "generate_config", "Generate a configuration file in the current directory"
    def generate_config
      puts "generating config file".colorize(:cyan)
      if File.exists?('justincase.conf.json')
        puts "error: config file already exists in the current directory.".colorize(:red)
      else
        File.open('justincase.conf.json', 'w') { |file| file.puts(JustInCase::Templates::CONFIG_FILE) }
      end
    end




    desc "read_config CONF_FILE", "Read CONF_FILE and inports the options"
    def read_config(conf_file)
      conf_str = File.open(conf_file).read
      hash = JSON.parse(conf_str)
      JustInCase::Config.config = hash
    rescue JSON::ParserError => err
      puts "Couldn't parse the configuration file. Please check the syntax (the commas!).".colorize(:red)
    rescue Errno::ENOENT => err
      # something like: "No such file or directory - justincase.conf.json"
      puts err.message.colorize(:red)
    end




    desc "configuration","Print the current configuration"
    def configuration
      read_config('justincase.conf.json')
      conf_hash = JustInCase::Config.config
      puts "Current configuration:"
      conf_hash.each_pair do |key, value|
        puts "  -  #{key}: #{value}"
      end
    end


    desc "show_defaults","Print what the default configuration would be like"
    def show_defaults
      defaults = JustInCase::Config.get_defaults
      puts "Defaults:"
      defaults.each_pair do |key, value|
        puts "  -  #{key}: #{value}"
      end
    end




    desc "version","Print the version"
    def version
      puts JustInCase::Meta::VERSION
    end



  end
end








