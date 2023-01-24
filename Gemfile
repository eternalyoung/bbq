source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'bootsnap', require: false
gem 'carrierwave'
gem 'cssbundling-rails', '~> 1.1'
gem 'devise'
gem 'devise-i18n'
gem 'importmap-rails'
gem 'puma', '~> 5.0'
gem 'pundit', '~> 2.3'
gem 'rails', '~> 7.0.4'
gem 'rails-i18n'
gem 'resque', '~> 2.4'
gem 'rmagick'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  gem 'letter_opener'
  gem 'sqlite3', '~> 1.4'

  gem 'factory_bot_rails', '~> 6.2'
  gem 'rspec-rails', '~> 6.0'
end

group :development do
  gem 'capistrano', '~> 3.8'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-passenger', '~> 0.2'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'capistrano-resque', '~> 0.2.3', require: false

  gem 'web-console'
end

group :production do
  gem 'pg'
end

