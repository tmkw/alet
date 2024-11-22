require 'optparse'

class GenerateModel < IRB::Command::Base
  category "Alet"
  description t('model.description')
  help_message TTY::Markdown.parse t('model.help')

  def execute(arg)
    pastel = Pastel.new
    argv = arg.split(' ')
    opt = OptionParser.new
    opt.parse!(argv)

    if argv.count.zero? || argv.first == 'list'
      if SObjectModel.generated_classes.empty?
        puts t('model.list.noclass')
        return
      end

      puts t('model.list.title')
      table =
        TTY::Table.new(rows: SObjectModel.generated_classes.each_slice(4).map{|row| row.map(&:name).append('','','','')[0..3]})
      puts table.render :basic
    elsif argv.first == 'load'
      SObjectModel.generate(*argv[1..-1])
    end
  rescue SObjectModel::Rest::RequestError => e
    puts pastel.red(e.message)
  rescue SObjectModel::Rest::RecordNotFoundError => e
    puts pastel.red(t('desc.error.notfound'))
  end
end
