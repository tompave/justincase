# encoding: utf-8

# pushes the lib directory at the beginning of the ruby env $LOAD_PATH
lib_path = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
require 'justincase/meta'

Gem::Specification.new do |s|
  s.name        = 'justincase'
  s.summary     = %Q{summary - todo}
  s.description = %Q{description - todo}

  s.version     = JustInCase::Meta::VERSION
  s.date        = JustInCase::Meta.date_string

  s.author      = 'Tommaso Pavese'
  s.homepage    = 'https://github.com/tompave/justincase'
  s.license     = 'MIT'

  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.7'

  s.add_runtime_dependency     'thor',          '~> 0.18.1'
  s.add_runtime_dependency     'listen',        '~> 0.7.3'
  #s.add_runtime_dependency     'sqlite3',       '~> 1.3.7'
  #s.add_runtime_dependency     'daemons',       '~> 1.1.9'
  s.add_runtime_dependency     'colorize',      '~> 0.5.8'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake',          '~> 10.0'

  #s.files        = Dir.glob('{bin,images,lib}/**/*') + %w[CHANGELOG.md LICENSE man/guard.1 man/guard.1.html README.md]
  s.executables  << 'justincase'
  s.require_path = 'lib'
end
