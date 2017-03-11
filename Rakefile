require './lib/nippou_gen'

task :generate do
  NippouGen::Generator.generate(
    today_works: [
      '朝起きて', '昼寝して', '布団で寝る'
    ]
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
