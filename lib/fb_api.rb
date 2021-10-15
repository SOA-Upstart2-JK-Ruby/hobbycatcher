require 'http'
require_relative 'pageInfo'
require_relative 'reviews'
require_relative 'posts'

module InfoHunter
  # Library for Facebook Web API
  class FacebookApi
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(token)
      @fb_token = token
    end

    def pageInfo(page, fields, config)
      fanpage_url = fb_api_path('tahrd108', fields, config)
      fanpage_data = call_fb_url(fanpage_url).parse
      PageInfo.new(fanpage_data, self)
    end

    def reviews(page, fields, config)
      fanpage_url = fb_api_path('tahrd108', fields, config)
      fanpage_data = call_fb_url(fanpage_url).parse
      Reviews.new(fanpage_data, self)
    end

    def posts(page, fields, config)
      fanpage_url = fb_api_path('tahrd108', fields, config)
      fanpage_data = call_fb_url(fanpage_url).parse
      Posts.new(fanpage_data, self)
    end
    
    private

    def fb_api_path(page, fields, config)
      "https://graph.facebook.com/v12.0/#{page}?fields=#{fields}&access_token=#{config['FACEBOOK_TOKEN']}"
    end

    def call_fb_url(url)
      HTTP.headers('Accept' => 'application/json',
                   'Authorization' => "token #{@fb_token}").get(url)
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end