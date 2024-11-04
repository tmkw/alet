require 'optparse'

class Org < IRB::Command::Base
  category "Alet"
  description t('org.description')
  help_message TTY::Markdown.parse t('org.help')

  def execute(arg)
    info = Alet.config.connection
    table =
      TTY::Table.new(rows: [
        [:id, info.id],
        [:alias, info.alias],
        [:user_name, info.user_name],
        [:status, info.status],
        [:instance_url, info.instance_url],
        [:api_version, info.api_version],
        [:access_token, info.access_token]
      ])
    puts table.render :unicode
  end
end
