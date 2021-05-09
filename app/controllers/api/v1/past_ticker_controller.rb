module Api
  module V1
    class PastTickerController < ApplicationController
      require 'httpclient'
      require 'rounding'

      def index
        # url = ENV['PAST_BASE_URL']
        # periods =
        # after =
        # before =
        logger.debug("before get")

        url = 'https://api.cryptowat.ch/markets/bitflyer/btcjpy/ohlc?periods=86400&after=1483196400'
        logger.debug("url " + url)
        client = HTTPClient.new
        response = client.get(url)
        logger.debug(response.body)
        render json: JSON.parse(response.body)
      end
    end
  end
end
