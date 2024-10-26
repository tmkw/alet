require 'irb/helper_method/base'

class CurrentConnection < IRB::HelperMethod::Base
  description t('connection.description')

  def execute
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

class Apex < IRB::HelperMethod::Base
  description t('apex.description')

  def execute(apex_code = nil, verbose: false)
    result =
      if apex_code
        sf.apex.run target_org: Alet.config.conn.alias, file: StringIO.new(apex_code)
      else
        sf.apex.run target_org: Alet.config.conn.alias
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
