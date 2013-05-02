require 'justincase/config'

require 'fileutils'
require 'colorize'

module JustInCase
  module FileSystem




    module PrivateFiles
      SUB_DIRS = ["temp","backups","logs", "logs/debug"]
      class << self
        def build_dir_tree
          @root = JustInCase::Config.root_dir
          FileUtils.mkdir_p(@root)
          SUB_DIRS.each { |dir| FileUtils.mkdir_p(File.join(@root, dir)) }
          create_config_file
          create_readme_file
        rescue Exception => ex
          puts ex.message.colorize(:red)
        end

        def create_config_file
          create_config_file_to(File.join(@root, JustInCase::Config::CONFIG_FILE_NAME))
        end

        def create_config_file_to(file_path)
          FileUtils.mkdir_p(File.dirname(file_path))
          File.open(file_path,"w") { |file| file.write(JustInCase::Templates::CONFIG_FILE) }
        rescue Exception => ex
          puts ex.message.colorize(:red)
        end

        def create_readme_file
          file_path = File.join(@root, "readme.txt")
          File.open(file_path,"w") { |file| file.write(JustInCase::Templates::README_FILE) }
        rescue Exception => ex
          puts ex.message.colorize(:red)
        end

        def nuke_and_rebuild_dir_tree!
          FileUtils.remove_dir(JustInCase::Config.root_dir, true)
          build_dir_tree
        end

        def rc_file_exists?
          return File.exist?(JustInCase::Config::RC_FILE_PATH)
        end



        def write_rc_file(force_replace = false)
          if rc_file_exists?
            if force_replace
              puts "The file '#{JustInCase::Config::RC_FILE_PATH}' already exists. I'm overwriting it.".colorize(:yellow)
            else
              raise PrivateFilesError.new("#{JustInCase::Config::RC_FILE_PATH} already exists.")
            end
          end

          File.open(JustInCase::Config::RC_FILE_PATH,"w") { |file| file.write("root_dir #{JustInCase::Config.root_dir}") }

        rescue Exception => ex
          raise PrivateFilesError.new("Couldn't create the file '~/.justincaserc': #{ex.message}")
        end


        # root_dir /path/to/dir
        def read_from_rc_file
          str = File.open(JustInCase::Config::RC_FILE_PATH) { |file| file.read }
          if str.start_with?("root_dir ")
            str.sub!("root_dir ","")
            return File.expand_path(str)
          else
            return nil
          end
        rescue Errno::ENOENT => err
          puts "Couldn't find the file '~/.justincaserc'.".colorize(:red)
          return nil
        rescue Exception => ex
          puts ex.message.colorize(:red)
          return nil
        end

        alias rc_file_is_valid? read_from_rc_file
        
      end # class << self

      class PrivateFilesError < StandardError ; end

    end # module PrivateFiles

  end # module FileSystem
end # module JustInCase
