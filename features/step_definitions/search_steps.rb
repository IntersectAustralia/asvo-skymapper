Before do
  FakeWeb.clean_registry
end

And /^I select the "([^"]*)" tab$/ do |tab|
  click_on(tab)
end

And /^I should see the "([^"]*)" tab$/ do |tab|
  find('#search-tabs li.active').find(:xpath, ".//a[contains(text(), '#{tab}')]")
end

And /^I should see radial search parameters with values \("([^"]*)", "([^"]*)", "([^"]*)"\)$/ do |ra, dec, sr|
  step "I should see search parameter \"Right ascension\" as \"#{ra}\""
  step "I should see search parameter \"Declination\" as \"#{dec}\""
  step "I should see search parameter \"Radius\" as \"#{sr}\""
end

And /^I should see raw image search parameters with values \("([^"]*)", "([^"]*)"\)$/ do |ra, dec|
  step "I should see search parameter \"Right ascension\" as \"#{ra}\""
  step "I should see search parameter \"Declination\" as \"#{dec}\""
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
    results_table = YAML.load(File.read(Rails.root.join("spec/fixtures/#{file}.vo")))
  end
end

And /^I should see the full list of results in "([^"]*)" compared to "([^"]*)"$/ do |web, file|

end

And /^I fake tap search request for catalogue "([^"]*)" with "([^"]*)"$/ do |catalogue, file|
  service_args = {dataset:SearchController::DEFAULT_DATASET, catalogue: catalogue}
  service = SyncTapService.new(service_args)

  FakeWeb.register_uri(:any, %r|#{service.request}.*|, body: File.read(Rails.root.join("spec/fixtures/#{file}.xml")) )
end

And /^I fake tap search request for catalogue "([^"]*)" returns error$/ do |catalogue|
  service_args = {dataset:SearchController::DEFAULT_DATASET, catalogue: catalogue}
  service = SyncTapService.new(service_args)

  FakeWeb.register_uri(:any, %r|#{service.request}.*|, exception: Exception )
end

And /^I fake siap search request for catalogue "([^"]*)" with "([^"]*)"$/ do |catalogue, file|
  service_args = {dataset:SearchController::DEFAULT_DATASET, catalogue: catalogue}
  service = SiapService.new(service_args)

  FakeWeb.register_uri(:any, %r|#{service.request}.*|, body: File.read(Rails.root.join("spec/fixtures/#{file}.xml")) )
end

And /^I fake siap search request for catalogue "([^"]*)" returns error$/ do |catalogue|
  service_args = {dataset:SearchController::DEFAULT_DATASET, catalogue: catalogue}
  service = SiapService.new(service_args)

  FakeWeb.register_uri(:any, %r|#{service.request}.*|, exception: Exception )
end

And /^I fake download radial search request for catalogue "([^"]*)" with "([^"]*)"$/ do |catalogue, file|
  service_args = {dataset:SearchController::DEFAULT_DATASET, catalogue: catalogue}
  service = SyncTapService.new(service_args)

  FakeWeb.register_uri(:any, %r|#{service.request}.*|, body: File.read(Rails.root.join("spec/fixtures/#{file}.xml")) )
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

And /^I should see raw image results as "([^"]*)" in all pages with limit "([^"]*)" in proper order$/ do |file, limit|
  if ENV['SKIP_STEP'].blank?

    results_table = YAML.load(File.read(Rails.root.join("spec/fixtures/#{file}.vo")))

    pages = (results_table.table_data.length / limit.to_i).ceil
    pages.times.each do
      step 'I should see raw image results on page in proper order'
      step 'I goto the next page'
    end

  end
end

And /^I should see raw image results on page in proper order$/ do
  if ENV['SKIP_STEP'].blank?
    filters = %w[u v g r i z]

    table_rows = all('tbody tr')
    table_rows.each_with_index do |row, row_index|
      next if row_index == 0
      last_row = table_rows[row_index - 1]

      last_field_values = last_row.all('td')
      field_values = row.all('td')

      # order on ra, dec, filters (u, v, g, r, i, z) and date

      ra = field_values[0].text.to_f
      last_ra = last_field_values[0].text.to_f
      ra.should >= last_ra

      if ra == last_ra
        dec = field_values[1].text.to_f
        last_dec = last_field_values[1].text.to_f
        dec.should >= last_dec

        if dec == last_dec
          filter = filters.index(field_values[2].text.downcase)
          last_filter = filters.index(last_field_values[2].text.downcase)
          filter.should >= last_filter

          if filter == last_filter
            date = field_values[4].text.to_f
            last_date = last_field_values[4].text.to_f
            date.should >= last_date
          end
        end
      end
    end
  end
end

FAKE_IMAGE = 'fake image'

Then /^I fake request for first image link$/ do
  link = first('.image-link')['data-href']
  FakeWeb.register_uri(:any, link, response: FAKE_IMAGE )
end

And /^I click the first image link$/ do
  first('.image-link').click
end

Then /^I should see popup with message "([^"]*)"$/ do |message|
  page.driver.browser.switch_to.alert.text.should == message
end

And /^I download the image file$/ do
  page.driver.browser.switch_to.alert.accept
end

And /^I should see search field "([^"]*)" with value "([^"]*)"$/ do |field, value|
  find_field(field).value.should == value
end