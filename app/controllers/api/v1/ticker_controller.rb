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

        duration =  params[:duration]
        if(duration.nil?)
          duration = 'minutes'
        end

        if is_success
          candle = BtcCandle.where(duration: duration)
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
          price = (ticker["best_bid_size"] + ticker["best_ask_size"]) / 2
          ticker_time = Time.parse(ticker["timestamp"])
          truncated_ticker_time = truncate_by_ticker_time(duration,ticker_time)
          candle = BtcCandle.where(duration: duration, time: truncated_ticker_time).first
          # すでにレコードがある場合、updateする
          if(candle.present?) then
            if candle["High"] <= price then
              candle["High"] = price
            elsif candle["Low"] >= price then
              candle["Low"] = price
            end
            candle["Volume"] += ticker["volume"]
            candle["Close"] = price
            is_created_or_updated = candle.update( High: candle["High"], Low: candle["Low"], Close: candle["Close"], Volume: candle["Volume"])
          # レコードが無い場合、新規作成
          else
            params = get_ticker_params(ticker,duration,price,ticker_time)
            candle = BtcCandle.new(params)
            is_created_or_updated = candle.save
          end
          is_success ||= is_created_or_updated
        end
        return is_success
      end


      def get_ticker_params(ticker,duration,price,ticker_time)
        truncated_ticker_time = truncate_by_ticker_time(duration,ticker_time)
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


      def truncate_by_ticker_time(duration,ticker_time)
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
