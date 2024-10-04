require 'httparty'

class LatestStockPrice
  include HTTParty
  base_uri 'https://latest-stock-price.p.rapidapi.com'

  def initialize
    @headers = {
      "X-RapidAPI-Key" => ENV['RAPIDAPI_KEY'],
      "X-RapidAPI-Host" => ENV['RAPIDAPI_HOST']
    }
  end

  # noted : on v1 api latest-stock-price just ready for 'price_all' endpoint, the 'price' and 'prices' not exist
  def price_all
    response = self.class.get("/any", headers: @headers)
    if response.success?
      JSON.parse(response.body)
    else
      { error: response.message, code: response.code }
    end
  end

  def price
    { message: 'get the price by something like ID. CMIW', code: 200 }
  end

  def prices
    { message: 'get the price by something with return data more than one. CMIW', code: 200 }
  end
end
