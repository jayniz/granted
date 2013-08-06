source 'https://rubygems.org'

gem 'rails', '~>3.2.14'

group :development, :test do
  gem 'sqlite3'
  gem 'jeweler'
  gem 'guard-rspec'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'terminal-notifier-guard'
  gem 'guard-bundler'
  gem 'simplecov'
  gem 'database_cleaner'
  gem 'mysql2'
end

platform :ruby do
  group :development, :test do
    gem 'debugger'
    gem 'activerecord-postgresql-adapter'
  end
end

platform :jruby do
  group :development, :test do
    gem 'activerecord-jdbcpostgresql-adapter'
  end
end
