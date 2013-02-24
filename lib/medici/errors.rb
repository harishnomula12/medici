module Medici
  class StockSymbolError < RuntimeError
    attr_reader :symbol

    def initialize(symbol = nil, message = nil)
      super(message)
      @symbol = symbol
    end
  end

  class HistoricalDataError < RuntimeError
  end
end