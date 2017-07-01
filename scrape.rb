require 'concurrent'
require 'date'
require 'json'
require 'mechanize'
require_relative './languages.rb'

def insert_percentages_and_index(array_of_hashes)
  total = array_of_hashes.map { |r| r[:subscribers] }.reduce(0, :+)
  return array_of_hashes if total.zero?
  results = array_of_hashes.map.with_index do |lang, index|
    lang[:percentage] = (lang[:subscribers].to_f / total * 100).round(2)
    lang[:index] = index + 1
    lang
  end
  results
end

# scrape the language pages
workers = []
LANGUAGES.each do |language, url|
  workers << Concurrent.dataflow do
    agent = Mechanize.new
    agent.request_headers = {
      'User-Agent' => 'Mac:com.mikekreuzer.ripley:0.8.0 (by /u/mikekreuzer)'
    }
    page = agent.get(url)
    count = page.at('.subscribers .number').text.strip
    { name: language, subsstring: count, subscribers: count.delete(',').to_i }
  end
end

# tally the results
tally = Concurrent.dataflow(*workers) do
  results = []
  workers.each { |work| results << work.value }
  sorted_results = results.sort_by { |hsh| hsh[:subscribers] }.reverse!
  results = insert_percentages_and_index(sorted_results)
  results
end

date = DateTime.now

result = { 'title' => date.strftime('%B %Y'),
           'dateScraped' => date,
           'data' => tally.value }

File.write date.strftime('%m-%Y.json'), JSON.pretty_generate(result)

# add in comparison to previous...
# add in moving mmd file to zine, & calling zine
