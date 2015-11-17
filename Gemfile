source "https://rubygems.org"

ruby "2.2.0"

gem "rails", "4.2.2"
gem "pg"
gem "sass-rails", "~> 5.0.3"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "slim-rails"
gem "ngannotate-rails", "~> 0.15.4"
gem "sass", "~> 3.4.13"
gem "angular-ui-bootstrap-rails", "~> 0.9.0"

gem "rubocop",  "~> 0.33.0"
gem "rubocop-rspec", "~> 1.3.0"
gem "representable"

gem "sidekiq", "~> 3.4.1"
gem "sinatra", require: nil

source "https://h6LuM_B67dJ3G6yqY5wL@repo.fury.io/monterail/" do
  gem "omniauth-hussars", "0.1.1"
end

source "http://rails-assets.org" do
  gem "rails-assets-angular", "1.3.6"
  gem "rails-assets-angular-ui-router", "0.2.13"
  gem "rails-assets-lodash", "~> 3.5.0"
  gem "rails-assets-angular-animate", "~> 1.3.6"
end

gem "rails_sso", "~> 0.7.1"
gem "envied", "~> 0.8.1"
gem "puma", "~> 2.13.4"
gem "sentry-raven", "~> 0.14.0"

group :production, :staging do
  gem "rails_12factor", "~> 0.0.3"
end

group :development do
  gem "spring", "~> 1.3.3"
  gem "letter_opener_web", "~> 1.2.0"
end

group :test do
  gem "rspec-query-limit", "~> 0.1.2"
  gem "timecop", "~> 0.7.3"
end

group :development, :test do
  gem "dotenv-rails"
  gem "pry-rails", "~> 0.3.2"
  gem "better_errors"
  gem "binding_of_caller"
  gem "rspec-rails"
  gem "database_cleaner", "~> 1.4.1"
  gem "brakeman", "~> 3.1.0"
end
