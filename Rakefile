desc 'Run bundler'
task :run_bundler do
  sh 'bundler'
end

desc 'Run Ripley'
task :run_ripley do
  sh 'ruby lib/ripley.rb'
end

desc 'Move output files'
task :move_files do
  require 'fileutils'
  @changed_files = []

  file_name = ''
  loc_translation = {
    './out/*.json' => "./data/#{file_name}",
    './out/*.md' => "/Users/mike/web/ripley/source/posts/#{file_name}"
  }

  loc_translation.each do |from_string, to_string|
    files = Dir[from_string]
    files.each do |from_file_path|
      file_name = File.basename(from_file_path)
      FileUtils.mv(from_file_path, to_string)
      @changed_files << file_name if File.extname(file_name) == '.md'
    end
  end

  p 'Files moved'
end

desc 'Push Ripley JSON file'
task :push_json_file do
  # require 'date'
  # sh 'git add .'
  # sh format("git commit -m '%s'", DateTime.now.strftime('%m-%Y'))
  # sh 'git push origin master'
  p 'JSON files NOT committed & pushed'
end

desc 'Run Zine to push markdown file - relies on :move_files'
task :run_zine do
  #  current_dir = Dir.getwd
  #  Dir.chdir '/Users/mike/web/ripley/'
  #  sh format('zine notice %s', @changed_files.first)
  #  Dir.chdir current_dir
  p 'zine not done'
end

task default: %i[run_bundler run_ripley move_files push_json_file run_zine] do
  p 'Ripley ALMOST updated!'
end
