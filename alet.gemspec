require_relative 'lib/alet/version'

Gem::Specification.new do |s|
  s.name        = "alet"
  s.version     = Alet::VERSION
  s.summary     = "A Ruby-styled Salesforce console utility"
  s.description = "Salesforce console utility for Ruby users"
  s.authors     = ["Takanobu Maekawa"]
  s.files       = Dir['lib/**/*.*']
  s.homepage    = "https://github.com/tmkw/alet"
  s.license     = 'BSD-2-Clause'
  s.required_ruby_version = '>= 3.3.4'
  s.requirements = 'Salesforce CLI ( >= 2.56.7): https://developer.salesforce.com/tools/salesforcecli'
  s.metadata = {
    "homepage_uri" => "https://github.com/tmkw/alet"
  }
  s.bindir = 'bin'
  s.executables = 'alet'
  s.add_dependency 'gli', '~>2.22.0'
  s.add_dependency 'sf_cli', '~>1.2.4'
  s.add_dependency 'sobjectmodel', '~>0.1.3'
  s.add_dependency 'tty-markdown', '~>0.7.2'
  s.add_dependency 'tty-table', '~>0.12.0'
  s.add_dependency 'pastel', '~>0.8.0'
  s.add_dependency 'i18n', '~>1.14.6'
end
