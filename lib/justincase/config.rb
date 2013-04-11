require 'resources/templates'
require 'json'

module JustInCase

  module Config

    class << self

      def config=(hash)
        conf_hash = validate_configuration(hash)
        defaults = get_defaults
        @config = defaults.merge(conf_hash)
      rescue JustInCase::ConfigurationError => err
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
      def get_defaults
        conf_str = JustInCase::Templates::CONFIG_FILE
        conf_hash = JSON.parse(conf_str)
        return conf_hash.symbolize_keys!
      end

      private

        def validate_configuration(conf_hash)
          conf_hash.symbolize_keys!
          conf_hash = validate_keys(conf_hash)
          conf_hash = validate_values(conf_hash)
        rescue Exception => ex
          raise JustInCase::ConfigurationError, "Configuration was invalid: #{ex.message}"
        end


        def validate_keys(conf)
          conf.each_key do |key|
            unless key.is_a?(Symbol) && JustInCase::Config::VALID_KEYS.include?(key)
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


        
    end


    VALID_KEYS = [:working_directory,
                  :watched_directories,
                  :recursive_monitoring,
                  :should_include_hidden_files,
                  :should_whitelist_file_extensions,
                  :file_extensions_whitelist,
                  :should_blacklist_file_extensions,
                  :file_extensions_blacklist,
                  :daemonize,
                  :verbose,
                  :log_format,
                  :file_copy_prefix,
                  :file_copy_suffix,
                  :timestamp_template,
                  :chomod_files]

  end


  


  class ConfigurationError < StandardError
  end

  
end
