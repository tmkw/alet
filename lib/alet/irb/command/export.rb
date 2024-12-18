class Export < IRB::Command::Base
  category "Alet"
  description t('export.description')
  help_message TTY::Markdown.parse t('export.help')

  def execute(arg)
    soql =
      if /\ASELECT/.match?(arg.strip.upcase)
        arg
      else
        object = eval(arg)
        object.to_soql if object&.instance_of? SObjectModel::QueryMethods::QueryCondition
      end

    return if soql.nil?

    csv = sf.data.query(soql, format: :csv, target_org: ::Alet.config.org.alias)

    filename = "#{Time.now.strftime('%Y%m%d%H%M%S')}_export.csv"
    File.open(filename, 'w'){|f| f.write(csv) }

    puts filename
  end
end
