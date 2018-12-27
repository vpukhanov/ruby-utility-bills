require 'rspec/core/rake_task'

desc 'Run unit tests with RSpec'
RSpec::Core::RakeTask.new(:unit) do |t|
  t.fail_on_error = false
  t.rspec_opts = "--tag ~type:feature"
end
task :default => :unit

desc 'Run system tests with RSpec and Capybara'
RSpec::Core::RakeTask.new(:system) do |t|
  t.fail_on_error = false
  t.rspec_opts = "--tag type:feature"
end
