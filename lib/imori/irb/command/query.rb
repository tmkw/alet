class Query < IRB::Command::Base
  category "Imori"
  description t('query.description')
  help_message TTY::Markdown.parse t('query.help')

  def execute(soql)
    puts sf.data.query(soql, format: :human, target_org: ::Imori.config.connection.alias)
  end
end
