require './lib/nippou_gen'
require './lib/nippou_gen/slack_times'

task :generate do
  slack_times = NippouGen::SlackTimes.new
  ap slack_times
  NippouGen::Generator.generate(
    today_works: [
      '朝起きて', '昼寝して', '布団で寝る'
    ],
    slack_times_messages: slack_times.today_messages,
    slack_users: slack_times.users
  )
end

task :ship do
  # esa に ship it! する
  puts 'Ship It!'
end

task :default do
  Rake::Task[:generate].invoke
  # Vim 以外は認めない
  sh "vim #{NippouGen::Generator.todays_report_file}"
  Rake::Task[:ship].invoke
end
