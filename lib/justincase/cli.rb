require 'justincase'
require 'justincase/thor_overrides'
require 'justincase/chatter'

require 'thor'
require 'thor/group'
require 'colorize'
require 'json'
require 'fileutils'

=begin
  This is the Thor-based interface.
  It presents a frontend and is supposed to work "one-shot".
  Even the commands meant to control the daemon process (justincased)
  are passed to other parts of the program, and the interface exits
  once they are done.
=end

module JustInCase
  
  class Cli < Thor

    default_task :welcome

    desc "welcome", "Print the welcome message with the commands list"
    def welcome
      puts JustInCase::Templates::WELCOME_MESSAGE
      self.help
    end


    desc "setup", "Guided setup. Builds the working directory three"
    def setup
      JustInCase::Chatter.setup_chat
    end




    desc "generate_config", "Generate a configuration file in the current directory"
    option :to, :required => true,
                :banner => "path",
                :desc => "a custom path to generate the file to, comprising the file name"
    def generate_config
      if options[:to_path]
        file_path = File.expand_path(options[:to_path])
      else
        file_path = File.expand_path(File.join(".",JustInCase::Config::CONFIG_FILE_NAME))
      end

      if File.exists?(file_path)
        puts "Watch out: config file already exists at:\n   \
        #{file_path}\nYou should move it or rename it first. Aborting.".colorize(:red)
      else
        puts "Generating config file:\n  #{file_path}".colorize(:cyan)
        JustInCase::VaultManager.create_config_file_to(file_path)
      end
    rescue Exception => ex
      puts ex.message.colorize(:red)
    end




    # desc "read_config", "looks for the config file and inports the options"
    # option :file
    # def read_config
    #   JustInCase::Config.parse_config_file(options[:file])
    # end




    desc "current_config","Print the current configuration"
    def current_config
      JustInCase::Config.init
      conf_hash = JustInCase::Config.config
      puts "Current configuration:"
      conf_hash.each_pair do |key, value|
        puts "  -  #{key}: #{value}"
      end
    end


    desc "show_defaults","Print what the default configuration would be like."
    def show_defaults
      defaults = JustInCase::Config.get_defaults
      puts "Defaults:"
      defaults.each_pair do |key, value|
        puts "  -  #{key}: #{value}"
      end
    end




    desc "version","Print the version."
    def version
      puts JustInCase::Meta::VERSION
    end


    desc "start",
    "Start the 'justincased' daemon. justincased is responsible for monitoring the\
     file system according to the settings found in the condfig file."
    #option :conf_file
    def start
      if success = JustInCase::Config.init
        puts "success!!!!!!".colorize(:green)
      else
        puts "Looks like I haven't been initialized yet.\nYou should run 'justintime setup' first.".colorize(:red)
        return false
      end
    end



    desc "stop","Stop the 'justincased' daemon."
    option :lol, :type => :boolean
    option :aaa, :required => true
    option :bbb, :type => :numeric, :desc => "macacoooooooooooo"
    def stop
      puts JustInCase::Config.root_dir.magenta
      puts "lol: #{options[:lol]}"
      puts "aaa: #{options[:aaa]}"
      puts "bbb: #{options[:bbb]}"
    end


    Signal.trap("INT") do
      puts "\nlol. received a SIGINT. how cute"
      exit(false)
    end


  end # class
end # module








