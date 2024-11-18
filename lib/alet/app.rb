require 'gli'
require 'irb'
require 'alet'
require 'alet/utils/irb'
require 'alet/generate/project'
require 'alet/version'
require 'i18n'

#
# i18n settings
#
I18n.load_path += Alet.config.i18n.load_path
I18n.default_locale = :en
I18n.locale = /jp|JP|ja|ja_JP/.match?(ENV['LANG']) ? :ja : :en

def t(indicator)
  I18n.t(indicator)
end

module Alet
  class App
    extend GLI::App

    using IRBUtils

    program_desc t('cli.desc')
    version Alet::VERSION

    desc t('cli.target_org')
    flag [:o, 'target-org'], default_value: nil, arg_name: 'org'

    desc t('cli.irb.desc')
    command :irb do |c|
      c.desc desc t('cli.target_org')

      c.example "alet", desc: t('cli.irb.example.default')
      c.example "alet -o org", desc: t('cli.irb.example.target_org')

      c.action do |global_options, options, args|
        Alet.config.cli_options[:"target-org"] = global_options['target-org'] || options['target-org']
        IRB.start(__FILE__, ['-r', 'alet/irb', '--noscript', global_options['target-org']])
      end
    end

    desc t('cli.project.desc')
    command [:project, :p] do |prj|
      prj.desc desc t('cli.project.generate.desc')
      prj.arg_name 'project_name'
      prj.command [:generate, :g] do |gen|
        gen.desc t('cli.project.generate.manifest')
        gen.switch [:m, :manifest], negatable: false

        gen.desc t('cli.project.generate.open_editor')
        gen.switch [:e, 'editor-open'], negatable: false

        gen.desc t('cli.project.generate.retrieve')
        gen.switch [:r, 'retrieve'], negatable: false

        gen.example "alet generate project MyProject", desc: t('cli.project.generate.example.default')
        gen.example "alet generate project MyProject -m", desc: t('cli.project.generate.example.manifest')
        gen.example "alet -o org generate project MyProject -m", desc: t('cli.project.generate.example.from_org')
        gen.example "alet -o org generate project MyProject -mr", desc:t('cli.project.generate.example.retrieve')

        gen.action do |global_options, _options, args|
          options = global_options.merge _options
          Alet::Project.generate(args.first, **options)
        end
      end

      prj.command [:update, :u] do |update|
        update.action do |global_options, _options, args|
          options = global_options.merge _options
          Alet::Project.update(args.first, **options)
        end
      end
    end

    default_command :irb
  end
end
