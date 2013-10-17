And /^I select the "([^"]*)" tab$/ do |tab|
  click_on(tab)
end

And /^I should see radial search parameters \("([^"]*)", "([^"]*)", "([^"]*)"\)$/ do |ra, dec, sr|
  step "I should see search parameter \"Right ascension\" as \"#{ra}\""
  step "I should see search parameter \"Declination\" as \"#{dec}\""
  step "I should see search parameter \"Radius\" as \"#{sr}\""
end

And /^I should see search parameter "([^"]*)" as "([^"]*)"/ do |parameter, value|
  within(find('.search-parameter', text: parameter)) do
    find('.search-value').text.should == "#{value}°"
  end
end

And /^I should not see results table$/ do
  page.should_not have_css('table', visible: true)
end

And /^I should see results table$/ do
  page.should have_css('table', visible: true)

  # test correct headers for table
  fields = SearchController.new.radial_search_fields('fs')

  table_headers = all('thead th')
  fields.each_with_index do |field, index|
    table_headers[index].text.should == field[:name]
  end
end

And /^I should see results "([^"]*)"$/ do |file|
  step 'I should see results table'

  results_table = YAML.load(File.read(Rails.root.join("spec/fixtures/#{file}.vo")))
  fields = SearchController.new.radial_search_fields('fs')

  table_rows = all('tbody tr')
  table_rows.each_with_index do |row, row_index|

    within(row) do

      table_fields = all('td')
      fields.each_with_index do |field, field_index|
        table_fields[field_index].text.should == results_table.table_data[row_index][field[:field]]
      end

    end

  end
end

And /^I fake search for catalogue "([^"]*)" returns "([^"]*)"$/ do |catalogue, file|
  service_args = {dataset:SearchController::DEFAULT_DATASET, catalogue: catalogue}
  service = SyncQueryService.new(service_args)

  FakeWeb.register_uri(:post, service.request, :body => File.read(Rails.root.join("spec/fixtures/#{file}.xml")) )
end

And /^I fake search for catalogue "([^"]*)" returns error$/ do |catalogue, file|
  service_args = {dataset:SearchController::DEFAULT_DATASET, catalogue: catalogue}
  service = SyncQueryService.new(service_args)

  FakeWeb.register_uri(:post, service.request, :body => raise Exception )
end

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

And /^I wait$/ do
  sleep(10)
end

Before do
  FakeWeb.clean_registry
end