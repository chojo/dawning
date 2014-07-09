require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

# figure out if spec_helper is loaded twice and from where
if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
  begin
    raise "foo"
  rescue => e
    puts <<-MSG
  ===================================================
  It looks like spec_helper.rb has been loaded
  multiple times. Normalize the require to:

    require "spec/spec_helper"

  Things like File.join and File.expand_path will
  cause it to be loaded multiple times.

  Loaded this time from:

    #{e.backtrace.join("\n    ")}
  ===================================================
    MSG
  end
end

Spork.prefork do
  unless ENV['DRB']
    puts 'simplecov without DRB'
    require 'simplecov'
    SimpleCov.start do
      add_filter '/spec/'
      add_filter '/config/'
      add_group 'Controllers', 'app/controllers'
      add_group 'Models', 'app/models'
      add_group 'Helpers', 'app/helpers'
      add_group 'Libraries', 'lib'
    end
  end

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'database_cleaner'

  # headless javascript testing
  Capybara.javascript_driver = :webkit

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/features/*.rb")].each {|f| require f} # require features first
  Dir[Rails.root.join("spec/support/*.rb")].each {|f| require f}

  RSpec.configure do |config|

    config.expect_with :rspec do |c|
      c.syntax = :expect
    end
    config.fail_fast = true

    config.filter_run focus: true
    config.filter_run_excluding skip: true
    config.run_all_when_everything_filtered = true

    config.include FactoryGirl::Syntax::Methods

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = "mongoid"
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.after(:each) do
      ActionMailer::Base.deliveries.clear
    end

    config.after(:each) do
      if example.exception
        puts "\e[0;31m#{example.exception}"
        puts example.exception.backtrace.reject {|line| line =~ /\/gems\//}.join("\n")
        puts "\e[0m"
        if example.metadata[:wait]
          puts "Scenario failed. We wait because of wait. Press enter when you are done"
          $stdin.gets
        elsif example.metadata[:pry]
          require 'pry'
          binding.send(:pry)
        end
      end
    end

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # helpers
    require Rails.root.join('spec', 'support', 'sim_helper')
    config.include SimHelper
  end

  include Sorcery::TestHelpers::Rails

end

Spork.each_run do
  if ENV['DRB']
    puts 'simplecov with DRB'
    require 'simplecov'
    SimpleCov.start do
      add_filter '/spec/'
      add_filter '/config/'
      add_group 'Controllers', 'app/controllers'
      add_group 'Models', 'app/models'
      add_group 'Helpers', 'app/helpers'
      add_group 'Libraries', 'lib'
    end
  end

  Dir[Rails.root.join("spec/support/features/*.rb")].each {|f| require f} # require features first
  Dir[Rails.root.join("spec/support/page_objects/*.rb")].each {|f| require f}
  Dir[Rails.root.join("spec/support/*.rb")].each {|f| require f}

end
