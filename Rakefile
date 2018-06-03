require './lib/nippou_gen'
require './lib/nippou_gen/slack_times'

task :generate do
  slack_messages = NippouGen::SlackTimes.messages

  result = NippouGen::Generator.generate(
    slack_messages: slack_messages,
    slack_operating_time: NippouGen::SlackTimes.operating_time(slack_messages),
    github_events: NippouGen::Github.events,
    esa_yesterday_todo: NippouGen::Esa.yesterday_todo
  )

  puts result
end

task :ship do
  # esa に ship it! する
  text = File.read(NippouGen::Generator.today_report_file)
  url = NippouGen::Esa.ship_it!(text)
  puts "Ship It!"
  sh "open #{url}" if url
end

task :default do
  file = NippouGen::Generator.today_report_file
  dir = NippouGen::Generator.today_report_dir

  FileUtils::mkdir_p(dir) unless Dir.exist?(dir)

  post = NippouGen::Esa.today_report

  if post.nil?
    sh "bin/nippou generate | vim -c ':f #{file}' -"
  else
    sh "bin/nippou esa:today_report | vim -c ':f #{file}' -"
  end

  if File.exist?(file)
    Rake::Task[:ship].invoke
    File.delete(file)
  end
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

namespace :esa do
  task :today_report do
    post = NippouGen::Esa.today_report
    if post.nil?
      puts 'Not found.'
    else
      puts post['body_md']
    end
  end
end

namespace :google_calendar do
  task :show do
    cal = NippouGen::GoogleCalendar.new(ENV['GOOGLE_USER_ID'])
    cal.events.each do |event|
      puts event
    end
  end
end

