require "bundler/gem_tasks"

desc "Running specs"
task :spec do |t|
  exec "cd spec/ && bundle exec rspec elibri_onix_mocks_spec.rb"
end

task :default => ["spec"]