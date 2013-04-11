require 'justincase/config'

module JustInCase

  class Runner

    def initialize
      #JustInCase::Cli.read_config('justincase.conf.json')
    end

    def start
      loop {
        puts JustInCase::Config.config
        puts ".\n.\n.\n.\n."
        sleep 2
      }
    end
    
  end

end