require 'sf_cli'
require 'sobject_model'
require 'alet'
require 'irb/command/base'
require 'tty-markdown'
require 'tty-table'
require 'pastel'
require 'i18n'

#
# set locale
#
I18n.locale = IRB.conf[:LC_MESSAGES].lang&.to_sym || :en

#
# set prompt
#
IRB.conf[:PROMPT][:ALET] = {
  :PROMPT_I => "alet(#{Alet.config.cli_options[:"target-org"]}):%03n:%i> ",
  :PROMPT_S => "alet(#{Alet.config.cli_options[:"target-org"]}):%03n:%i%l ",
  :PROMPT_C => "alet(#{Alet.config.cli_options[:"target-org"]}):%03n:%i* ",
  :RETURN => "=> %s\n"
}
IRB.conf[:PROMPT_MODE] = :ALET

#
# load commands
#
require_relative 'irb/command/generate_model'
require_relative 'irb/command/query'
require_relative 'irb/command/sh'
require_relative 'irb/command/export'
require_relative 'irb/command/org'
require_relative 'irb/command/grep'
require_relative 'irb/command/describe'
require_relative 'irb/command/conn'
require_relative 'irb/command/gen'

IRB::Command.register :grep, Grep
IRB::Command.register :desc, Describe
IRB::Command.register :query, Query
IRB::Command.register :export, Export
IRB::Command.register :sh, Shell
IRB::Command.register :org, Org
IRB::Command.register :conn, Conn
IRB::Command.register :model, GenerateModel
IRB::Command.register :gen, GenerateResource

#
# load helper methods
#
require_relative 'irb/helper_methods'
IRB::HelperMethod.register(:apex, Apex)

#
# set connection
#
require_relative 'irb/shared_functions'
begin
  reset_connection
rescue => e
  pastel = Pastel.new
  puts pastel.red(e.message.sub("See more help with --help", ''))
  exit(1)
end
