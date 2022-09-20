#!/usr/bin/env rake
begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

begin
  require "rdoc/task"
rescue LoadError
  require "rdoc/rdoc"
  require "rake/rdoctask"
  RDoc::Task = Rake::RDocTask
end

desc "Generate documentation for Alchemy CMS."
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "Alchemy PgSearch"
  rdoc.options << "--line-numbers" << "--inline-source"
  rdoc.rdoc_files.include("README.md")
  rdoc.rdoc_files.include("lib/**/*.rb")
  rdoc.rdoc_files.include("app/**/*.rb")
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load "rails/tasks/engine.rake"

require "rspec/core"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => ["alchemy:spec:prepare", :spec]

Bundler::GemHelper.install_tasks

namespace :alchemy do
  namespace :spec do
    desc "Prepares database for testing"
    task :prepare do
      system "cd spec/dummy; RAILS_ENV=test bin/rake db:setup db:seed; cd -"
    end
  end
end

require "github_changelog_generator/task"
require "alchemy/pg_search/version"

namespace :changelog do
  GitHubChangelogGenerator::RakeTask.new :update do |config|
    config.user = "AlchemyCMS"
    config.project = "alchemy-pg_search"
    # config.since_tag = "v1.2.0"
    config.future_release = "v#{Alchemy::PgSearch::VERSION}"
  end
end
