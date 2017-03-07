require 'date'
require 'erb'
require 'json'

data_hash = {}
earliest_date = Date.today

# given hashes of the new & old data, fill the ERB file to build a compasrison
# table

# used to have a data binding
class Namespace
  attr_reader :hash
  def initialize(hash)
    @hash = hash
  end

  def public_binding
    binding
  end
end

def build_comparison(template, hash, comparison_hash)
  hash_with_delta = hash
  hash_with_delta['data'].each_with_index do |language, index|
    next unless index < 20
    old_index = comparison_hash['data'].index do |a|
      a['name'] == language['name']
    end
    hash_with_delta['data'][index]['delta'] = comparison_str(index, old_index)
  end
  make_post_file template, hash_with_delta
end

def comparison_str(index, old_index)
  assets_str = 'https://mikekreuzer.github.io/Ripley/assets'
  common_str = "width='24' height='16' \
style='margin-top:2px;margin-bottom:-2px;'> from"
  if old_index.nil?
    'new'
  elsif index < old_index
    "<img src='#{assets_str}/up.png' alt='up' #{common_str} #{old_index + 1}"
  elsif index > old_index
    "<img src='#{assets_str}/down.png' alt='down' #{common_str} #{old_index + 1}"
  else
    '&nbsp;'
  end
end

def make_post_file(template, hash_with_delta)
  hash_date = hash_with_delta['date']
  month = hash_date[:month].to_s.rjust(2, '0')
  file_name =
    File.join 'posts', "#{month}-#{hash_date[:year]}.md"
  hash_with_delta['date'] = "#{hash_date[:year]}-#{month}-01T01:00:00+10:00"
  ns = Namespace.new(hash_with_delta)
  File.write file_name, template.result(ns.public_binding)
end

Dir.glob('../data/*.json').each do |file_name|
  month_hash = JSON.parse(File.read(file_name))
  # month's not necessarily when it was scraped, it's encoded in the file name
  file_name_array = File.basename(file_name, '.*').split('-', 2)
  month = file_name_array[0].to_i
  year = file_name_array[1].to_i
  data_hash[{ month: month, year: year }] = month_hash
  date = Date.new(year, month, 1)
  earliest_date = date < earliest_date ? date : earliest_date
end

template = ERB.new(File.read('comparison_template.erb'), 0, '-')

data_hash.each do |key, hash|
  date = Date.new(key[:year], key[:month], 1)
  comparison_date = date << 12
  comparison_date_key = { month: comparison_date.month,
                          year: comparison_date.year }
  if data_hash[comparison_date_key].nil?
    comparison_date_key = { month: earliest_date.month,
                            year: earliest_date.year }
  end
  comparison_hash = data_hash[comparison_date_key]
  hash['date'] = key
  build_comparison(template, hash, comparison_hash)
end
