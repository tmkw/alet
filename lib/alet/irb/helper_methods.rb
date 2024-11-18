require 'irb/helper_method/base'
require_relative './shared_functions'

class Apex < IRB::HelperMethod::Base
  description t('apex.description')

  def execute(apex_code = nil, verbose: false)
    result =
      if apex_code
        sf.apex.run target_org: Alet.config.org.alias, file: StringIO.new(apex_code)
      else
        sf.apex.run target_org: Alet.config.org.alias
      end

    IRB.conf[:INSPECT_MODE] = false
    if verbose
      result.logs.each{|line| puts line }
    else
      pastel = Pastel.new
      result.logs.select{|line| line.include? "USER_DEBUG"}.each do |line|
        match_result = /USER_DEBUG\|.+DEBUG\|(.+)\Z/.match(line)
        puts pastel.cyan(match_result[1])
      end
    end
    IRB.conf[:INSPECT_MODE] = true
  end
end

class Conn < IRB::HelperMethod::Base
  description t('conn.description')

  def execute
    puts '【Current Org settings】'
    show_org_settings
    puts '【Rest Client settings】'
    table =
      TTY::Table.new(rows: [
        [:instance_url, Alet.rest_client.instance_url],
        [:access_token, Alet.rest_client.access_token],
        [:api_version, Alet.rest_client.api_version],
      ])
    puts table.render :unicode
  end
end

class SObjectModelSettings < IRB::HelperMethod::Base
  description t('sobjectmodel.description')

  def execute
    if SObjectModel.generated_classes.empty?
      puts t('sobjectmodel.noclass')
      return
    end

    puts t('sobjectmodel.title')
    table =
      TTY::Table.new(rows: SObjectModel.generated_classes.each_slice(4).map{|row| row.map(&:name).append('','','','')[0..3]})
    puts table.render :basic
  end
end
