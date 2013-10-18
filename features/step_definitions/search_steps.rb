And /^I select the "([^"]*)" tab$/ do |tab|
  click_on(tab)
end

And /^I should see radial search parameters with values \("([^"]*)", "([^"]*)", "([^"]*)"\)$/ do |ra, dec, sr|
  step "I should see search parameter \"Right ascension\" as \"#{ra}\""
  step "I should see search parameter \"Declination\" as \"#{dec}\""
  step "I should see search parameter \"Radius\" as \"#{sr}\""
end

And /^I should see search parameter "([^"]*)" as "([^"]*)"/ do |parameter, value|
  within(find('.search-parameter', text: parameter)) do
    find('.search-value').text.should == "#{value}°"
  end
end

And /^I should not see any results$/ do
  page.should have_css('table', visible: false)
end

And /^I should see results for catalogue "([^"]*)" with headers$/ do |catalogue|
  page.should have_css('table', visible: true)

  fields = SearchController.new.radial_search_fields(catalogue)

  table_headers = all('thead th')
  fields.each_with_index do |field, index|
    table_headers[index].text.should == field[:name]
  end
end

And /^I goto the next page$/ do
  find('.next-page').click
end

And /^I should see results for catalogue "([^"]*)" as "([^"]*)" with "([^"]*)" per page$/ do |catalogue, file, limit|
  step "I should see results for catalogue \"#{catalogue}\" with headers"

  results_table = YAML.load(File.read(Rails.root.join("spec/fixtures/#{file}.vo")))
  fields = SearchController.new.radial_search_fields(catalogue)

  pages = (results_table.table_data.length / limit.to_i).ceil
  (1..pages).each do |page|

    table_rows = all('tbody tr')
    table_rows.each_with_index do |row, row_index|

      within(row) do

        table_fields = all('td')
        fields.each_with_index do |field, field_index|
          table_fields[field_index].text.should == results_table.table_data[(page - 1) * limit.to_i + row_index][field[:field]]
        end

      end

    end

    step 'I goto the next page'

  end
end

And /^I fake search request for catalogue "([^"]*)" with "([^"]*)"$/ do |catalogue, file|
  service_args = {dataset:SearchController::DEFAULT_DATASET, catalogue: catalogue}
  service = SyncQueryService.new(service_args)

  FakeWeb.register_uri(:post, service.request, body: File.read(Rails.root.join("spec/fixtures/#{file}.xml")) )
end

And /^I fake search request for catalogue "([^"]*)" returns error$/ do |catalogue|
  service_args = {dataset:SearchController::DEFAULT_DATASET, catalogue: catalogue}
  service = SyncQueryService.new(service_args)

  FakeWeb.register_uri(:post, service.request, exception: Exception )
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