def save_query_fixture(filename, query_args, service_args, factory)
  query = factory.call(query_args)
  service = SyncQueryService.new(service_args)
  res = service.fetch_query_response(query)
  xml = File.new(Rails.root.join("spec/fixtures/#{filename}.xml"), 'w')
  xml.write(res.body)
  xml.close
  vo = File.new(Rails.root.join("spec/fixtures/#{filename}.vo"), 'w')
  vo_table = VOTableParser.parse_xml(File.read(Rails.root.join("spec/fixtures/#{filename}.xml")))
  YAML.dump(vo_table, vo)
  vo.close
end

def generate_point_query_fixtures

  query_args = {
    dataset: 'skymapper',
    catalogue: 'fs',
    ra: '178.83871',
    dec: '-1.18844',
    sr: '0.5'
  }

  service_args = {
    dataset: 'skymapper',
    catalogue: 'fs',
  }

  save_query_fixture('skymapper_point_query_fs_1', query_args, service_args, QueryGenerator.method(:generate_point_query))

  query_args = {
    dataset: 'skymapper',
    catalogue: 'fs',
    ra: '1',
    dec: '1',
    sr: '1'
  }

  service_args = {
    dataset: 'skymapper',
    catalogue: 'fs',
  }

  save_query_fixture('skymapper_point_query_fs_2', query_args, service_args, QueryGenerator.method(:generate_point_query))

  query_args = {
    dataset: 'skymapper',
    catalogue: 'fs',
    ra: '178.83871',
    dec: '-1.18844',
    sr: '2'
  }

  service_args = {
    dataset: 'skymapper',
    catalogue: 'fs',
  }

  save_query_fixture('skymapper_point_query_fs_3', query_args, service_args, QueryGenerator.method(:generate_point_query))

  query_args = {
    dataset: 'skymapper',
    catalogue: 'ms',
    ra: '178.83871',
    dec: '-1.18844',
    sr: '0.15'
  }

  service_args = {
    dataset: 'skymapper',
    catalogue: 'ms',
  }

  save_query_fixture('skymapper_point_query_ms_1', query_args, service_args, QueryGenerator.method(:generate_point_query))

  query_args = {
    dataset: 'skymapper',
    catalogue: 'ms',
    ra: '1',
    dec: '1',
    sr: '1'
  }

  service_args = {
    dataset: 'skymapper',
    catalogue: 'ms',
  }

  save_query_fixture('skymapper_point_query_ms_2', query_args, service_args, QueryGenerator.method(:generate_point_query))

  query_args = {
    dataset: 'skymapper',
    catalogue: 'ms',
    ra: '178.83871',
    dec: '-1.18844',
    sr: '0.5'
  }

  service_args = {
    dataset: 'skymapper',
    catalogue: 'ms',
  }

  save_query_fixture('skymapper_point_query_ms_3', query_args, service_args, QueryGenerator.method(:generate_point_query))

end