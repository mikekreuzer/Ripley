desc 'Run bundler'
task :run_bundler do
  sh 'bundler'
end

desc 'Run Ripley'
task :run_ripley do
  Dir.chdir './lib'
  sh 'ruby ripley.rb'
  Dir.chdir '..'
end

desc 'Move output files'
task :move_files do
  require 'fileutils'
  @changed_files = []

  file_name = ''
  loc_translation = {
    './lib/out/*.json' => "./data/#{file_name}",
    './lib/out/*.md' => "/Users/mike/web/ripley/source/posts/#{file_name}"
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
  sh 'git add .'
  sh 'git commit'
  sh 'git push origin master'
  p 'JSON files committed & pushed'
end

desc 'Run Zine to push markdown file'
task :run_zine do
  # Dir.chdir '/Users/mike/web/ripley/'
  # sh format('zine notice %s', @changed_files.first)
  # to do - zine needs to handle threading better...
end

task default: %i[run_bundler run_ripley move_files push_json_file run_zine] do
  p 'Ripley updated!'
end
