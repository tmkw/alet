require_relative '../shared_functions'

class Conn < IRB::Command::Base
  category "Alet"
  description t('conn.description')
  help_message TTY::Markdown.parse t('conn.help')

  def execute(arg)
    argv = arg.split(' ')
    if argv.empty?
      puts '【Current Org settings】'
      show_org_settings
      puts '【Rest Client settings】'
      show_rest_client_settings
      return
    end

    case argv.first
    when 'reset'
      reset_connection
    else
      puts t('conn.invalid_subcommand')+ ": #{argv.first}"
    end
  end
end
