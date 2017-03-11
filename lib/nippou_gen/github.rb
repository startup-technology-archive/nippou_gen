require 'octokit'

module NippouGen
  class Github
    def self.events
      client = Octokit::Client.new(login: ENV['GITHUB_ID'], access_token: ENV['GITHUB_ACCESS_TOKEN'])

      events = client.user_events(ENV['GITHUB_ID'])
      today_events = []
      events.each do |event|
        next unless event.created_at.to_date == Time.zone.today
        today_event = case event.type
                      when 'PullRequestEvent'
                        {
                          type: 'PullRequest',
                          url: event.payload.pull_request.html_url,
                          title: event.payload.pull_request.title
                        }
                      when 'PullRequestReviewCommentEvent'
                        {
                          type: 'PullRequestReview',
                          url: event.payload.pull_request.html_url,
                          title: event.payload.pull_request.title
                        }
                      end
        next if today_event.nil?
        next if today_events.include? today_event
        today_events << today_event
      end
      today_events
    end

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
