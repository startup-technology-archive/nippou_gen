module NippouGen

end

require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'envyable'

Envyable.load('config/env.yml')
Time.zone = ENV['TIME_ZONE'] || 'UTC'

require './lib/nippou_gen/generator'
