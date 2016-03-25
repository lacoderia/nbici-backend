source 'https://rubygems.org'

gem 'rails', '4.2.5'

gem 'pg'
gem 'state_machine'
gem 'cancancan'
gem "active_model_serializers", "~> 0.8.0"
gem 'devise'

# To use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilderR

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :development, :test do
  gem 'spring'
  # Call 'pry' anywhere in the code to stop execution and get a debugger console
  gem 'pry-rails'
  # Automatically call pry on exception
  gem 'pry-rescue'
  # Browse the stack on pry
  gem 'pry-stack_explorer' 
  # To reload UI changes
  gem 'guard-livereload'
end

group :test do
  # Testing framework
  gem 'rspec-rails'
  # Functional testing
  gem 'capybara'
  # Testing factories
  gem "factory_girl_rails"
  # Testing coverage
  gem 'simplecov', :require => false
  # Clean database after each test
  gem 'database_cleaner'
  # Manipulate time in tests
  gem 'timecop'
end
