require 'concurrent'
require 'date'
require 'fileutils'
require 'json'
require 'mechanize'

# scrape reddit language pages for subscriber totals, rank these, in a json file
class Scraper
  def initialize(languages)
    @languages = languages
    @agent_header =
      { 'User-Agent' => 'Mac:com.mikekreuzer.ripley:0.8.2 (by /u/mikekreuzer)' }
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

  # scrape the language pages concurrently, return array of IVars
  # subsstring chosen as a variable name pre Ruby
  def scrape_pages_concurrently(languages)
    languages.map do |language, url|
      Concurrent.dataflow do
        agent = Mechanize.new
        agent.request_headers = @agent_header
        page = agent.get(url)
        count = page.at('.subscribers .number').text.strip
        count_as_i = count.delete(',').to_i
        { name: language, subsstring: count, subscribers: count_as_i, url: url }
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
    date = DateTime.now
    result = { title: date.strftime('%B %Y'),
               dateScraped: date,
               data: results }
    FileUtils.mkdir_p 'out'
    file_path = File.join 'out', date.strftime('%m-%Y.json')
    File.write file_path, JSON.pretty_generate(result)
    result
  end
end
