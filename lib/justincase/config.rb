require 'resources/templates'
require 'justincase/file_system/private_files'

require 'json'
require 'colorize'


module JustInCase

  module Config
    DEFAULT_WORKING_DIR = File.expand_path("~/justincase")
    RC_FILE_PATH = File.expand_path("~/.justincaserc")
    CONFIG_FILE_NAME = "justincase.conf.json"

    # PID_FILE_PATH = File.join(DEFAULT_WORKING_DIR, ".justincased.pid")
    
    # these can be chaneg at runtime once the conf file is parsed
    @root_dir ||= DEFAULT_WORKING_DIR

    class << self
      
      # ------------------------------
      # Accessors

      attr_reader :pid_file_path
      attr_reader :root_dir
      def root_dir=(dir)
        @root_dir = dir
        @pid_file_path = File.join(dir, ".justincased.pid")
      end


      def config=(hash)
        conf_hash = validate_configuration(hash)
        defaults = get_defaults
        @config = defaults.merge(conf_hash)
      rescue JustInCase::Config::ConfigurationError => err
        puts err.message.colorize(:red)
      end



      def config
        self.init unless @config
        return @config
      end


      # ----------------------------------
      # called by JustInCase::Cli.start
      def init
        # returns nil if doesn't exist
        if root = JustInCase::FileSystem::PrivateFiles.read_from_rc_file
          self.root_dir = root
          unless Dir.exists?(@root_dir)
            raise ConfigurationError.new(
              "I found a '~/.justincaserc' file pointing to '#{@root_dir}', 
              but I couldn't locate that directory. Either correct the path indicated in 
              '~/.justincaserc', or delete/move it and run 'justintime setup' again."
              .gsub("              ","").gsub("\n",""))
          end
          parse_config_file # this will always call the setter, even with an emopty hash
          return true
        else
          puts "Looks like I haven't been installed yet.\nYou should run 'justintime setup' first.".colorize(:red)
          return false
        end
      rescue Exception => ex
        puts "Couldn't properly initialize:\n#{ex.message}".colorize(:red)
        return false
      end






      # default cong_hash.
      # already symbolized.
      # memoized.
      def get_defaults
        unless @defaults
          conf_str = JustInCase::Templates::CONFIG_FILE
          conf_hash = JSON.parse(conf_str)
          @defaults = conf_hash.symbolize_keys!
        end
        return @defaults
      end



      def parse_config_file
        hash = {}
        file_path = File.join(@root_dir, CONFIG_FILE_NAME)
        conf_str = File.open(file_path) { |file| file.read }
        hash = JSON.parse(conf_str)
        #puts self.config.to_s.magenta
      rescue JSON::ParserError => err
        raise ConfigurationError.new("Couldn't parse the configuration file. Please check the syntax (the commas!)")
      rescue Errno::ENOENT => err
        #raise ConfigurationError.new(err.message)
        puts "Couldn't find the configuration file. I'm using the default settings.\n(run 'justincase current_config' to review them)".colorize(:cyan)
      ensure
        # I must give something to the setter, even an empty hash.
        # The setter will merge it with the defaults anyway.
        # Also, the setter will take care of validating it.
        self.config = hash
      end








      def validate_configuration(conf_hash)
        conf_hash.symbolize_keys!
        conf_hash = validate_keys(conf_hash)
        conf_hash = validate_values(conf_hash)
      rescue Exception => ex
        # Here I just wrap whatever exeption in a JustInCase::Config::ConfigurationError
        raise ConfigurationError.new("Configuration was invalid: #{ex.message}")
      end


      def validate_keys(conf)
        valid_keys = generate_valid_keys_reference
        conf.each_key do |key|
          # unless key.is_a?(Symbol) && valid_keys.include?(key)
          unless valid_keys.include?(key)
            conf.delete(key) 
          end
        end
        return conf
      end


      def validate_values(conf)
        bool_arr = [true, false]

        # String
        conf.delete(:working_directory) unless conf[:working_directory].is_a?(String)

        # Array of Strings
        if conf[:watched_directories].is_a?(Array)
          conf[:watched_directories].delete_if { |item| !item.is_a?(String) }
        else
          conf.delete(:watched_directories)
        end

        # Booleans
        conf.delete(:recursive_monitoring) unless bool_arr.include?(conf[:recursive_monitoring])
        conf.delete(:should_include_hidden_files) unless bool_arr.include?(conf[:should_include_hidden_files])
        conf.delete(:should_whitelist_file_extensions) unless bool_arr.include?(conf[:should_whitelist_file_extensions])

        # Array of Strings
        if conf[:file_extensions_whitelist].is_a?(Array)
          conf[:file_extensions_whitelist].delete_if { |item| !item.is_a?(String) }
        else
          conf.delete(:file_extensions_whitelist)
        end

        # Boolean
        conf.delete(:should_blacklist_file_extensions) unless bool_arr.include?(conf[:should_blacklist_file_extensions])

        # Array of Strings
        if conf[:file_extensions_blacklist].is_a?(Array)
          conf[:file_extensions_blacklist].delete_if { |item| !item.is_a(String) }
        else
          conf.delete(:file_extensions_blacklist)
        end

        # Booleans
        conf.delete(:daemonize) unless bool_arr.include?(conf[:daemonize])
        conf.delete(:verbose) unless bool_arr.include?(conf[:verbose])
        
        # Precise Strings
        conf.delete(:log_format) unless ["txt", "sqlite"].include?(conf[:log_format])
        conf.delete(:file_copy_prefix) unless ["timestamp", "incremental_id", ""].include?(conf[:file_copy_prefix])
        conf.delete(:file_copy_suffix) unless ["timestamp", "incremental_id", ""].include?(conf[:file_copy_suffix])

        # String
        conf.delete(:timestamp_template) unless conf[:timestamp_template].is_a?(String)

        # Boolean or numerical string in range 000..777
        test = conf[:chomod_files]
        unless test == false # (nil == false) returns false, so 'nil' too goes inside the block
          if test.is_a?(String) && test.length == 3
            arr = ["0","1","2","3","4","5","6","7"]
            unless arr.include?(test[0]) && arr.include?(test[1]) && arr.include?(test[2])
              conf.delete(:chomod_files) 
            end
          else
            conf.delete(:chomod_files)
          end
        end

        return conf
      end


      # memoized
      def generate_valid_keys_reference
        unless @keys_reference
          defaults = get_defaults
          @keys_reference = defaults.keys
        end
        return @keys_reference
      end

      
    end # class << self

    class ConfigurationError < StandardError ; end

  end # module Config
end # module JustInCase
