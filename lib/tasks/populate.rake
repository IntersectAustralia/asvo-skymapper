require File.dirname(__FILE__) + '/sample_data_populator.rb'
begin
  namespace :db do
    desc "Populate the database with some sample data for testing"
    task :populate => :environment do
      unless %w(qa development test staging).include?(Rails.env)
        raise StandardError, "Error: Cannot populate in a non-development/qa/test environment!"
      end
      populate_data
    end
  end
  # In case we don't have ActiveRecord, append a no-op task that we can depend upon.
  task 'db:test:prepare' do
    Rails.env = "test"
    # Add tasks here to run after db:test:prepare
    # ie creating views or seeding data
  end
rescue LoadError
  puts "It looks like some Gems are missing: please run bundle install"  
end