source "https://rubygems.org"

gemspec

gem "rails", "~> 7.0.0"
ENV.fetch("ALCHEMY_BRANCH", "6.1-stable").tap do |branch|
  gem "alchemy_cms", github: "AlchemyCMS/alchemy_cms", branch: branch
end
gem "sassc-rails"
gem "sassc", "~> 2.4.0"
gem "webpacker"
gem "pg", "~> 1.0"
gem "puma"

group :test do
  gem "factory_bot_rails", "~> 4.8.0"
  gem "capybara"
  gem "pry-byebug"
  gem "launchy"
end

gem "github_changelog_generator", "~> 1.16"
