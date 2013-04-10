require 'justincase/meta'

module JustInCase
  module Templates

    CONFIG_FILE = <<-ENDOFFILE
/*  justincase configuration file.
    These are the default settings that are used if no configuration file is provided.
    All fields are optional: if you omit some justincase will use the default values.
    If some keys are duplicated, only the last occurence will take effect.
    The syntax is plain JSON.
 */
{
  // where justincase creates its directory tree and
  // stores backups and logs
  "working_directory" : "~/justincase",

  // what directories should be watched.
  // make sure the user running justincase has read permissions on them
  "watched_directories" : ["~", "~/desktop"],


  // in case you want to limit the backups to some file types.
  "should_whitelist_file_extensions" : false,

  // only works if "should_whitelist_file_extensions:true" is being used
  "file_extensions_whitelist" : [],


  // in case you want to exclude some file types.
  // takes precedence over file whitelisting
  "should_blacklist_file_extensions" : false,

  // only works if "should_blacklist_file_extensions:true" is being used
  "exclude_these_file_extensions" : [],


  // whether  justintime will run detached from the console
  // set to false if you want to see what's happening.
  "daemonize" : false,

  // only works if "daemonize:false" is being used
  "verbose" : true,

  "log_format" : "txt",
  // "log_format" : "sqlite",

  "file_copy_prefix" : "timestamp",
  // "file_copy_prefix" : "incremental_id",

  "file_copy_suffix" : "", //none
  // "file_copy_suffix" : "timestamp",
  // "file_copy_suffix" : "incremental_id",

  // only takes effect if "timestamp" is being used.
  // reference: http://ruby-doc.org/core-2.0/Time.html#method-i-strftime
  // default: 20130410-18:49:35+459-file_name.txt
  "timestamp_format" : "%Y%m%d-%H:%M:$S+%L"
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

    ENDOFFILE
  end
end