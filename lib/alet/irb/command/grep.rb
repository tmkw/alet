require 'optparse'

class Grep < IRB::Command::Base
  category "Alet"
  description t('grep.description')
  help_message TTY::Markdown.parse t('grep.help')

  def execute(arg)
    argv = arg.split(' ')
    opt = OptionParser.new
    opt.on '-l', '--label'
    opt.on '-n', '--api-name'

    params = {}
    opt.parse(argv, into: params)

    regxp = %r{#{argv.first}}

    sobjects = Alet.describe_global['sobjects'].select do |so|
      if params.has_key?(:label)
        regxp.match(so['label'])
      elsif params.has_key?(:"api-name")
        regxp.match?(so['name'])
      else
        regxp.match?(so['name']) || regxp.match(so['label'])
      end
    end

    table = TTY::Table.new(
              ["name", "label"],
              sobjects.map{ |so| [so['name'], so['label']] }
              )
    puts table.render :unicode
  end
end
