require 'gli'
require 'irb'
require 'imori/config'
require 'imori/utils/irb'

module Imori
  class App
    extend GLI::App

    using IRBUtils

    program_desc 'A Ruby-styled Salesforce console utility'

    desc 'Username or alias of the target org'
    flag [:o, 'target-org'], default_value: nil

    desc 'start irb session'
    command :irb do |c|
      c.action do |global_options, options, args|
        Imori.config.cli_options[:"target-org"] = global_options['target-org']
        IRB.start(__FILE__, ['-r', 'imori/irb', '--noscript', global_options['target-org']])
      end
    end

    default_command :irb
  end
end
