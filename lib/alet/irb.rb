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

IRB::Command.register :org, Org
IRB::Command.register :grep, Grep
IRB::Command.register :desc, Describe
IRB::Command.register :query, Query
IRB::Command.register :export, Export
IRB::Command.register :sh, Shell
IRB::Command.register :gen, GenerateModel

#
# load helper methods
#
require_relative 'irb/helper_methods'
IRB::HelperMethod.register(:apex, Apex)
IRB::HelperMethod.register(:conn, Conn)


#
# set connection
#
org = sf.org.display target_org: Alet.config.cli_options[:"target-org"]
Alet.config.org = org

sf.org.login_web target_org: org.alias, instance_url: org.instance_url unless org.connected?

rest_client = SObjectModel::Rest::Client.new(
                instance_url: org.instance_url,
                access_token: org.access_token,
                api_version: org.api_version)

adapter = SObjectModel::Adapter::Rest.new(rest_client)

SObjectModel.connection = adapter

Alet.rest_client = rest_client
