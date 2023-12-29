source 'https://rubygems.org'

ruby '2.6.6'
gem 'rails', '5.2.6'
# gem 'rails', '4.2.11'

# for Heroku deployment
group :development, :test do
  #gem 'sqlite3', '1.3.11'
  gem 'sqlite3', '~> 1.3.6'
  gem 'timecop'

  gem 'byebug'
  gem 'database_cleaner', '1.4.1'
  gem 'capybara', '2.6'
  gem 'launchy'
  gem 'rspec-rails', '3.7.2'
  gem 'rack', '~> 2.2.3'
  gem 'rails-controller-testing'

end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'simplecov', :require => false
  gem 'factory_bot_rails'
  gem 'faker'
  # gem 'rack', '>= 2.0.0'


end
group :production do
  gem 'pg', '~> 0.15'
  gem 'rails_12factor'
  gem 'bundler', '~> 1.17'


end

# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails', '~> 5.0.3'
gem 'uglifier', '>= 2.7.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem "chartkick"
gem "groupdate"
gem 'responders', '3.1.0'
gem 'devise'
