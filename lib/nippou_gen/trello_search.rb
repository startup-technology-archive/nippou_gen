require 'yaml'
require 'trello'
require 'envyable'
require 'pry'
require 'active_support'
require 'active_support/core_ext'

Envyable.load('config/env.yml')
Time.zone = ENV['TIME_ZONE'] || 'UTC'

Trello.configure do |config|
  config.consumer_key = ENV['TRELLO_KEY']
  config.consumer_secret = ENV['TRELLO_SECRET']
  config.oauth_token = ENV['TRELLO_OAUTH_TOKEN']
end

# TODO : カードの整理ですごいことになりそう

module  NippouGen
  class TrelloSearch
    attr_accessor :board
    # TODO : ?
    def self.create_config
      Trello.open_public_key_url
      puts 'ブラウザに表示されるキーを入力してenterを押してください'
      puts 'key:'
      key = gets.gsub(/\n/, '').gsub(/\s/, '')
      puts 'ブラウザに表示される秘密を入力してenterを押してください'
      puts 'secret:'
      secret = gets.gsub(/\n/, '').gsub(/\s/, '')
      # NOTE : Board Name 30 日で切れる?
      Trello.open_authorization_url name: 'BoardName',key: key, expiration: '30days'
      puts 'ブラウザに表示されるページでAPIの利用を許可してください'
      puts '応答ページに表示されるtokenを入力してenterを押してください'
      puts 'tokenOKEN:'
      token = gets.gsub(/\n/, '').gsub(/\s/, '')

      config = {
        consumer_key: key,
        consumer_secret: secret,
        oauth_token: token
      }
      return config
    end

    def self.show_boards
      Trello::Board.all.map { |board| [board.attributes[:id], board.attributes[:name]] }
    end

    def self.today_action_cards
      ENV['TRELLO_BOARD_IDS'].split(',').flat_map do |board_id|
        TrelloSearch.new(board_id).today_action_my_cards
      end
    end

    def initialize(board_id)
      @board ||= Trello::Board.find(board_id)
    end

    def me
      @me ||= Trello::Member.find(:me)
    end

    def today_actions
      @today_actions ||= board.actions.select {|a| a.attributes[:date] > Time.zone.now.beginning_of_day}
    end

    def today_action_card_ids
      @today_action_card_ids  ||= today_actions.map { |action| action.attributes.dig(:data, 'card', 'id') }.compact.uniq
    end

    def lists
      @lists ||= board.lists
    end

    def today_action_my_cards
      @today_action_my_cards ||= today_action_card_ids.map do |card_id|
        card = Trello::Card.find(card_id)
        if card.attributes[:member_ids].include?(me.attributes[:id])
          {
            url: "https://trello.com/c/#{card.attributes[:id]}",
            name: card.attributes[:name],
            list_name: lists.find { |list| card.attributes[:list_id] == list.attributes[:id] }.attributes[:name],
          }
        end
      end
      .compact
    end
  end
end


if __FILE__ == $0
  NippouGen::TrelloSearch.show_boards.each do |id, name|
    puts "#{id} : #{name}"
  end
  puts NippouGen::TrelloSearch.today_action_cards
end
