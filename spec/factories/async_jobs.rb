# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :async_job, :class => 'AsyncJobs' do
    email "MyString"
    job_id "MyString"
    url "MyString"
    status "MyString"
  end
end
