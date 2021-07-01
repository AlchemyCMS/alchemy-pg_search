# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alchemy/pg_search/version'

Gem::Specification.new do |spec|
  spec.name          = "alchemy-pg_search"
  spec.version       = Alchemy::PgSearch::VERSION
  spec.authors       = ["Thomas von Deyen"]
  spec.email         = ["alchemy@magiclabs.de"]
  spec.description   = %q{PostgreSQL search for Alchemy CMS 3.0}
  spec.summary       = %q{This gem provides PostgreSQL full text search to Alchemy 3.0}
  spec.homepage      = "http://alchemy-cms.com"
  spec.license       = "BSD"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "alchemy_cms", ["> 3.2", "< 5.0"]
  spec.add_runtime_dependency "pg_search", ["~> 2.1"]
  spec.add_runtime_dependency "pg"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
end
