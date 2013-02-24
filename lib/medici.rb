require 'medici/stock'
require 'medici/historical'

module Medici
  extend self

  def quotes(symbols)
    Stock.quotes(symbols)
  end

  def quote(symbol)
    Stock.quote(symbol)
  end

  def historical(symbol, start_date = nil, end_date = nil)
    Historical.quote(symbol, start_date, end_date)
  end
end