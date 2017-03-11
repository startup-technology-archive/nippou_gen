module NippouGen
  class Generator
    attr_accessor :file

    def self.generate!
      template = File.read("./templates/#{ENV['REPORT_TEMPLATE']}")
      erb = ERB.new(template)
      today = Time.zone.now
      dir = "./reports/#{today.year}"
      Dir.mkdir(dir) unless Dir.exist?(dir)
      File.write("#{dir}/#{today.year}-#{sprintf('%02d', today.month)}-#{sprintf('%02d', today.day)}.md", erb.result)
    end
  end
end