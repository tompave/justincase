require 'justincase/daemon_manager'

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
      return false unless JustInCase::DaemonManager.can_start?

      Process.daemon if @config[:daemonize]

      JustInCase::DaemonManager.store_pid(Process.pid)

      loop {
        puts @config.to_s
        puts ".\n.\n.\n.\n."
        sleep 2
      }
    end

  end # class Daemon
end # module JustInCase