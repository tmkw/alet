class GenerateModel < IRB::Command::Base
  category "Imori"
  description t('gen.description')
  help_message TTY::Markdown.parse t('gen.help')

  def execute(arg)
    object_types = arg.split(' ').map{|s| s.tr(' ', '')}
    Yamori.generate(*object_types)
  end
end
