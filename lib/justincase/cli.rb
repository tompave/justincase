require 'justincase'
require 'justincase/thor_overrides'

require 'thor'
require 'thor/group'
require 'colorize'
require 'json'
require 'fileutils'

module JustInCase
  
  class Cli < Thor

    default_task :welcome

    desc "welcome", "Print the welcome message with the commands list"
    def welcome
      puts JustInCase::Templates::WELCOME_MESSAGE
      self.help
    end



    desc "generate_config", "Generate a configuration file in the current directory"
    option :output_file
    def generate_config
      file_path = options[:output_file]
      if file_path
        file_path = File.expand_path(file_path)
      else
        file_path = JustInCase::Config::DEFAULT_CONF_FILE_PATH
      end

      if File.exists?(file_path)
        puts "Watch out: config file already exists at:\n   #{file_path}\nYo should move it or rename it first. Aborting.".colorize(:red)
      else
        puts "Generating config file:\n  #{file_path}".colorize(:cyan)
        FileUtils.mkdir_p(File.dirname(file_path))
        File.open(file_path, 'w') { |file| file.write(JustInCase::Templates::CONFIG_FILE) }
      end
    rescue Exception => ex
      puts ex.message.colorize(:red)
    end




    desc "read_config", "looks for the config file and inports the options"
    option :file
    def read_config
      JustInCase::Config.parse_config_file(options[:file])
    end




    desc "current_config","Print the current configuration"
    def current_config
      #read_config('justincase.conf.json')   # should be eliminated
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


    desc "start","start monitoring"
    option :conf_file
    def start
      runner = JustInCase::Runner.new
      runner.start
    end

    desc "stop","stop monitoring"
    option :lol
    def stop
      puts JustInCase::Config.default_working_dir.magenta
      puts JustInCase::Config.default_conf_file_path.blue
      puts options[:lol]
    end


  end # class
end # module








