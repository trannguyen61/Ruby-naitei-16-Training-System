source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.1"

gem "bcrypt", "3.1.13"
gem "bootsnap", ">= 1.4.2", require: false
gem "bootstrap-sass", "3.4.1"
gem "bootstrap5-kaminari-views", "~> 0.0.1"
gem "config"
gem "devise"
gem "figaro"
gem "jbuilder", "~> 2.7"
gem "jquery-rails"
gem "kaminari"
gem "mysql2", "~> 0.5.3"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.4"
gem "rails-i18n", "~> 6.0.0"
gem "ransack"
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "factory_bot_rails"
  gem "faker", "2.1.2"
  gem "pry-rails", platforms: [:mri, :mingw, :x64_mingw]
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
  gem "shoulda-matchers", "~> 5.0"
  gem "simplecov"
  gem "simplecov-rcov"
end

group :development do
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
