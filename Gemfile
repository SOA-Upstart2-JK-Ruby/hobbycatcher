# frozen_string_literal: true

source 'https://rubygems.org'

# Comfiguration and Utilities
gem 'figaro', '~> 1.2'

# Web Application
gem 'puma', '~> 5.5'
gem 'roda', '~> 3.49'
gem 'slim', '~> 4.1'

# Validation
gem 'dry-struct', '~> 1.4'
gem 'dry-types', '~> 1.5'

# Networking
gem 'http', '~> 5.0'

# Database
gem 'sequel', '~> 1.4'

group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

# Testing
group :test do
  gem 'minitest', '~> 5.0'
  gem 'minitest-rg', '~> 5.0'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6.0'
  gem 'webmock', '~> 3.0'
end

group :development do
  gem 'rerun', '~> 0'
end

# Utility Tools
gem 'rake'

# Debugging
gem 'pry'

# Code Quality
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end
