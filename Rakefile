require './lib/nippou_gen'
require './lib/nippou_gen/slack_times'

task :generate do
  NippouGen::Generator.generate(
    today_works: [
      '朝起きて', '昼寝して', '布団で寝る'
    ],
    slack_messages: NippouGen::SlackTimes.messages,
    github_events: NippouGen::Github.events
  )
end

task :ship do
  # esa に ship it! する
  text = File.read(NippouGen::Generator.todays_report_file)
  NippouGen::Esa.ship_it!(text)
  puts 'Ship It!'
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