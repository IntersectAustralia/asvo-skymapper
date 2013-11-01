def save_query_fixture(data)
  query_args = data[:params]

  service_args = {
      dataset: data[:dataset],
      catalogue: data[:catalogue]
  }

  query = QueryGenerator.method(data[:method]).call(query_args)
  service = SyncTapService.new(service_args)
  res = service.fetch_query_response(query)
  xml = File.new(Rails.root.join("spec/fixtures/#{data[:filename]}.xml"), 'w')
  xml.write(res.body)
  xml.close
  vo = File.new(Rails.root.join("spec/fixtures/#{data[:filename]}.vo"), 'w')
  vo_table = VOTableParser.parse_xml(File.read(Rails.root.join("spec/fixtures/#{data[:filename]}.xml")))
  puts "#{data[:filename]} contains #{vo_table.table_data ? vo_table.table_data.size : 0} objects"
  YAML.dump(vo_table, vo)
  vo.close
end

def save_image_query_fixture(data)
  query_args = data[:params]

  service_args = {
      dataset: data[:dataset],
      catalogue: data[:catalogue]
  }

  query = QueryGenerator.method(data[:method]).call(query_args)
  service = SiapService.new(service_args)
  res = service.fetch_query_response(query)
  xml = File.new(Rails.root.join("spec/fixtures/#{data[:filename]}.xml"), 'w')
  xml.write(res)
  xml.close
  vo = File.new(Rails.root.join("spec/fixtures/#{data[:filename]}.vo"), 'w')
  vo_table = VOTableParser.parse_xml(File.read(Rails.root.join("spec/fixtures/#{data[:filename]}.xml")))
  puts "#{data[:filename]} contains #{vo_table.table_data ? vo_table.table_data.size : 0} objects"
  YAML.dump(vo_table, vo)
  vo.close
end

def generate_query_fixtures

  query_data = [
      {dataset: 'skymapper', catalogue: 'fs', params: {ra: '178.83871', dec: '-1.18844', sr: '0.5'}, filename: 'skymapper_point_query_fs_1', method: :generate_point_query},
      {dataset: 'skymapper', catalogue: 'fs', params: {ra: '1', dec: '1', sr: '1'}, filename: 'skymapper_point_query_fs_2', method: :generate_point_query},
      {dataset: 'skymapper', catalogue: 'fs', params: {ra: '178.83871', dec: '-1.18844', sr: '2'}, filename: 'skymapper_point_query_fs_3', method: :generate_point_query},
      {dataset: 'skymapper', catalogue: 'ms', params: {ra: '178.83871', dec: '-1.18844', sr: '0.15'}, filename: 'skymapper_point_query_ms_1', method: :generate_point_query},
      {dataset: 'skymapper', catalogue: 'ms', params: {ra: '1', dec: '1', sr: '1'}, filename: 'skymapper_point_query_ms_2', method: :generate_point_query},
      {dataset: 'skymapper', catalogue: 'ms', params: {ra: '178.83871', dec: '-1.18844', sr: '0.5'}, filename: 'skymapper_point_query_ms_3', method: :generate_point_query},

      {dataset: 'skymapper', catalogue: 'fs', params: {ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75'}, filename: 'skymapper_rectangular_query_fs_1', method: :generate_rectangular_query},
      {dataset: 'skymapper', catalogue: 'fs', params: {ra_min: '1', ra_max: '1.1', dec_min: '1', dec_max: '1.1'}, filename: 'skymapper_rectangular_query_fs_2', method: :generate_rectangular_query},
      {dataset: 'skymapper', catalogue: 'fs', params: {ra_min: '0', ra_max: '10', dec_min: '-2.25', dec_max: '-0.75'}, filename: 'skymapper_rectangular_query_fs_3', method: :generate_rectangular_query},
      {dataset: 'skymapper', catalogue: 'ms', params: {ra_min: '1.975', ra_max: '2.025', dec_min: '-1.525', dec_max: '-1.475'}, filename: 'skymapper_rectangular_query_ms_1', method: :generate_rectangular_query},
      {dataset: 'skymapper', catalogue: 'ms', params: {ra_min: '1', ra_max: '1.1', dec_min: '1', dec_max: '1.1'}, filename: 'skymapper_rectangular_query_ms_2', method: :generate_rectangular_query},
      {dataset: 'skymapper', catalogue: 'ms', params: {ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75'}, filename: 'skymapper_rectangular_query_ms_3', method: :generate_rectangular_query}
  ]

  %w[u v g r i z].each do |filter|

    filter_query_data = [
        {dataset: 'skymapper', catalogue: 'fs', params: {ra: '178.83871', dec: '-1.18844', sr: '0.5', "#{filter}_min" => '50'}.symbolize_keys, filename: "skymapper_point_query_fs_#{filter}_filter_1", method: :generate_point_query},
        {dataset: 'skymapper', catalogue: 'fs', params: {ra: '178.83871', dec: '-1.18844', sr: '0.5', "#{filter}_max" => '1000'}.symbolize_keys, filename: "skymapper_point_query_fs_#{filter}_filter_2", method: :generate_point_query},
        {dataset: 'skymapper', catalogue: 'fs', params: {ra: '178.83871', dec: '-1.18844', sr: '0.5', "#{filter}_min" => '50', "#{filter}_max" => '1000'}.symbolize_keys, filename: "skymapper_point_query_fs_#{filter}_filter_3", method: :generate_point_query},
        {dataset: 'skymapper', catalogue: 'ms', params: {ra: '178.83871', dec: '-1.18844', sr: '0.15', "#{filter}_min" => '0.1'}.symbolize_keys, filename: "skymapper_point_query_ms_#{filter}_filter_1", method: :generate_point_query},
        {dataset: 'skymapper', catalogue: 'ms', params: {ra: '178.83871', dec: '-1.18844', sr: '0.15', "#{filter}_max" => '1'}.symbolize_keys, filename: "skymapper_point_query_ms_#{filter}_filter_2", method: :generate_point_query},
        {dataset: 'skymapper', catalogue: 'ms', params: {ra: '178.83871', dec: '-1.18844', sr: '0.15', "#{filter}_min" => '0.1', "#{filter}_max" => '1'}.symbolize_keys, filename: "skymapper_point_query_ms_#{filter}_filter_3", method: :generate_point_query},

        {dataset: 'skymapper', catalogue: 'fs', params: {ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75', "#{filter}_min" => '50'}.symbolize_keys, filename: "skymapper_rectangular_query_fs_#{filter}_filter_1", method: :generate_rectangular_query},
        {dataset: 'skymapper', catalogue: 'fs', params: {ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75', "#{filter}_max" => '500'}.symbolize_keys, filename: "skymapper_rectangular_query_fs_#{filter}_filter_2", method: :generate_rectangular_query},
        {dataset: 'skymapper', catalogue: 'fs', params: {ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75', "#{filter}_min" => '50', "#{filter}_max" => '500'}.symbolize_keys, filename: "skymapper_rectangular_query_fs_#{filter}_filter_3", method: :generate_rectangular_query},
        {dataset: 'skymapper', catalogue: 'ms', params: {ra_min: '1.975', ra_max: '2.025', dec_min: '-1.525', dec_max: '-1.475', "#{filter}_min" => '0.1'}.symbolize_keys, filename: "skymapper_rectangular_query_ms_#{filter}_filter_1", method: :generate_rectangular_query},
        {dataset: 'skymapper', catalogue: 'ms', params: {ra_min: '1.975', ra_max: '2.025', dec_min: '-1.525', dec_max: '-1.475', "#{filter}_max" => '1'}.symbolize_keys, filename: "skymapper_rectangular_query_ms_#{filter}_filter_2", method: :generate_rectangular_query},
        {dataset: 'skymapper', catalogue: 'ms', params: {ra_min: '1.975', ra_max: '2.025', dec_min: '-1.525', dec_max: '-1.475', "#{filter}_min" => '0.1', "#{filter}_max" => '1'}.symbolize_keys, filename: "skymapper_rectangular_query_ms_#{filter}_filter_3", method: :generate_rectangular_query}
    ]

    query_data = query_data.concat(filter_query_data)

  end

  filter_all_query_data = [
      {dataset: 'skymapper', catalogue: 'fs', params: {ra: '178.83871', dec: '-1.18844', sr: '0.5'}, filename: 'skymapper_point_query_fs_filter_all', method: :generate_point_query},
      {dataset: 'skymapper', catalogue: 'ms', params: {ra: '178.83871', dec: '-1.18844', sr: '0.15'}, filename: 'skymapper_point_query_ms_filter_all', method: :generate_point_query},
      {dataset: 'skymapper', catalogue: 'fs', params: {ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75'}, filename: 'skymapper_rectangular_query_fs_filter_all', method: :generate_rectangular_query},
      {dataset: 'skymapper', catalogue: 'ms', params: {ra_min: '1.975', ra_max: '2.025', dec_min: '-1.525', dec_max: '-1.475'}, filename: 'skymapper_rectangular_query_ms_filter_all', method: :generate_rectangular_query}
  ]

  %w[u v g r i z].each do |filter|
    filter_all_query_data[0][:params]["#{filter}_min".to_sym] = 50
    filter_all_query_data[0][:params]["#{filter}_max".to_sym] = 1000
    filter_all_query_data[1][:params]["#{filter}_min".to_sym] = 0.1
    filter_all_query_data[1][:params]["#{filter}_max".to_sym] = 1
    filter_all_query_data[2][:params]["#{filter}_min".to_sym] = 50
    filter_all_query_data[2][:params]["#{filter}_max".to_sym] = 500
    filter_all_query_data[3][:params]["#{filter}_min".to_sym] = 0.1
    filter_all_query_data[3][:params]["#{filter}_max".to_sym] = 1
  end

  query_data = query_data.concat(filter_all_query_data)

  query_data.each do |data|
    save_query_fixture(data)
  end

end

def generate_image_query_fixtures

  query_data = [
      {dataset: 'skymapper', catalogue: 'image', params: {ra: '181.16129', dec: '-1.18844'}, filename: 'skymapper_image_query_1', method: :generate_image_query},
      {dataset: 'skymapper', catalogue: 'image', params: {ra: '178.83871', dec: '-1.18844'}, filename: 'skymapper_image_query_2', method: :generate_image_query}
  ]

  query_data.each do |data|
    save_image_query_fixture(data)
  end

end

def generate_download_results
  query_data = [
      {dataset: 'skymapper', catalogue: 'fs', params: {ra: '178.83871', dec: '-1.18844', sr: '2'}, filename: 'skymapper_web_view_point_query', method: :generate_point_query},
      {dataset: 'skymapper', catalogue: 'fs', params: {ra: '178.83871', dec: '-1.18844', sr: '2', limit: false}, filename: 'skymapper_download_point_query', method: :generate_point_query},

      {dataset: 'skymapper', catalogue: 'fs', params: {ra_min: '0', ra_max: '10', dec_min: '-2.25', dec_max: '-0.75'}, filename: 'skymapper_web_view_rectangular_query', method: :generate_rectangular_query},
      {dataset: 'skymapper', catalogue: 'fs', params: {ra_min: '0', ra_max: '10', dec_min: '-2.25', dec_max: '-0.75', limit: false}, filename: 'skymapper_download_rectangular_query', method: :generate_rectangular_query}
  ]

  query_data.each do |data|
    save_query_fixture(data)
  end
end

def create_image_query_fixture(filename, params, size = 500)
  doc = File.read(Rails.root.join('spec/fixtures/skymapper_image_query_2.xml'))

  filters = %w[u v g r i z]
  surveys = %w[fs ms]
  num_of_fields = 20

  xml = '<TABLEDATA>'

  size.times.each do
    xml += '<TR>'

    values = { 4 => rand(1.year.ago..Time.now).to_date.mjd, 5 => params[:ra].to_f + rand - 0.5, 6 => params[:dec].to_f + rand - 0.5, 15 => filters.sample, 18 => surveys.sample }
    num_of_fields.times.each do |index|

      if values[index].blank?
        xml += '<TD/>'
      else
        xml += "<TD>#{values[index]}</TD>"
      end

    end

    xml += '</TR>'
  end

  xml += '</TABLEDATA>'

  replace = <<-EOF
<TABLEDATA>
</TABLEDATA>
  EOF

  doc.gsub!(replace, xml)

  vo = File.new(Rails.root.join("spec/fixtures/#{filename}.xml"), 'w')
  vo.write doc
  vo.close

  vo = File.new(Rails.root.join("spec/fixtures/#{filename}.vo"), 'w')
  vo_table = VOTableParser.parse_xml(File.read(Rails.root.join("spec/fixtures/#{filename}.xml")))
  puts "#{filename} contains #{vo_table.table_data ? vo_table.table_data.size : 0} objects"
  YAML.dump(vo_table, vo)
  vo.close
end