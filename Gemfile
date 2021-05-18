source 'https://rubygems.org'

gem 'rails', '4.2.7.1'

gem 'pg', '~> 0.20'
gem 'state_machine'
gem 'cancancan'
gem "active_model_serializers", "~> 0.8.0"
gem 'devise', "~> 3.5.6"
gem 'devise_token_auth'
gem 'rack-cors', :require => 'rack/cors'
gem 'conekta'
gem 'delayed_job_active_record'
gem 'pry-remote', :require => 'pry-remote'

gem 'activeadmin', github: 'activeadmin'
gem 'active_admin_datetimepicker'
#gem 'omniauth'
gem 'nokogiri', '~> 1.11.4'

gem 'paperclip'

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
  gem 'rspec-activejob'
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
