class StocksController < ApplicationController
	before_action :require_login

  def price_all
    prices = LatestStockPrice.new.price_all
    render json: prices
  end
end