require 'justincase/daemon_helper'
require 'justincase/config'

require 'logger'
require 'listen'
#require 'pry'


module JustInCase

  class Daemon


    # A private copy of the configuration
    attr_accessor :config

    # constructor
    def initialize(conf)
      @config = conf

      @root_dir = JustInCase::Config.root_dir
      log_path = JustInCase::Config.log_path
      @log = Logger.new(File.join(log_path,"justincase.log"))

      @debug = false
      if @config[:debug_logging]
        @debug = Logger.new(File.join(log_debug_path,"justincase_debug.log"))
      end

      @verbose_output = (!@config[:daemonize] && @config[:verbose])

    end




    # DEBUG INFO WARN ERROR FATAL UNKNOWN
    def deb(str = nil, level = DEBUG)
      @debug.log(level, str) if @debug
    end




    def verb(str)
      puts str if @verbose_output
    end




    # let's start
    def start
      return false unless JustInCase::DaemonHelper.can_start?

      #binding.pry
      @log.info "Starting at: #{Time.now}"

      # I fork the process.
      # In the parent this method will return the pid of the child
      # in the child it will return nil
      child_pid = Process.fork
      
      # if this is the parent
      if child_pid
        puts "this is #{Process.pid} speaking. just forked a child with pid: #{child_pid}".blue
        JustInCase::DaemonHelper.store_pid(child_pid)
        exit(true) # return and exit
      else
        puts "This is the child!! My pid is: #{Process.pid}".magenta
      end

      ## -----------------------------------------
      ## from here, THIS IS THE CHILD


      if @config[:daemonize]
        puts "Daemonizing the process...".colorize(:magenta)
        Process.daemon

        $0 = "justincased" # change the process name

        # Redirecting stdout and stderr
        # Write-only, truncates existing file to zero length or creates a new file for writing.
        $stdout.reopen(File.join(JustInCase::Config.log_std_path, "daemon_stdout.txt"), "w")
        $stderr.reopen(File.join(JustInCase::Config.log_std_path, "daemon_stderr.txt"), "w")
      end

      

      
      


      loop {
        @log.info "let's loop!"
        puts @config.to_s
        puts ".\n.\n.\n.\n."
        sleep 2
      }

    end

    Signal.trap("INT") do
      puts "\nlol. received a SIGINT. how cute (2)"
      exit(false)
    end

  end # class Daemon
end # module JustInCase
