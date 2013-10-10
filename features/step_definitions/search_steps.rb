And /^I select the "([^"]*)" tab$/ do |tab|
  click_on(tab)
end

Then /^I should see search results "([^"]*)" as json$/ do |file|
  json = JSON.parse(File.read(Rails.root.join("spec/fixtures/#{file}")))
  page.should have_content(json)
end