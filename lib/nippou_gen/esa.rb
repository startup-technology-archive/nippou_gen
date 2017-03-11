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
      @screen_name = @client.user.body['screen_name']
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

    def my_posts
      @client.posts(q: "user:#{@screen_name}")
    end

    def yesterday_todo_txt
      nippou = @client.posts(q: "user:#{@screen_name} category: 日報").body.first
      body_md = nippou[1][1]['body_md']

      start = false
      fin = false
      todo = ''

      body_md.each_line do |line|
        if start | fin
          fin = line.include?('# 学んだこと')
          return if fin
          todo += line
        end

        start = line.include?('# 明日の作業予定')
      end
    end
  end
end

if __FILE__ == $0
  esa = NippouGen::EsaGen.new
  esa.yesterday_todo_txt
end
