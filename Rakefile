require './lib/nippou_gen'

task :generate do
  NippouGen::Generator.generate
end

task :default, :generate do
  # Vim 以外は認めない
  sh "vim #{NippouGen::Generator.todays_report_file}"
end