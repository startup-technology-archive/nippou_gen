require './lib/nippou_gen'
require './lib/nippou_gen/slack_times'

task :generate do
  slack_messages = NippouGen::SlackTimes.messages

  NippouGen::Generator.generate(
    slack_messages: slack_messages,
    slack_operating_time: NippouGen::SlackTimes.operating_time(slack_messages),
    github_events: NippouGen::Github.events,
    esa_yesterday_todo: NippouGen::Esa.yesterday_todo
  )
end

task :ship do
  # esa に ship it! する
  text = File.read(NippouGen::Generator.todays_report_file)
  url = NippouGen::Esa.ship_it!(text)
  puts "Ship It! => #{url}"
  sh "open #{url}"
end

task :default do
  Rake::Task[:generate].invoke
  # Vim 以外は認めない
  sh "vim #{NippouGen::Generator.todays_report_file}"
  Rake::Task[:ship].invoke
end

namespace :slack do
  task :show do
    NippouGen::SlackTimes.messages.each do |message|
      puts "[#{message[:time]}] #{message[:user]}: #{message[:text]}"
    end
  end
end

namespace :github do
  task :show do
    NippouGen::Github.events.each do |event|
      puts "[#{event[:type]}] #{event[:title]} #{event[:url]}"
    end
  end
end