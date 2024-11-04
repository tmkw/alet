require 'sf_cli'
require 'sobject_model'
require 'alet/config'
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

IRB::Command.register :gen, GenerateModel
IRB::Command.register :query, Query
IRB::Command.register :export, Export
IRB::Command.register :sh, Shell

#
# load helper methods
#
require_relative 'irb/helper_methods'

IRB::HelperMethod.register(:conn, CurrentConnection)
IRB::HelperMethod.register(:apex, Apex)


#
# set connection
#
conn = sf.org.display target_org: Alet.config.cli_options[:"target-org"]

Alet.config.connection = conn

sf.org.login_web target_org: conn.alias, instance_url: conn.instance_url unless conn.connected?

SObjectModel.connect(
  :rest,
  instance_url: conn.instance_url,
  access_token: conn.access_token,
  api_version:  conn.api_version
)
