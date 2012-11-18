require 'bundler'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = File.readlines('.rspec').map(&:chomp)
end

task default: :spec

desc 'asserting that the example runs'
task :assert do
  10.times do
    begin
      sh 'rm tmp/*.*'
      sh 'bin/server &'
      sh 'bin/followermaze.sh > tmp/example.out 2>&1'
      sh 'grep "ALL NOTIFICATIONS RECEIVED" tmp/example.out | wc -l | xargs test "1" ='
    ensure
      sh 'cat tmp/maze.pid | xargs kill -9'
    end
  end
end
