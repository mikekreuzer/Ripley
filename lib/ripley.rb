# require_relative '../spec/test_languages.rb'
require_relative './ripley/languages.rb'
require_relative './ripley/comparer.rb'
require_relative './ripley/scraper.rb'

scraper = Scraper.new(LANGUAGES)
current_data = scraper.scrape

comparer = Comparer.new(current_data)
comparer.compare
