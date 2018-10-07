# require_relative '../spec/test_languages.rb'
require_relative './ripley/languages.rb'
require_relative './ripley/comparer.rb'
require_relative './ripley/scraper.rb'

# beginning_time = Time.now

scraper = Scraper.new(LANGUAGES)
current_data = scraper.scrape

# end_time_scrape = Time.now

comparer = Comparer.new(current_data)
comparer.compare

# end_time_compare = Time.now
# puts "Time to scrape: #{(end_time_scrape - beginning_time) * 1_000} ms"
# puts "Time to compare: #{(end_time_compare - end_time_scrape) * 1_000} ms"
