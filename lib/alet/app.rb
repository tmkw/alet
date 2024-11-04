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
      c.flag [:o, 'target-org'], default_value: nil, arg_name: 'org'

      c.example "alet", desc: t('cli.irb.example.default')
      c.example "alet -o org", desc: t('cli.irb.example.target_org')

      c.action do |global_options, options, args|
        Alet.config.cli_options[:"target-org"] = global_options['target-org'] || options['target-org']
        IRB.start(__FILE__, ['-r', 'alet/irb', '--noscript', global_options['target-org']])
      end
    end

    desc t('cli.generate.desc')
    command [:generate, :g] do |c|
      c.desc desc t('cli.generate.project.desc')
      c.arg_name 'project_name'
      c.command :project do |prj|
        prj.desc t('cli.generate.project.target_org')
        prj.flag [:o, 'target-org'], default_value: nil, arg_name: 'org'

        prj.desc t('cli.generate.project.manifest')
        prj.switch [:m, :manifest], negatable: false

        prj.desc t('cli.generate.project.open_editor')
        prj.switch [:e, 'editor-open'], negatable: false

        prj.desc t('cli.generate.project.retrieve')
        prj.switch [:r, 'retrieve'], negatable: false

        prj.example "alet generate project MyProject", desc: t('cli.generate.project.example.default')
        prj.example "alet generate project MyProject -m", desc: t('cli.generate.project.example.manifest')
        prj.example "alet generate project MyProject -m -o org", desc: t('cli.generate.project.example.from_org')
        prj.example "alet generate project MyProject -mr -o org", desc:t('cli.generate.project.example.retrieve')

        prj.action do |_, options, args|
          Alet::Project.generate(args.first, **options)
        end
      end
    end

    default_command :irb
  end
end
