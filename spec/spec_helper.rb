require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::Console,
  # Want a nice code coverage website? Uncomment this next line!
  # SimpleCov::Formatter::HTMLFormatter
])
SimpleCov.start

ENV['RACK_ENV'] = 'test'

require 'capybara'
require 'capybara/rspec'
require 'sinatra/base'
require 'rspec'
require 'pg'
require_relative './features/web_helper'

require File.join(File.dirname(__FILE__), '..', 'app.rb')

Capybara.app = ChitterApp

RSpec.configure do |config|
  config.after(:suite) do
    puts
    puts "\e[33mHave you considered running rubocop? It will help you improve your code!\e[0m"
    puts "\e[33mTry it now! Just run: rubocop\e[0m"
  end

  config.before(:each) do
    conn = PG.connect(dbname: 'chitter_test')
    conn.exec('DROP TABLE IF EXISTS users;')
    conn.exec('DROP TABLE IF EXISTS peeps;')
    conn.exec('CREATE TABLE "public"."users" ("id" serial,"name" text,"username" text,"email" text,"password" text, PRIMARY KEY (id));')
    conn.exec('CREATE TABLE "public"."peeps" ("id" serial,"content" text, PRIMARY KEY (id), time TIMESTAMP);')
  end
end
