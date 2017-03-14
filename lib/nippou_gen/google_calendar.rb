require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'google/apis/calendar_v3'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'envyable'
require 'pry'

Envyable.load('config/env.yml')

module NippouGen
  class GoogleCalendar
    attr_accessor :status
    attr_reader :service, :email

    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    INVALID_CREDENTIALS_ERROR = 401

    def initialize(email)
      @email = email
      @service = Google::Apis::CalendarV3::CalendarService.new
      @service.client_options.application_name = 'NippouGen'
      @service.authorization = authentication
    end

    def authentication
      scope = 'https://www.googleapis.com/auth/calendar.readonly'
      client_id = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])
      token_store = Google::Auth::Stores::FileTokenStore.new(:file => 'tmp/google_tokens.yaml')
      authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

      credentials = authorizer.get_credentials(email)
      if credentials.nil?
        url = authorizer.get_authorization_url(base_url: self.class::OOB_URI)
        puts "Open #{url} in your browser and enter the resulting code:"
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(user_id: email, code: code, base_url: OOB_URI)
      end
      credentials
    end

    def events(calendar_id = 'primary')
      time_min = Time.now.tomorrow.beginning_of_day.iso8601
      time_max = Time.now.tomorrow.end_of_day.iso8601

      results = service.list_events(calendar_id,
                                    order_by: 'startTime',
                                    time_max: time_max,
                                    time_min: time_min,
                                    single_events: true)
      results.items.map do |item|
        start = item.start
        date = start.date_time || start.date.to_date
        { summary: item.summary, date: date }
      end
    end
  end
end

if __FILE__ == $0
  NippouGen::GoogleCalendar.new(ENV['GOOGLE_USER_ID']).events.each do |event|
    puts event
  end
end
