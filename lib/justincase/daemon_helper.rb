require 'justincase/config'
require 'justincase/daemon'


module JustInCase
  class DaemonHelper


    class << self

      def start
      end


      def store_pid(pid)
        File.open(JustInCase::Config.pid_file_path, "w") { |file| file.write(pid) }
      end



      # Checks if the pid file already exists.
      # If it doesn't exist the daemon is not running, and can start.
      # Id it does esist, it doublechecks if the daemon is actually running
      def can_start?
        pid_file = JustInCase::Config.pid_file_path

        if File.exist?(pid_file)
          pid = File.open(pid_file) { |file| file.read }
          pid = pid.to_i
          if is_running?(pid)
            # it's already running. can't start
            return false
          else
            # pid_file found, but daemon not running.
            puts "pid_file found but daemon not running. overwriting and starting anyway.".yellow
            # can start.
            # since we are here let's delete the old pid_file
            File.delete(pid_file)
            return true
          end
        else
          # pid file not found. can start
          return true
        end
      end



      # from Daemons:
      # http://daemons.rubyforge.org/Daemons/Pid.html#method-c-running-3F
      def is_running?(pid)
        return false unless pid
        # Check if process is in existence.
        # The simplest way to do this is to send signal '0', that doesn't actually send a signal.
        begin
          Process.kill(0, pid)
          return true
        rescue Errno::ESRCH
          # Errno::ESRCH, 'No such process'
          return false
        rescue Errno::EPERM
          # Errno::EPERM, 'Operation not permitted'
          # (process exists but does not belong to us)
          return true
        end
      end

    end # class << self
  end # class DaemonHelper
end # module JustInCase
