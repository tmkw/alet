require 'gli'
require 'irb'
require 'imori/config'
require 'imori/utils/irb'
require 'imori/generate/project'
require 'i18n'

#
# i18n settings
#
I18n.load_path += Imori.config.i18n.load_path
I18n.default_locale = :en
I18n.locale = /jp|JP|ja|ja_JP/.match?(ENV['LANG']) ? :ja : :en

def t(indicator)
  I18n.t(indicator)
end

module Imori
  class App
    extend GLI::App

    using IRBUtils

    program_desc t('cli.desc')

    desc t('cli.target_org')
    flag [:o, 'target-org'], default_value: nil, arg_name: 'org'

    desc t('cli.irb.desc')
    command :irb do |c|
      c.desc desc t('cli.target_org')
      c.flag [:o, 'target-org'], default_value: nil, arg_name: 'org'

      c.action do |global_options, options, args|
        Imori.config.cli_options[:"target-org"] = global_options['target-org'] || options['target-org']
        IRB.start(__FILE__, ['-r', 'imori/irb', '--noscript', global_options['target-org']])
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
        prj.switch [:e, 'open-editor'], negatable: false

        prj.desc t('cli.generate.project.retrieve')
        prj.switch [:r, 'retrieve'], negatable: false

        prj.action do |_, options, args|
          Imori::Project.generate(args.first, **options)
        end
      end
    end

    default_command :irb
  end
end
