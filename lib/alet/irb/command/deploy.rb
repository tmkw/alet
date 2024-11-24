require 'optparse'
require 'shellwords'

class Deploy < IRB::Command::Base
  category "Alet"
  description t('deploy.description')
  help_message TTY::Markdown.parse t('deploy.help')

  def execute(arg)
    pastel = Pastel.new
    argv = Shellwords.shellsplit(arg)

    opts = OptionParser.new
    opts.on('-m manifest-file', '--manifest')
    opts.on('-d', '--dryrun')
    opts.on('-l test-level', '--test-level')
    opts.on('-t test1,test2,...', '--tests')

    if argv.empty?
      puts pastel.red(t('deploy.error.no_arguments'))
      return
    end

    params = {}
    opts.parse!(argv, into: params)
    component_type = argv.shift

    options = {
      dry_run: params[:dryrun] || false,
      tests: params[:tests]&.split(','),
      test_level: params[:"test-level"]
    }

    puts component_type # for debug
    puts argv           # for debug
    puts params         # for debug
    puts options        # for debug

    if component_type == 'file'
      deploy_file(argv, params[:manifest], options)
    else
      deploy_component(component_type, argv, options)
    end
  rescue => e
    puts pastel.red(e.message)
  end

  def deploy_file(argv, manifest, options)
    if manifest
      sf.project.deploy_start manifest: manifest, target_org: Alet.config.org.alias, raw_output: true, **options
    else
      sf.project.deploy_start source_dir: argv.first, target_org: Alet.config.org.alias, raw_output: true, **options
    end
  end

  def deploy_component(component_type, argv, options)
    return if argv.empty?

    type_alias = {
      'apex' => 'ApexClass',
      'trigger' => 'ApexTrigger',
      'lwc' => 'LightningComponentBundle',
    }

    metadata_names =
      argv.map do |name|
        metadata_type = type_alias[component_type] || component_type
        %|"#{metadata_type}:#{name}"|
      end

    sf.project.deploy_start metadata: metadata_names, target_org: Alet.config.org.alias, raw_output: true, **options
  end
end
