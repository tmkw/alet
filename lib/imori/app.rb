require 'gli'
require 'irb'
require 'imori/utils/irb'

module Imori
  class App
    extend GLI::App

    using IRBUtils

    program_desc 'A Ruby-styled Salesforce console utility'

    default_command :irb

    desc 'start irb session'
    command :irb do |c|
      c.action do |global_options,options,args|
        IRB.start(__FILE__, ['-r', 'imori/irb'])
      end
    end
  end
end
