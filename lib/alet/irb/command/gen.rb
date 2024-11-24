require 'optparse'
require 'shellwords'
require_relative './gen/apex'
require_relative './gen/lwc'

class GenerateResource < IRB::Command::Base
  category "Alet"
  description t('gen.description')
  help_message TTY::Markdown.parse t('gen.help')

  def execute(arg)
    pastel = Pastel.new
    argv = Shellwords.shellsplit(arg)
    subcommands = {
      'apex' =>  OptionParser.new,
      'lwc' => OptionParser.new,
    }
    subcommands['apex'].on('-t', '--trigger')
    subcommands['apex'].on('-o sobjectName', '--sobject')
    subcommands['apex'].on('-e event1,event2,...', '--event')

    subcommands['lwc'].on('-l label', '--label')
    subcommands['lwc'].on('-d desc', '--description')
    subcommands['lwc'].on('-e', '--exposed')
    subcommands['lwc'].on('-t target1,target2,...', '--target')
    subcommands['lwc'].on('-o object1,object2,...', '--object')

    global_parser = OptionParser.new
    global_parser.order!(argv)

    if argv.empty?
      puts pastel.red(t('gen.error.no_subcommand'))
      return
    end

    unless subcommands.keys.include?(argv.first)
      puts pastel.red(%|#{t('gen.error.invalid_subcommand')}: #{argv.first}|)
      return
    end

    params = {}
    subcommand = argv.shift
    subcommands[subcommand].parse!(argv, into: params)
    
    #puts subcommand # for debug
    #puts argv       # for debug
    #puts params     # for debug

    case subcommand
    when 'apex'
      gen_apex(argv, params)
    when 'lwc'
      gen_lwc(argv, params)
    end
  rescue => e
    puts pastel.red(e.message)
  end
end
