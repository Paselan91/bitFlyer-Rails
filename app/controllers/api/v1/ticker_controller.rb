module Api
  module V1
    class TickerController < ApplicationController

      require 'httpclient'
      require 'rounding'

      def index
        url = ENV['BASE_URL'] + "ticker"
        client = HTTPClient.new
        response = client.get(url)
        render json: JSON.parse(response.body)
      end

      def show
        # TODO: 引数から取得できるように修正する
        duration = 'minutes'
        candle = BtcCandle.where(duration: duration)
        render json: candle
      end

      def get_with_create
        url = ENV['BASE_URL'] + "ticker"
        client = HTTPClient.new
        response = client.get(url)
        ticker = JSON.load(response.body)
        is_success = save_candles(ticker)

        if is_success
          candle = BtcCandle.where(duration: params[:duration])
          render json: candle
        else
          # TODO: 適切なエラーメッセージを返すようにする
          render  json: "failed"
        end

      end


      private

      def save_candles(ticker)
        # TODO: LaravelのConfigのようにして、BE全体で使えるようにたい
        durations = ['seconds', 'minutes', 'hour']
        is_success = false

        # 1s,1m,1hごとDBへ保存
        durations.each do |duration|
          candle = BtcCandle.new(get_ticker_params(duration,ticker))
          is_created = candle.save
          is_success ||= is_created
        end

        return is_success
      end

      def get_ticker_params(duration,ticker)

        price = (ticker["best_bid_size"] + ticker["best_ask_size"]) / 2
        ticker_time = Time.parse(ticker["timestamp"])

        case duration
          when "seconds" then
            truncated_ticker_time = truncate_to_seconds(ticker_time)
          when "minutes" then
            truncated_ticker_time = truncate_to_minutes(ticker_time)
          when "hour" then
            truncated_ticker_time = truncate_to_hour(ticker_time)
          else
            # TODO: エラー実装
        end

        params = {
          :ProductCode => ticker["product_code"],
          :Duration => duration,
          :Time => truncated_ticker_time,
          :Open => price,
          :Close => price,
          :High => price,
          :Low => price,
          :Volume => ticker["volume"],
        }
      end

      def truncate_to_hour(time)
        time.floor_to(1.hour)
      end

      def truncate_to_minutes(time)
        time.floor_to(1.minutes)
      end

      def truncate_to_seconds(time)
        time.floor_to(1.seconds)
      end
    end
  end
end
