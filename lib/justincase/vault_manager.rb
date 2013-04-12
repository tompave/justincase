require 'justincase/config'

require 'fileutils'
require 'colorize'

module JustInCase
  class VaultManager
    SUB_DIRS = ["temp","backups","logs", "logs/debug"]
    class << self

      def build_dir_tree
        @root = JustInCase::Config.root_dir
        FileUtils.mkdir_p(@root)
        SUB_DIRS.each do |dir|
          Dir.mkdir(File.join(@root, dir))
        end

        create_config_file
        create_readme_file
      rescue Exception => ex
        puts ex.message.colorize(:red)
      end

      def create_config_file
        file_path = File.join(@root, "justincase.conf.json")
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

    end # class << self
  end # class VaultManager
end # module JustInCase
