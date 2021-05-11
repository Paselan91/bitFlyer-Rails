module Api
  module V1
    class PastTickerController < ApplicationController
      require 'httpclient'
      require 'rounding'

      def index
        url = 'https://api.cryptowat.ch/markets/bitflyer/btcjpy/ohlc'

        logger.debug("request.query_parameters")
        logger.debug(request.query_parameters)

        client = HTTPClient.new

        if (request.query_parameters.any?)
          response = client.get(url,request.query_parameters)
        else
          response = client.get(url)
        end

        render json: JSON.parse(response.body)
      end
    end
  end
end
