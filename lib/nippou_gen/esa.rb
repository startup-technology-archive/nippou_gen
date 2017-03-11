require 'esa'

module NippouGen
  class Esa
    def self.ship_it!(md_text)
      client = ::Esa::Client.new(access_token: ENV['ESA_ACCESS_TOKEN'], current_team: ENV['ESA_TEAM_NAME'])

      date = Time.zone.now

      client.create_post(
        {
          name:       "日報/#{date.year}/#{date.month}/#{date.day}/#{ENV['REPORT_NAME']}",
          body_md:    md_text,
          tags:       ['nippou_gen'],
          category:   '',
          wip:        false,
          message:    '日報 gen',
          updated_by: 'esa_bot'
        }
      )
    end

    def initialize
      @client = Esa::Client.new(access_token: ENV['ESA_ACCESS_TOKEN'], current_team: ENV['ESA_TEAM_NAME'])
    end

    def post(markdown_text)
      @client.create_post(
        {
          name:       "日報/#{Date.current.year}/#{Date.current.month}/#{Date.current.day}/nipou_genから投稿しました",
          body_md:    markdown_text,
          tags:       ['nipou_gen'],
          category:   '',
          wip:        false,
          message:    'いえーめっちゃホリデイ！',
          updated_by: 'esa_bot'
        }
      )
    end
  end
end

if __FILE__ == $0
  esa = NippouGen::EsaGen.new
  esa.post('- hello world!')
end
