require 'justincase/daemon_helper'

require 'listen'



module JustInCase

  class Daemon

    # A private copy of the configuration
    attr_accessor :config

    # constructor
    def initialize(conf)
      @config = conf
    end


    #let's start
    def start
      return false unless JustInCase::DaemonHelper.can_start?

      # I fork the process.
      # In the parent this method will return the pid of the child
      # in the child it will return nil
      child_pid = Process.fork
      puts "child_pid: #{child_pid}".blue
      # if this is the parent
      if child_pid
        JustInCase::DaemonHelper.store_pid(child_pid)
        exit(true) # return and exit
      end

      # change the process name
      $0 = "justincased"

      #Process.daemon if @config[:daemonize]


      loop {
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
