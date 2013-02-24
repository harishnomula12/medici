Gem::Specification.new do |s|
  s.name        = 'medici'
  s.version     = '0.1.1'
  s.date        = '2013-02-24'
  s.summary     = 'Simple real-time stock quotes from the Google Finance API.',
  s.description = 'Medici is a library for obtaining stock quotes and historical stock data using the undocumented Google Finance API.',
  s.authors     = ['Timothy Spratt']
  s.email       = 'tim@onlysix.co.uk'
  s.homepage    = 'http://github.com/timspratt/medici'
  s.license     = 'MIT'

  s.files       = [
    'lib/medici.rb',
    'lib/medici/errors.rb',
    'lib/medici/historical.rb',
    'lib/medici/stock.rb'
  ]

  s.add_dependency 'xml-simple'
end