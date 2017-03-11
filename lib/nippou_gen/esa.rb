require 'envyable'
require 'active_support'
require 'active_support/core_ext'
require 'esa'
require 'pry'
require 'esa'
require 'pry-byebug'

module NippouGen
  Envyable.load('config/env.yml')

  class EsaGen
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
