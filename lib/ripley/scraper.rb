require 'concurrent'
require_relative '../../_ignore/new_credentials'
require 'fileutils'
require 'json'
require_relative 'reddit'
require 'time'

# get reddit language pages for subscriber totals, rank these, in a json file
class Scraper
  def initialize(languages)
    @languages = languages
    @session = Reddit.new(credentials: CREDENTIALS)
  end

  def add_commas(int)
    int.to_s
       .reverse
       .gsub(/(\d{3})(?=\d)/, '\\1,')
       .reverse
  end

  # scrape, wait, tally, write file & return data when done
  def scrape
    page_data = scrape_pages_concurrently(@languages)
    results = tally(page_data)
    write_json(results.value)
  end

  # calculate totals and percentages, return array of hashes including these
  def insert_percentages_and_index(array_of_hashes)
    total = array_of_hashes.map { |r| r[:subscribers] }.reduce(0, :+)
    return array_of_hashes if total.zero?

    array_of_hashes.map.with_index do |lang, index|
      lang[:percentage] = (lang[:subscribers].to_f / total * 100).round(2)
      lang[:index] = index + 1
      lang
    end
  end

  # hit the api concurrently, return array of IVars
  # subsstring chosen as a variable name pre Ruby
  def scrape_pages_concurrently(languages)
    languages.map do |language|
      Concurrent.dataflow do
        count = @session.count(lang: language[:subreddit])
        { name: language[:name],
          subsstring: add_commas(count),
          subscribers: count,
          url: "https://www.reddit.com/r/#{language[:subreddit]}/" }
      end
    end
  end

  # tally the results from the worker IVars, return results IVar
  def tally(array_of_workers)
    Concurrent.dataflow(*array_of_workers) do
      results = []
      array_of_workers.each { |work| results << work.value }
      sorted_results = results.sort_by { |hsh| hsh[:subscribers] }.reverse!
      insert_percentages_and_index(sorted_results)
    end
  end

  # write json file
  def write_json(results)
    date_now = Time.now
    result = { title: date_now.strftime('%B %Y'),
               dateScraped: date_now.iso8601(0),
               data: results }
    FileUtils.mkdir_p 'out'
    file_path = File.join 'out', date_now.strftime('%m-%Y.json')
    File.write file_path, JSON.pretty_generate(result)
    result
  end
end
