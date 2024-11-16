class GenerateModel < IRB::Command::Base
  category "Alet"
  description t('gen.description')
  help_message TTY::Markdown.parse t('gen.help')

  def execute(arg)
    pastel = Pastel.new
    object_types = arg.split(' ').map{|s| s.tr(' ', '')}
    SObjectModel.generate(*object_types)
  rescue SObjectModel::Rest::RequestError => e
    puts pastel.red(e.message)
  rescue SObjectModel::Rest::RecordNotFoundError => e
    puts pastel.red(t('desc.error.notfound'))
  end
end
