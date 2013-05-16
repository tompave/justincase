require 'justincase/config'
require 'justincase/file_system/private_files'
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
        puts "I only need to know where you want it to be located."
        puts "(don't worry, I'll ask for confirmation before doing anything stupid)\n "

        if JustInCase::FileSystem::PrivateFiles.rc_file_exists? && orig_dir = JustInCase::FileSystem::PrivateFiles.rc_file_is_valid?
          puts "I've found the file #{JustInCase::Config::RC_FILE_PATH}, and it indicates #{orig_dir} as the working directory.".colorize(:yellow)
          puts "Continuing will overwrite it. You can quit now and manually remove/backup the '.justincaserc' file.".colorize(:yellow)
          return unless SH.yes?("Continue?")
        end

        puts "The default path for the working directory is: '~/justincase'."
        change = SH.yes? "  Do you want to change it? (y/n)"
        if change
          root = nil
          until root
            path = SH.ask "  Ok, enter the path for the working dir:\n "
            path = File.expand_path(path)
            ok = SH.yes? "I've got this one: '#{path}'.\n  Is it correct? (y/n)"
            root = path if ok
          end
        else
          root = JustInCase::Config::DEFAULT_WORKING_DIR
        end
        puts "\nOk, I'm using this path: '#{root}'.\nI will store it as a String in '~/.justincaserc',\nthen I will build it using 'mkdir -p'."
        confirm = SH.yes? "  Do you confirm? (y/n)".colorize(:red)
        if confirm
          JustInCase::Config.root_dir = root
          puts "Writing chosen root dir to '~/.justincaserc'...".colorize(:green)
          JustInCase::FileSystem::PrivateFiles.write_rc_file(true)
          puts "Building the directory tree...".colorize(:green)
          JustInCase::FileSystem::PrivateFiles.build_dir_tree # this will read from JustInCase::Config.root_dir 
          puts "Done!".colorize(:green)
        else
          puts "Ok, aborting...\n "
        end
      rescue Exception => ex
        puts ex.message.colorize(:red)
      end





    end # end class << self
  end # end class Chatter
end # module JustInCase