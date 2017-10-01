require 'date'
require 'erb'
require 'json'
require 'fileutils'

# compare this month's data to a year ago
class Comparer
  attr_reader :hash

  def initialize(current_data)
    @assets_str = 'https://mikekreuzer.github.io/Ripley/assets'
    (@current_data = current_data).freeze
    @data_rel_path = ['..', 'data']
    @earliest_date = DateTime.new(2016, 4, 1)
    @template = ERB.new(File.read('ripley/comparison_template.erb'), 0, '-')
  end

  def compare
    comparison_data = read_comparison_file(comparison_file_name)
    @hash = rankings_compared_to(comparison_data)
    write_post_file
  end

  def comparison_file_name
    comparison_date = @current_data[:dateScraped] << 12
    file = if comparison_date < @earliest_date
             @comparison_date = 'April 2016'
             '04-2016.json'
           else
             @comparison_date = comparison_date.strftime('%B %Y')
             comparison_date.strftime('%m-%Y.json')
           end
    File.join @data_rel_path, file
  end

  def comparison_str(index, old_index)
    common = "width='24' height='16' style='margin-top:2px;margin-bottom:-2px;'> from"
    if old_index.nil?
      'new'
    elsif index < old_index
      "<img src='#{@assets_str}/up.png' alt='up' #{common} #{old_index + 1}"
    elsif index > old_index
      "<img src='#{@assets_str}/down.png' alt='down' #{common} #{old_index + 1}"
    else
      '&nbsp;'
    end
  end

  def post_file_name
    date = @current_data[:dateScraped]
    File.join 'out', date.strftime('%m-%Y.md')
  end

  def rankings_compared_to(comparison_data)
    hash = @current_data.dup # don't copy its frozen status
    # comparison_data['dateScraped'] could be outside the calendar month
    hash[:comparison_date] = @comparison_date
    hash[:data].each_with_index do |language, index|
      next unless index < 20
      old_index = comparison_data['data'].index do |a|
        a['name'] == language[:name]
      end
      hash[:data][index][:delta] = comparison_str(index, old_index)
    end
    hash
  end

  def read_comparison_file(comparison_file_name)
    JSON.parse(File.read(comparison_file_name))
  end

  def write_post_file
    FileUtils.mkdir_p 'out'
    date = @hash[:dateScraped]
    @hash[:date] = date.strftime('%Y-%m-01T01:00:00+10:00')
    File.write post_file_name, @template.result(binding)
  end
end
