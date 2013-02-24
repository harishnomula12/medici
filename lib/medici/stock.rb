require 'net/http'
require 'xmlsimple'
require 'date'
require 'time'
require 'medici/errors'

module Medici
  class Stock
    API_BASE_URL = 'http://www.google.com/ig/api?'

    PARSERS = {
      identity: lambda { |_| _ },
      to_int:   lambda { |s| s.to_i },
      to_float: lambda { |s| s.to_f },
      to_date:  lambda { |s| s.empty? ? nil : Date.parse(s) },
      to_time:  lambda { |s| s.empty? ? nil : Time.parse(s.scan(/.{2}/).join(':')) },
      to_bool:  lambda { |s| s.match(/(true|t|yes|y|1)$/i) != nil }
    }

    QUOTE_ATTRIBUTES = [
      :symbol, :pretty_symbol, :symbol_lookup_url, :company, :exchange, :exchange_timezone,
      :exchange_utc_offset, :exchange_closing, :divisor, :currency, :last, :high, :low,
      :volume, :avg_volume, :market_cap, :open, :y_close, :change, :perc_change, :delay,
      :trade_timestamp, :trade_date_utc, :trade_time_utc, :current_date_utc, :current_time_utc,
      :symbol_url, :chart_url, :disclaimer_url, :ecn_url, :isld_last, :isld_trade_date_utc,
      :isld_trade_time_utc, :brut_last, :brut_trade_date_utc, :brut_trade_time_utc, :daylight_savings
    ]

    PARSE_MAP = {
      exchange_closing:    PARSERS[:to_int],
      divisor:             PARSERS[:to_int],
      last:                PARSERS[:to_float],
      high:                PARSERS[:to_float],
      low:                 PARSERS[:to_float],
      volume:              PARSERS[:to_int],
      avg_volume:          PARSERS[:to_int],
      market_cap:          PARSERS[:to_float],
      open:                PARSERS[:to_float],
      y_close:             PARSERS[:to_float],
      change:              PARSERS[:to_float],
      perc_change:         PARSERS[:to_float],
      delay:               PARSERS[:to_int],
      isld_last:           PARSERS[:to_float],
      trade_date_utc:      PARSERS[:to_date],
      trade_time_utc:      PARSERS[:to_time],
      current_date_utc:    PARSERS[:to_date],
      current_time_utc:    PARSERS[:to_time],
      isld_trade_date_utc: PARSERS[:to_date],
      isld_trade_time_utc: PARSERS[:to_time],
      daylight_savings:    PARSERS[:to_bool]
    }
    PARSE_MAP.default = PARSERS[:identity]

    QUOTE_ATTRIBUTES.each do |attribute|
      attr_reader attribute
    end

    def self.quotes(symbols)
      query = symbols.map { |symbol| "stock=#{symbol}" }.join('&')
      response = Net::HTTP.get_response(URI.parse(API_BASE_URL + query))

      self.parse(response.body)
    end

    def self.quote(symbol)
      self.quotes([symbol]).first
    end

    private

    def self.parse(xml_data)
      doc = XmlSimple.xml_in(xml_data)
      doc['finance'].map do |stock|
        attributes = stock.each_with_object({}) do |(attribute, value), hash|
          hash[attribute] = value.first['data'] if QUOTE_ATTRIBUTES.include? attribute.to_sym
        end
        raise StockSymbolError.new(attributes['symbol']) if attributes['exchange'] == 'UNKNOWN EXCHANGE'

        new(attributes)
      end
    end

    private_class_method :new

    def initialize(attributes)
      attributes.each do |attribute, value|
        parser = PARSE_MAP[attribute.to_sym]
        instance_variable_set("@#{attribute}", parser.call(value))
      end
    end

  end
end