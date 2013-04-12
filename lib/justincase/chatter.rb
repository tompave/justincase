require 'justincase/config'
require 'justincase/vault_manager'
require 'thor'

module JustInCase
  class Chatter
    class << self

      SH = Thor::Shell::Basic.new

      # User name, memoized
      def username
        @username ||= File.basename(File.expand_path("~"))
        return @username
      end



      def setup_chat
        puts "\nHello #{username}, here I'll setup the working directory for you."
        puts "I only need to know where you want it to be located.\n "

        puts "The default path for the working directory is: '~/justincase'."
        change = SH.yes? "  Do you want to change it? (y/n)"
        if change
          root = nil
          until root
            path = SH.ask "  Ok, enter the path for the working dir (Don't worry, I'll ask for confirmation):\n "
            path = File.expand_path(path)
            ok = SH.yes? "  I've got this one: '#{path}'.\n  Is it correct? (y/n)"
            root = path if ok
          end
        else
          root = JustInCase::Config::DEFAULT_WORKING_DIR
        end
        puts "\nOk, I'm using this path: '#{root}'.\nI will store it as a String in '~/.justincaserc',\nthen I will build it using 'mkdir -p'."
        confirm = SH.yes? "  Do you confirm? (y/n)".colorize(:red)
        if confirm
          puts "  Building the directory tree...".colorize(:green)
          JustInCase::Config.root_dir = root
          JustInCase::Config.write_rc_file # this will read from JustInCase::Config.root_dir 
          JustInCase::VaultManager.build_dir_tree
          puts "  Done!".colorize(:green)
        else
          puts "Ok, aborting...\n "
        end
      end





    end # end class << self
  end # end class Chatter
end # module JustInCase