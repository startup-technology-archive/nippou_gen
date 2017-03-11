module NippouGen
  class Generator
    attr_accessor :file

    def self.generate
      template = File.read("./templates/#{ENV['REPORT_TEMPLATE']}")
      erb = ERB.new(template)
      dir = todays_report_dir
      Dir.mkdir(dir) unless Dir.exist?(dir)

      if File.exist?(todays_report_file)
        print "today's report exist! will you overwrite? [Y|n]: "
        response = STDIN.gets.chomp
        case response
        when /^[yY]/
        when /^[nN]/
          return
        else
          return
        end
      end

      File.write(todays_report_file, erb.result)
    end

    def self.todays_report_dir
      today = Time.zone.now
      "./reports/#{today.year}"
    end

    def self.todays_report_file
      today = Time.zone.now
      dir = todays_report_dir
      "#{dir}/#{today.year}-#{sprintf('%02d', today.month)}-#{sprintf('%02d', today.day)}.md"
    end
  end
end