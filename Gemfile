source 'https://rubygems.org'

gem 'rails', '~> 4.0.1'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'haml-rails'
gem 'simple_form', '~> 3.0.0'

gem "mongoid", :github => "mongoid/mongoid" # wait until ready for activerecord 4.0

gem 'sorcery'
gem 'cancan'
gem 'gravtastic'
gem 'kaminari'
gem 'pretty_formatter'

gem 'Simulator', :require => 'sim', :github => 'grrrisu/Simulator' #:path => '../Simulator'
gem 'uuid'

gem 'sass-rails',   '~> 4.0.1'
gem 'coffee-rails', '~> 4.0.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platform => :ruby
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-sass', "~> 3.0.2.0"
gem "bower-rails", "~> 0.6.0"

group :development do
  gem 'thin'
  gem 'pry-rails'

  gem 'rb-readline', :require => false
  gem 'guard', :require => false
  gem 'guard-rspec', :require => false
  # guard-jasmine needs PhantomJS
  # see http://code.google.com/p/phantomjs/wiki/BuildInstructions#Mac_OS_X
  gem 'guard-jasmine', :require => false
  gem 'growl', :require => false
  gem 'rb-fsevent', '~> 0.9.1', :require => false

  gem 'capistrano', :require => false
  gem 'capistrano-ext', :require => false
  gem 'rvm-capistrano', :require => false

  gem 'hirb', :require => false
  gem 'wirble', :require => false

  gem 'brakeman', :require => false
  gem 'rack-mini-profiler', :require => false # set to true to enable mini profiler
  gem 'bullet'
  gem 'rails_best_practices'
  gem 'smusher', :require => false
end

group :test, :development do
  gem "rspec-rails"
  gem "jasminerice", :github => 'bradphelan/jasminerice' # wait until ready for rails4
  gem "spork", '~> 1.0rc', :require => false
  gem "guard-spork", :require => false
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'capybara', '~> 2.0.3' # version 2.1 needs capybara-webkit  >= 1.0
  gem 'capybara-webkit', '~> 0.14.2' # version 1.0 needs QT >= 4.8 which is not compatible with OS X 10.6
  gem 'database_cleaner'
  gem 'launchy'
end

group :staging, :production do
  gem 'puma'
  gem 'newrelic_rpm'
  gem 'airbrake'
end
