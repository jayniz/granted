source 'https://rubygems.org'

gem 'rails', '~>3.2.14'

group :development, :test do
  gem 'jeweler'
  gem 'guard-rspec'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'terminal-notifier-guard'
  gem 'guard-bundler'
  gem 'simplecov'
  gem 'database_cleaner'
  gem 'coveralls', require: false
end

platform :ruby do
  group :development, :test do
    gem 'mysql2'
    gem 'debugger'
    gem 'activerecord-postgresql-adapter'
  end
end

platform :jruby do
  group :development, :test do
    gem 'activerecord-jdbc-adapter'
    gem 'activerecord-jdbcpostgresql-adapter'
    gem 'activerecord-jdbcmysql-adapter'
  end
end
