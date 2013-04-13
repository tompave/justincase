#justincase
v 0.0.0 - not ready yet!
---

###What?
__justincase__ is a daemon for Mac OS X and GNU/Linux systems, plus the command line tool to control it.  
It's a directory monitor and automatic backup tool, highly customizable.  
It's all written in pure Ruby. File system events are handled by [Listen](https://github.com/guard/listen), while the command line interface is powered by [Thor](https://github.com/wycats/thor).

___

###How?

The __CLI__ component is a one-shot utility to control the __daemon__ (start and stop, duh) and to generate a self documenting JSON configuration file.  
At the first run it builds the working directory tree for the __daemon__ at a location chosen by the user (can be reinitialized).
  
The heavy lifting is carried out by the __daemon__, that listens for file system events in the target directories and can be controlled through UNIX signals.  
As it records changes in the monitored directories, the daemon copies any new or modified file in a backup folder, and logs (in TXT or SQLite) all recorded modification.  


---

###Why?

Because I was fed up _a certain Mac app_ hanging when connecting to SMTP servers, failing to send emails and – just to make things funnier – deleting any trace of the failed messages from both the draft folder and the temp dir in ~/library.  

All jokes aside, __justincase__ id aimed at continuosly save the state the of a hirarchy of directories _just in case_ something might go wrong.  
If you:

* are doing critical work,
* don't trust some piece of software,
* have already experienced crashed and data loss,
* need a quick and lightweight backup solution,

__justincase__ might come in handy.


___

###The configuration file
Can be found in `justincase/lib/justincase/resources/templates.rb`

```JSON
/*  justincase configuration file.

    These are the default settings that are used if no configuration file is provided.
    All fields are optional: if you omit any key, the default value will be used.
    If some keys are duplicated, only the last occurence will take effect.

    The syntax is plain JSON.

    About the Initialization Process:
    When it starts, justincase will look for the '~/.justincaserc' file, which contains
    the path to its working directory. If that file doesn't exist, of if it cointains
    invalid data, justincase will ask to be initialized with the command 'justincase setup'.
    (This is the default behaviour for the first run)

    If the file '~/.justincaserc' exists and is valid, justincase will use it to determine
    the location of its working directory, where it will try to load the configuration
    file (the one you are reading right now).

    If the configuration file is missing, it will fallback to use the default settings,
    that are the ones presented in the unmodified fresh version of the current file.
 */
 
{
  // What directories should be watched.
  // Make sure the user running justincase has read permissions on them
  "watched_directories" : ["~/desktop"],

  // Whether is should monitor directories recursively
  "recursive_monitoring" : true,


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
  // "log_format" : "sqlite",


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
```

