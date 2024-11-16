require_relative '../shared_functions'

class Org < IRB::Command::Base
  category "Alet"
  description t('org.description')
  help_message TTY::Markdown.parse t('org.help')

  def execute(arg)
    show_org_settings
  end
end
