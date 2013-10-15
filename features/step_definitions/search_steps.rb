And /^I select the "([^"]*)" tab$/ do |tab|
  click_on(tab)
end

#Then /^I should see search table "([^"]*)"$/ do |file|
#  vo_table = YAML.load(File.read(Rails.root.join("features/fixtures/#{file}")))
#
#end

Then /^I should not see any errors for "([^"]*)"$/ do |field|
  within(:xpath, "//label[contains(text(), '#{field}')]/..") do
    page.should have_css('div.error', visible: false)
  end
end

Then /^I should see error "([^"]*)" for "([^"]*)"$/ do |error, field|
  within(:xpath, "//label[contains(text(), '#{field}')]/..") do
    page.should have_css('div.error', visible: true)
    page.should have_xpath(".//small[contains(text(), '#{error}')]", visible: true)
  end
end