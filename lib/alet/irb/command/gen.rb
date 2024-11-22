require 'optparse'

class GenerateResource < IRB::Command::Base
  category "Alet"
  description t('gen.description')
  help_message TTY::Markdown.parse t('gen.help')

  def execute(arg)
    pastel = Pastel.new
    argv = arg.split(' ')
    subcommands = {
      'apex' =>  OptionParser.new,
      'lwc' => OptionParser.new,
    }
    subcommands['apex'].on('-t', '--trigger')
    subcommands['apex'].on('-o sobjectName', '--sobject')
    subcommands['apex'].on('-e events...', '--event')

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
    
    #puts subcommand
    #puts argv
    #puts params

    case subcommand
    when 'apex'
      gen_apex(argv, params)
    when 'lwc'
    end
  rescue => e
    puts pastel.red(e.message)
  end

  def gen_apex(argv, params)
    return if argv.empty?

    name = argv.first

    base_dir = Dir.pwd
    dx_dir = 'force-app/main/default'
    dir = if FileTest.exist?(%|#{base_dir}/#{dx_dir}|)
            %|#{base_dir}/#{dx_dir}/#{params[:trigger] ? 'triggers' : 'classes'}|
          else
            base_dir
          end

    if params[:trigger]
      event_map = {
        'bi' => 'before insert',
        'bu' => 'before update',
        'bd' => 'before delete',
        'ai' => 'after insert',
        'au' => 'after update',
        'ad' => 'after delete',
        'aud' => 'after undelete',
      }
      events = params[:event]&.split(',')&.map{|e| event_map[e]}&.compact
      sf.apex.generate_trigger name, output_dir: dir, sobject: params[:sobject], event: events
    else
      sf.apex.generate_class name, output_dir: dir
      sf.apex.generate_class %|#{name}Test|, output_dir: dir, template: :ApexUnitTest
    end
  end
end
