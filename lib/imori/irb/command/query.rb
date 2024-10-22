require 'yamori/query_condition'

class Query < IRB::Command::Base
  category "Imori"
  description t('query.description')
  help_message TTY::Markdown.parse t('query.help')

  def execute(arg)
    soql =
      if /\ASELECT/.match?(arg.strip.upcase)
        arg
      else
        object = eval(arg)
        object.to_soql if object&.instance_of? Yamori::QueryMethods::QueryCondition
      end

    return if soql.nil?

    puts sf.data.query(soql, format: :human, target_org: ::Imori.config.connection.alias)
  end
end
