require 'envyable'
require 'slack'
Envyable.load('./config/env.yml')
Slack.configure do |config|
  config.token = ENV['SLACK_TOKEN']
end

