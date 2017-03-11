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
  puts "Ship It! => #{url}"
  sh "open #{url}"
end

task :default do
  file = NippouGen::Generator.today_report_file
  dir = NippouGen::Generator.today_report_dir

  Dir.mkdir(dir) unless Dir.exist?(dir)

  if File.exist?(file)
    print "Today's report exist! Will you overwrite? [Y|n]: "
    response = STDIN.gets.chomp
    case response
      when /^[yY]/
        File.delete(file)
        sh "bin/nippou generate | vim -c ':f #{file}' -"
      else
        sh "vim #{file}"
        return
    end
  else
    sh "bin/nippou generate | vim -c ':f #{file}' -"
  end

  if File.exist?(file)
    Rake::Task[:ship].invoke
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
