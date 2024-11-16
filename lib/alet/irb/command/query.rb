require 'sobject_model/query_condition'

class Query < IRB::Command::Base
  category "Alet"
  description t('query.description')
  help_message TTY::Markdown.parse t('query.help')

  def execute(arg)
    soql =
      if /\ASELECT/.match?(arg.strip.upcase)
        arg
      else
        object = eval(arg)
        object.to_soql if object&.instance_of? SObjectModel::QueryMethods::QueryCondition
      end

    return if soql.nil?

    puts sf.data.query(soql, format: :human, target_org: ::Alet.config.org.alias)
  end
end
