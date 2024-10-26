class Shell < IRB::Command::Base
  category "Alet"
  description t('sh.description')
  help_message TTY::Markdown.parse t('sh.help')

  def execute(arg)
    ::IRB.conf[:INSPECT_MODE] = false
    return puts `#{arg}` if arg.size > 0

    s = $stdin.gets
    while s
      puts `#{s}`
      s = $stdin.gets
    end
  ensure
    ::IRB.conf[:INSPECT_MODE] = true
  end
end
