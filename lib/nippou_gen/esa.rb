require 'esa'

module NippouGen
  class Esa
    def self.ship_it!(md_text)
      client = ::Esa::Client.new(access_token: ENV['ESA_ACCESS_TOKEN'], current_team: ENV['ESA_TEAM_NAME'])

      date = Time.zone.now

      response = client.create_post(
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
      response.body['url']
    end

    def self.yesterday_todo
      client = ::Esa::Client.new(access_token: ENV['ESA_ACCESS_TOKEN'], current_team: ENV['ESA_TEAM_NAME'])
      screen_name = client.user.body['screen_name']

      yesterday_report = client.posts(q: "user:#{screen_name} category: 日報").body['posts'][0]
      body_md = yesterday_report['body_md']

      start = false
      fin = false
      todo = []

      body_md.each_line do |line|
        if start | fin
          fin = line.include?('# 所感')
          break if fin
          todo << line
          next
        end
        start = line.include?('# 明日の作業予定')
      end

      todo.join(nil).chomp!
    end

    def self.my_posts
      client = ::Esa::Client.new(access_token: ENV['ESA_ACCESS_TOKEN'], current_team: ENV['ESA_TEAM_NAME'])
      client.posts(q: "user:#{@screen_name}")
    end

    def self.today_todo
      config = YAML.load_file('config/env.yml')
      client = ::Esa::Client.new(access_token: config['ESA_ACCESS_TOKEN'], current_team: config['ESA_TEAM_NAME'])
      screen_name = client.user.body['screen_name']

      body_md = client.posts(q: "user:#{screen_name} category: 日報").body['posts'][0]['body_md']

      start = false
      fin = false
      todo = ''

      body_md.each_line do |line|
        if start | fin
          fin = line.include?('# 学んだこと')
          return todo if fin
          todo += line
          next
        end

        start = line.include?('# 明日の作業予定')
      end
    end
  end
end

if __FILE__ == $0
  puts NippouGen::Esa.today_todo
end
