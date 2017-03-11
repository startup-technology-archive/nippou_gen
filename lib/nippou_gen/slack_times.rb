require 'slack'
require 'active_support'
require 'active_support/core_ext'
require './config/slack.rb'

module NippouGen
  class SlackTimes
    def initialize
      @client = Slack::Client.new
    end

    def channels
      @channels ||= @client.channels_list["channels"]
    end

    def times_channel
      @times_channel ||= channels.find { |channel| channel["name"] == ENV['SLACK_TIMES_NAME'] }
    end

    # https://api.slack.com/methods/channels.history
    def times_messages
      @client.channels_history(channel: "#{times_channel['id']}")["messages"]
    end

    def today_message
      times_messages.select { |message| message['ts'].to_i.between?(begin_ts, end_ts) }
    end

    def show_messages
      today_message.each do |message|
        user_name = users[message["user"]]
        text = message["text"].inspect
        puts "  - #{user_name}: #{text} :#{message['ts']}"
      end
    end

    private

    def owner_id
      @owner_id ||= users.find { |_, name| name == ENV['SLACK_USER_NAME'] }.first
    end

    def users
      @users ||= Hash[@client.users_list["members"].map{|m| [m["id"], m["name"]]}]
    end

    def begin_ts
      Time.now.beginning_of_day.to_i
    end

    def end_ts
      Time.now.end_of_day.to_i
    end
  end
end

if __FILE__ == $0
  slack_times = NippouGen::SlackTimes.new
  slack_times.show_messages
end
