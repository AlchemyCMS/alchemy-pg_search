lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "alchemy/pg_search/version"

Gem::Specification.new do |spec|
  spec.name = "alchemy-pg_search"
  spec.version = Alchemy::PgSearch::VERSION
  spec.authors = ["Thomas von Deyen"]
  spec.email = ["thomas@vondeyen.com"]
  spec.description = "PostgreSQL search for Alchemy CMS"
  spec.summary = "This gem provides PostgreSQL full text search to Alchemy"
  spec.homepage = "https://alchemy-cms.com"
  spec.license = "BSD-3-Clause"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "alchemy_cms", [">= 6.0", "< 7"]
  spec.add_runtime_dependency "pg_search", ["~> 2.1"]
  spec.add_runtime_dependency "pg"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
end
