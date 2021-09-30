require 'uri'
require 'net/http'
require 'json'
require 'rspec/autorun'

API_KEY = "58d6a6eebbdada7f85829034d4ec2abdb9e371a9"

class NomicsTest

  def get_currencies(tickers="BTC", attributes="", fiat="USD")
    uri = URI('https://api.nomics.com/v1/currencies/ticker')
    params = { key: API_KEY, ids: tickers,  attributes: attributes, convert: fiat }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    data = JSON.parse(res.body)
    return data
  end

  def convert_currency(from="BTC", to="ETH")
    from_price = get_currencies(from)[0]["price"].to_f
    to_price = get_currencies(to)[0]["price"].to_f
    calculated = (from_price/to_price).round(2)
    puts "1#{from}=#{calculated}#{to}"
    return calculated
  end
end


RSpec.describe NomicsTest do
  it "should retrieve a list of cryptocurrencies given set of tickers" do
    obj = NomicsTest.new 
    result = obj.get_currencies("BTC,ETH")
    expect(result).not_to be_empty
  end

  it "should retrieve a (list) specific crypto currency and specific values based on the ticker" do
    obj = NomicsTest.new 
    result = obj.get_currencies("BTC,ETH", "circulating_supply, max_supply, name, symbol, price")
    #Not working at api side
    expect(result).not_to be_empty
  end

  it "should retrieve a specific cryptocurrency to specific fiat" do
    obj = NomicsTest.new 
    result = obj.get_currencies("BTC", "", "ZAR")
    expect(result).not_to be_empty
  end

  it "should convert the price of one cryptocurrency from another" do
    obj = NomicsTest.new 
    result = obj.convert_currency("BTC", "ETH")
    expect(result).to be_within(12).of(20) #Almost 14.64
  end
end