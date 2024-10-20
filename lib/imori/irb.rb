require 'sf_cli'
require 'yamori'
require 'imori/irb/config'
require 'irb/command/base'

# commands in irb
require_relative 'irb/command/use'
require_relative 'irb/command/generate_model'

IRB::Command._register_with_aliases :use, UseOrg, [:use, IRB::Command::NO_OVERRIDE]
IRB::Command._register_with_aliases :generate_model, GenerateModel, [:gm, IRB::Command::NO_OVERRIDE]
