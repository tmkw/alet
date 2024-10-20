class GenerateModel < IRB::Command::Base
  category "Imori"
  description "generate sObject classes"
  help_message <<~HELP
    Usage: gm sObjectType...

    sObjectType - sObject type such as Account

    Example:
    gm Account, Contact, User
  HELP

  def execute(arg)
    object_types = arg.split(' ').map{|s| s.tr(' ', '')}
    Yamori.generate(*object_types)
  end
end
