require './lib/nippou_gen'

task :generate do
  NippouGen::Generator.generate
end

task :default, :generate do
  sh "vim #{NippouGen::Generator.todays_report_file}"
end