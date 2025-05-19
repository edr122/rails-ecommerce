source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.3"

gem "rails", "~> 7.0.8"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'kaminari', '~> 1.2.2'
gem "sidekiq"
gem 'sidekiq-scheduler', '~> 5.0'
gem "redis", "~> 4.0"
gem "paper_trail", "~> 12.3"
gem "jwt"
gem "bcrypt", "~> 3.1.7"
gem "image_processing", "~> 1.2"
gem "active_storage_validations"
gem "concurrent-ruby", "< 1.3.5"

group :development, :test do
  gem "rspec-rails", "~> 6.1.2"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "faker", "~> 3.2"
  gem 'rswag', '~> 2.12'
end
