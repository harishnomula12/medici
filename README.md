# Medici

Medici is a simple library for obtaining [real-time](http://www.google.com/googlefinance/disclaimer/#realtime) stock quotes and historical data from the (undocumented) [Google Finance API](http://developers.google.com/finance).

## Installation

Medici is packaged as a Gem. Therefore it can be installed manually using RubyGems:

    $ gem install medici

or you can add the line

``` ruby
gem 'medici'
```

to your application's Gemfile and then let Bundler install it by executing `bundle`.

## Usage

Quotes and historical data are represented by `Medici::Stock` and `Medici::Historical` objects respectively. Both classes are immutable and only admit object instantiation through static factory methods, `quote` and `quotes`.

### Stock quote

``` ruby
require 'medici'

google = Medici.quote('GOOG')
tech = Medici.quotes(['GOOG', 'AAPL', 'MSFT', 'FB'])

puts google.last
puts tech.max_by(&:market_cap).company
```

### Historical data

``` ruby
year_to_date = Medici.historical('GOOG', '2013-01-01')
january = Medici.historical('GOOG', '2013-01-01', '2013-01-31')

year_to_date.each do |h|
  puts "#{h.date} \t #{h.close}"
end

january_change = january.last.close - january.first.close
```

## License

Medici is released under the [MIT License](http://www.opensource.org/licenses/MIT).