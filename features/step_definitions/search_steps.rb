And /^I select the "([^"]*)" tab$/ do |tab|
  click_on(tab)
end

And /^I should see radial search parameters with values \("([^"]*)", "([^"]*)", "([^"]*)"\)$/ do |ra, dec, sr|
  step "I should see search parameter \"Right ascension\" as \"#{ra}\""
  step "I should see search parameter \"Declination\" as \"#{dec}\""
  step "I should see search parameter \"Radius\" as \"#{sr}\""
end

And /^I should see rectangular search parameters with values \("([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)"\)$/ do |ra_min, ra_max, dec_min, dec_max|
  step "I should see search parameter \"Right ascension min\" as \"#{ra_min}\""
  step "I should see search parameter \"Right ascension max\" as \"#{ra_max}\""
  step "I should see search parameter \"Declination min\" as \"#{dec_min}\""
  step "I should see search parameter \"Declination max\" as \"#{dec_max}\""
end

And /^I should see search parameter "([^"]*)" as "([^"]*)"/ do |parameter, value|
  unless value.blank?
    within(find('.search-parameter', text: parameter)) do
      find('.search-value').text.should == "#{value}°"
    end
  end
end

And /^I should not see any results$/ do
  page.should_not have_css('table', visible: true)
end

And /^I should see results for catalogue "([^"]*)" with headers$/ do |catalogue|
  page.should have_css('table', visible: true)

  fields = SearchController.new.search_fields(catalogue)

  table_headers = all('thead th')
  fields.each_with_index do |field, index|
    table_headers[index].text.should == field[:name]
  end
end

And /^I goto the next page$/ do
  find('.next-page').click
end

And /^I should see results for catalogue "([^"]*)" as "([^"]*)" in page "([^"]*)" with limit "([^"]*)"$/ do |catalogue, file, page, limit|
  if ENV['SKIP_STEP'].blank?

    step "I should see results for catalogue \"#{catalogue}\" with headers"

    fields = SearchController.new.search_fields(catalogue)

    results_table = YAML.load(File.read(Rails.root.join("spec/fixtures/#{file}.vo")))

    table_rows = all('tbody tr')
    table_rows.each_with_index do |row, row_index|

      within(row) do

        table_fields = all('td')
        fields.each_with_index do |field, field_index|
          table_fields[field_index].text.should == results_table.table_data[(page.to_i - 1) * limit.to_i + row_index][field[:field]]
        end

      end

    end

  end

end

And /^I should see results for catalogue "([^"]*)" as "([^"]*)" in all pages with limit "([^"]*)"$/ do |catalogue, file, limit|
  if ENV['SKIP_STEP'].blank?

    results_table = YAML.load(File.read(Rails.root.join("spec/fixtures/#{file}.vo")))

    pages = (results_table.table_data.length / limit.to_i).ceil
    (1..pages).each do |page|
      step "I should see results for catalogue \"#{catalogue}\" as \"#{file}\" in page \"#{page}\" with limit \"#{limit}\""
      step 'I goto the next page'
    end

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
    page.should_not have_css('ul.error', visible: true)
  end
end

Then /^I should see error "([^"]*)" for "([^"]*)"$/ do |error, field|
  within(:xpath, "//label[contains(text(), '#{field}')]/..") do
    page.should have_css('ul.error', visible: true)
    page.should have_xpath(".//li[contains(text(), '#{error}')]", visible: true)
  end
end

And /^I wait$/ do
  sleep(1)
end

And /^I wait for "([^"]*)"$/ do |message|
  loop do
    break unless page.has_content?(message)
    sleep(1)
  end
end

Before do
  FakeWeb.clean_registry
end

And /^I can(not)? see page "([^"]*)"$/ do |cannot, page|
  find('.pagination a', text: page, visible: cannot ? false : true)
end

And /^I can see pages "([^"]*)" to "([^"]*)"$/ do |from, to|
  (from.to_i..to.to_i).each do |i|
    step "I can see page \"#{i}\""
  end
end

And /^I can(not)? press page "([^"]*)"$/ do |cannot, page|
  find(".pagination #{cannot ? '.disabled' : nil}", text: page)
end

And /^I can press pages "([^"]*)" to "([^"]*)" except "([^"]*)"$/ do |from, to, page|
  (from.to_i..to.to_i).each do |i|
    step "I can#{i == page.to_i ? 'not' : nil} press page \"#{i}\""
  end
end

And /^I select page "([^"]*)"$/ do |page|
  find('.pagination a', text: page).click
end

Then /^I should see pages "([^"]*)" to "([^"]*)" with page "([^"]*)" selected given "([^"]*)" total pages$/ do |min_page, max_page, page, total|
  step "I can see pages \"#{min_page}\" to \"#{max_page}\""
  step "I can#{page == 1 ? 'not' : nil} press page \"«\""
  step "I can#{page == 1 ? 'not' : nil} press page \"‹\""
  step "I can press pages \"#{min_page}\" to \"#{max_page}\" except \"#{page}\""
  step "I can#{page == total ? 'not' : nil} press page \"›\""
  step "I can#{page == total ? 'not' : nil} press page \"»\""
end