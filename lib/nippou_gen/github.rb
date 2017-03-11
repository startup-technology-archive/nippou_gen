require 'yaml'

require 'envyable'

require 'rubygems'
require 'active_support'
require 'active_support/time'
require 'octokit'
require 'pry-byebug'
require_relative '../nippou_gen'

module NippouGen
  class Github
    def initialize() 
      config = YAML.load_file('config/env.yml')
      @github = config['github']
      @output = config['output']
      @client = Octokit::Client.new(login: @github['id'], access_token: @github['access_token'])
    end


    def github_events
      events = @client.user_events(@github['id'])
      yesterday_events = []
      events.each do |event|
        next unless event.created_at.to_date == Date.yesterday
        yesterday_event = case event.type
                          when "PullRequestEvent"
                            {
                              type: "PullRequest",
                              url: event.payload.pull_request.html_url,
                              title: event.payload.pull_request.title
                            }
                          when "PullRequestReviewCommentEvent"
                            {
                              type: "PullRequestReview",
                              url: event.payload.pull_request.html_url,
                              title: event.payload.pull_request.title
                            }
                          end
        next if yesterday_event.nil?
        next if yesterday_events.include? yesterday_event
        yesterday_events << yesterday_event
      end
      yesterday_events
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts NippouGen::Github.new.github_events
end
