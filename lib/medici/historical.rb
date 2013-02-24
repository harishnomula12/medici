require 'date'

module Medici
  class Historical
    API_BASE_URL = 'http://www.google.com/finance/historical?'

    attr_reader :date, :open, :high, :low, :close, :volume

    def self.quote(symbol, start_date = nil, end_date = nil)
      request = self.build_request(symbol, start_date, end_date)
      response = Net::HTTP.get_response(URI.parse(request))
      raise HistoricalDataError if response.code != '200'

      self.parse(response.body)
    end

    private

    def self.build_request(symbol, start_date, end_date)
      params = {
        q: symbol,
        startdate: start_date,
        enddate: end_date,
        output: 'csv'
      }

      API_BASE_URL + params.each_with_object([]) do |(p, v), acc|
        acc << "#{p}=#{v}" if not v.nil?
      end.join('&')
    end

    def self.parse(response)
      rows = response.split("\n")
      rows.shift
      rows.map do |row|
        new(row.split(','))
      end
    end

    private_class_method :new

    def initialize(attributes)
      @date = Date.parse(attributes[0])
      @open = attributes[1].to_f
      @high = attributes[2].to_f
      @low = attributes[3].to_f
      @close = attributes[4].to_f
      @volume = attributes[5].to_i
    end

  end
end