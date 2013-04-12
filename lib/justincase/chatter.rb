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
        puts "Just let me collect some variables.\n "

        puts "The default path fot the working directory is: '~/justincase'."
        change = SH.yes? "  Do you want to change it? (y/n)"
        if change
          root = nil
          until root
            path = SH.ask "  Ok, enter the path for the working dir (I'll ask for confirmation):"
            path = File.expand_path(path)
            ok = SH.yes? "  I've got this one: '#{path}'.\n  Is it correct? (y/n)"
            root = path if ok
          end
        else
          root = JustInCase::Config::DEFAULT_WORKING_DIR
        end
        puts "\nOk, I'll proceed now to create this working dir: #{root}"
        confirm = SH.yes? "  Do you confirm? (y/n)".colorize(:red)
        if confirm
          puts "Building the directory tree...".colorize(:green)
          JustInCase::Config.root_dir = root
          JustInCase::VaultManager.build_dir_tree
          puts "Done!".colorize(:blue)
        else
          puts "Ok, aborting...\n "
        end
      end





    end # end class << self
  end # end class Chatter
end # module JustInCase