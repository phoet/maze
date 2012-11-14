require 'bundler'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = File.readlines('.rspec').map(&:chomp)
end

task default: :spec
