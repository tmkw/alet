require 'sf_cli'
require 'yamori'
require 'alet/config'
require 'irb/command/base'
require 'tty-markdown'
require 'tty-table'
require 'pastel'
require 'i18n'

I18n.locale = IRB.conf[:LC_MESSAGES].lang&.to_sym || :en

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

Yamori.connect(
  :rest,
  instance_url: conn.instance_url,
  access_token: conn.access_token,
  api_version:  conn.api_version
)
