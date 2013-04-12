require 'resources/templates'
require 'json'


module JustInCase

  module Config
    DEFAULT_WORKING_DIR = File.expand_path("~/justincase")
    #DEFAULT_CONF_FILE_PATH = File.join(DEFAULT_WORKING_DIR,"justincase.conf.json")

    PID_FILE_PATH = File.join(DEFAULT_WORKING_DIR, ".justincased.pid")
    
    # these can be chaneg at runtime once the conf file is parsed
    @root_dir ||= DEFAULT_WORKING_DIR

    class << self

      attr_accessor :root_dir

      def config=(hash)
        conf_hash = validate_configuration(hash)
        defaults = get_defaults
        @config = defaults.merge(conf_hash)

        self.root_dir = @config[:working_directory]
        #self.conf_file_path = @config[:]

      rescue JustInCase::Config::ConfigurationError => err
        puts err.message.colorize(:red)
      end



      def config
        unless @config
          puts "no configuration file was found. I'm using the default configuration".colorize(:blue)
          @config = get_defaults
        end
        return @config
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


      def parse_config_file(file_path)
        if file_path
          file_path = File.expand_path(file_path)
        else
          file_path = DEFAULT_CONF_FILE_PATH
        end

        conf_str = File.open(file_path) { |file| file.read }
        hash = JSON.parse(conf_str)
        self.config = hash

        puts self.config.to_s.magenta
      rescue JSON::ParserError => err
        puts "Couldn't parse the configuration file. Please check the syntax (the commas!).".colorize(:red)
      rescue Errno::ENOENT => err
        puts err.message.colorize(:red)
      end

      private

        def validate_configuration(conf_hash)
          conf_hash.symbolize_keys!
          conf_hash = validate_keys(conf_hash)
          conf_hash = validate_values(conf_hash)
        rescue Exception => ex
          raise JustInCase::Config::ConfigurationError, "Configuration was invalid: #{ex.message}"
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

      #-----private group
    end # class << self

    class ConfigurationError < StandardError ; end

  end # module Config
end # module JustInCase
