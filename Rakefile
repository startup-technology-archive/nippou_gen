require './lib/nippou_gen'
require './lib/nippou_gen/slack_times'

task :generate do
  NippouGen::Generator.generate(
    today_works: [
      '朝起きて', '昼寝して', '布団で寝る'
    ]
  )
end

task :default do
  Rake::Task[:generate].invoke
  # Vim 以外は認めない
  sh "vim #{NippouGen::Generator.todays_report_file}"
end
