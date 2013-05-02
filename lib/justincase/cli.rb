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
    map "--setup" => :setup




    desc "generate_config", "Generate a configuration file in the current directory"
    option :to, :required => true,
                :banner => "path",
                :desc => "a custom path to generate the file to, comprising the file name"
    def generate_config
      if options[:to]
        file_path = File.expand_path(options[:to])
      else
        file_path = File.expand_path(File.join(".",JustInCase::Config::CONFIG_FILE_NAME))
      end

      if File.exists?(file_path)
        puts "Watch out: config file already exists at:\n   \
        #{file_path}\nYou should move it or rename it first. Aborting.".colorize(:red)
      else
        puts "Generating config file:\n  #{file_path}".colorize(:cyan)
        JustInCase::FileSystem::PrivateFiles.create_config_file_to(file_path)
      end
    rescue Exception => ex
      puts ex.message.colorize(:red)
    end






    desc "current_config","Print the current configuration"
    def current_config
      conf_hash = JustInCase::Config.config
      return unless conf_hash
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
      puts "justincase " + JustInCase::Meta::VERSION
    end
    map "-v" => :version
    map "--version" => :version


    desc "start",
    "Start the 'justincased' daemon. justincased is responsible for monitoring the\
     file system according to the settings found in the condfig file."
    #option :conf_file
    def start
      if success = JustInCase::Config.init
        puts "success!!!!!!".colorize(:green)
      else
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




#default_task :default


    # desc "default", "should be hidden", hide: true
    # def default(args = :help)
    #   unless self.respond_to?(args)
    #     puts "justincase: invalid command '#{args}'"
    #     help
    #     return
    #   end
    #   help
    # rescue Exception => ex
    #   puts "JustInCase::Cli#default exception: #{ex.message}".colorize(:red)
    # end


    # def help(task = nil, subcommand = false)
    #   puts "ciaoooo".colorize(:green)
    #   super(task, subcommand)
    #   puts "ciaoooo".colorize(:red)
    # end



