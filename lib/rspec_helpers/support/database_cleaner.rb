begin
  require 'database_cleaner'

  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do |example|
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.strategy = :deletion if example.metadata[:type] == :feature
      DatabaseCleaner.start
    end

    config.after(:each) do
      # Capybara.reset_sessions!
      DatabaseCleaner.clean
    end
  end
rescue LoadError
end
