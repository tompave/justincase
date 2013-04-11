require 'justincase/meta'
require 'justincase/config'

module JustInCase
  module Templates

    CONFIG_FILE = <<-ENDOFFILE
/*  justincase configuration file.
    Author: Tommaso Pavese (wonderingmachine.com), 2013, MIT License

    These are the default settings that are used if no configuration file is provided.
    All fields are optional: if you omit any key, the default value will be used.
    If some keys are duplicated, only the last occurence will take effect.
    The syntax is plain JSON.

    When it starts, justincase will look for (and try to load) the configuration file in:
    '#{JustInCase::Config::DEFAULT_CONF_FILE_PATH}'.
    If it doesn't find it there, it will create that directory tree and generate a new
    configuration file with all the defaults (the one you are reading right now).
    You can start 
 */
 
{
  // Where justincase creates its directory tree and
  // stores backups and logs
  "working_directory" : "#{JustInCase::Config::DEFAULT_WORKING_DIR}",

  // What directories should be watched.
  // Make sure the user running justincase has read permissions on them
  "watched_directories" : ["~", "~/desktop"],

  // Whether is should monitor directories recursively
  "recursive_monitoring" : true,

  // EXPERIMENTAL - disabled - it won't be parsed
  // A regexp to filter files with
  // "filter_files_with_regexp" : "/aregexp/i",



  // Prevents hidden files to be backed up.
  // If you do include them, they will still be subject to
  // whitelisting and blacklisting logics
  "should_include_hidden_files" : false,



  // In case you want to limit the backups to some file types.
  "should_whitelist_file_extensions" : false,

  // Only works if "should_whitelist_file_extensions:true" is being used.
  // Example: ["txt", "log", "none!"]
  // "none!" indicates a file without extension.
  // Enabling the whitelist and at the same time leaving this
  // array empty will result in the exclusion of all file types.
  "file_extensions_whitelist" : [],

  // In case you want to exclude some file types.
  // Takes precedence over file whitelisting.
  "should_blacklist_file_extensions" : false,

  // Only works if "should_blacklist_file_extensions:true" is being used.
  // Example: ["avi", "mkv", "mp4", "none!"]
  // "none!" indicates a file without extension
  "file_extensions_blacklist" : [],



  // Whether  justintime will run detached from the console.
  // Set to false if you want more control.
  "daemonize" : true,

  // only works if "daemonize:false" is being used
  "verbose" : true,


  // log file system events
  "log_format" : "txt",
  // "log_format" : "sqlite", //EXPERIMENTAL


  // If you want actual logs
  // Uses the default Ruby Logger:
  // http://ruby-doc.org/stdlib-2.0/libdoc/logger/rdoc/Logger.html
  // http://ruby-doc.org/stdlib-1.8.7/libdoc/logger/rdoc/Logger.html
  "debug_logging" : false,

  // A string to prepend to file names.
  // In theory you *could* set this to an empty string, but doing so would
  // have your OS to take care of it in a way you can't control.
  "file_copy_prefix" : "timestamp",
  // "file_copy_prefix" : "incremental_id",

  // A string to append to file names.
  "file_copy_suffix" : "", //none
  // "file_copy_suffix" : "timestamp",
  // "file_copy_suffix" : "incremental_id",

  // Only takes effect if "timestamp" is being used.
  // Reference: http://ruby-doc.org/core-2.0/Time.html#method-i-strftime
  // Default: 20130410-18:49:35+459-file_name.txt
  // Curious fact: The ruby method call "Time.now.strftime(template_str)" will work
  // with any random template string. Thus if you use, let's say, "potato", then
  // "potato" will appear in your back up file names.
  // I should probably fix this, but I think it's funny.
  "timestamp_template" : "%Y%m%d-%H:%M:$S+%L",
  //"timestamp_template" : "a_monkey_was_here_at_%H:%M_on_%d-%m_and_liked_what_she_saw",

  // chmods backup files once copied.
  // Please don't use the 4 digit format (the one with the setUID, setGID, StickyBit),
  // as it's not supported yet.
  "chomod_files" : false
  //"chomod_files" : "400"
}
    ENDOFFILE

    # def self.config_file_string
    # end

    WELCOME_MESSAGE = <<-ENDOFFILE

  Welcome to justincase #{JustInCase::Meta::VERSION}

justincase is a command line tool to monitor system folders and back up changes.
It runs as a daemon and listens for file system changes in the target folders.
When something changes, justincase copies the new versions of the files in its
working directory.
At the same time, it logs such changes (additions, modifications, deletions) in
either a text file or a SQLite3 DB.

Without any configuration, justincase chooses '~/justincase' as its default
working directory.
Here it will create its directory tree, save the backed up files and the logs.
Of course, you can change this by providing a configuration file.

The command 'justincase generate_config' will create in the current directory a
template configuration file (JSON), containing all the available configuration
options and the default settings (full of explanatory comments).
(you can also use the --output-file flag to specify a location)

You can modify this file and

    ENDOFFILE
  end
end



