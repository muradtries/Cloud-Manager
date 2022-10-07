source "https://rubygems.org"

gem "fastlane"
gem "slather"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Gymfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
