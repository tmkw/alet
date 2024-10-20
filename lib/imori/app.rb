require 'gli'
require 'irb'
require 'imori/irb/util'

module Imori
  class App
    extend GLI::App

    using IRBUtils

    program_desc 'A Ruby-styled Salesforce console utility'

    default_command :irb

    command :irb do |c|
      c.action do |global_options,options,args|
        IRB.start(__FILE__, ['-r', 'imori/irb'])
      end
    end
  end
end
