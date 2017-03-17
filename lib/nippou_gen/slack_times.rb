require 'slack'

Slack.configure do |config|
  config.token = ENV['SLACK_TOKEN']
end

module NippouGen
  class SlackTimes
    def self.messages
      slack_times = NippouGen::SlackTimes.new
      slack_users = slack_times.users
      res = slack_times.today_messages.map do |message|
        {
          time: Time.at(message['ts'].to_i).strftime('%m/%d %H:%M:%S'),
          user: slack_users[message['user']],
          text: message['text']
        }
      end
      res.reverse
    end

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
      @times_messages ||= @client.channels_history(channel: "#{times_channel['id']}")["messages"]
    end

    def today_messages
      @today_message ||= @client.channels_history(channel: "#{times_channel['id']}", oldest: begin_ts, latest: end_ts)["messages"]
    end

    def show_messages
      today_messages.each do |message|
        user_name = users[message["user"]]
        text = message["text"].inspect
        puts "  - #{user_name}: #{text} :#{message['ts']}"
      end
    end

    def users
      @users ||= Hash[@client.users_list["members"].map{|m| [m["id"], m["name"]]}]
    end

    def self.operating_time(messages)
      start_time =  if start_message = messages.find { |message| message[:text] && message[:text].match(/\A開始/) }
                      if m = start_message[:text].match(/\A開始 (?<hour>\d\d):(?<minute>\d\d)/)
                        Time.now.change(hour: m[:hour], minute: m[:minute]).strftime('%m/%d %H:%M:%S')
                      else
                        start_message[:time]
                      end
                    else
                      message = messages.find { |m| !m[:user].nil? }
                      message.fetch(:time, Time.now.strftime('%m/%d %H:%M:%S'))
                    end

      end_time = if end_message = messages.find { |message| message[:text] && message[:text].match(/\A終了/) }
                   end_message[:time]
                 else
                   Time.now.strftime('%m/%d %H:%M:%S')
                 end
      {
        start: start_time,
        end: end_time,
        operating_time: (Time.parse("1/1") + (Time.parse(end_time) - Time.parse(start_time)) ).strftime("%H時間%M分")
      }
    end

    private

    def owner_id
      @owner_id ||= users.find { |_, name| name == ENV['SLACK_USER_NAME'] }.first
    end

    def begin_ts
      Time.zone.now.beginning_of_day.to_i
    end

    def end_ts
      Time.zone.now.end_of_day.to_i
    end
  end
end

if __FILE__ == $0
  slack_times = NippouGen::SlackTimes.new
  slack_times.show_messages
end
