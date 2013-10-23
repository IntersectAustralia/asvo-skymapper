def save_query_fixture(filename, query_args, service_args, factory)
  query = factory.call(query_args)
  service = SyncQueryService.new(service_args)
  res = service.fetch_query_response(query)
  xml = File.new(Rails.root.join("spec/fixtures/#{filename}.xml"), 'w')
  xml.write(res.body)
  xml.close
  vo = File.new(Rails.root.join("spec/fixtures/#{filename}.vo"), 'w')
  vo_table = VOTableParser.parse_xml(File.read(Rails.root.join("spec/fixtures/#{filename}.xml")))
  puts "#{filename} contains #{vo_table.table_data ? vo_table.table_data.size : 0} objects"
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

def generate_point_query_filter_fixtures

  ['u', 'v', 'g', 'r', 'i', 'z'].each do |filter|

    query_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }
    query_args["#{filter}_min".to_sym] = 50

    service_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
    }

    save_query_fixture("skymapper_point_query_fs_#{filter}_filter_1", query_args, service_args, QueryGenerator.method(:generate_point_query))

    query_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }
    query_args["#{filter}_max".to_sym] = 1000

    save_query_fixture("skymapper_point_query_fs_#{filter}_filter_2", query_args, service_args, QueryGenerator.method(:generate_point_query))

    query_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }
    query_args["#{filter}_min".to_sym] = 50
    query_args["#{filter}_max".to_sym] = 1000

    save_query_fixture("skymapper_point_query_fs_#{filter}_filter_3", query_args, service_args, QueryGenerator.method(:generate_point_query))

    query_args = {
        dataset: 'skymapper',
        catalogue: 'ms',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.15'
    }
    query_args["#{filter}_min".to_sym] = 0.1

    service_args = {
        dataset: 'skymapper',
        catalogue: 'ms',
    }

    save_query_fixture("skymapper_point_query_ms_#{filter}_filter_1", query_args, service_args, QueryGenerator.method(:generate_point_query))

    query_args = {
        dataset: 'skymapper',
        catalogue: 'ms',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.15'
    }
    query_args["#{filter}_max".to_sym] = 1

    save_query_fixture("skymapper_point_query_ms_#{filter}_filter_2", query_args, service_args, QueryGenerator.method(:generate_point_query))

    query_args = {
        dataset: 'skymapper',
        catalogue: 'ms',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.15'
    }
    query_args["#{filter}_min".to_sym] = 0.1
    query_args["#{filter}_max".to_sym] = 1

    save_query_fixture("skymapper_point_query_ms_#{filter}_filter_3", query_args, service_args, QueryGenerator.method(:generate_point_query))

  end

  query_args = {
      dataset: 'skymapper',
      catalogue: 'fs',
      ra: '178.83871',
      dec: '-1.18844',
      sr: '0.5'
  }

  ['u', 'v', 'g', 'r', 'i', 'z'].each do |filter|
    query_args["#{filter}_min".to_sym] = 50
    query_args["#{filter}_max".to_sym] = 1000
  end

  service_args = {
      dataset: 'skymapper',
      catalogue: 'fs',
  }

  save_query_fixture("skymapper_point_query_fs_filter_all", query_args, service_args, QueryGenerator.method(:generate_point_query))

  query_args = {
      dataset: 'skymapper',
      catalogue: 'ms',
      ra: '178.83871',
      dec: '-1.18844',
      sr: '0.15'
  }

  ['u', 'v', 'g', 'r', 'i', 'z'].each do |filter|
    query_args["#{filter}_min".to_sym] = 0.1
    query_args["#{filter}_max".to_sym] = 1
  end

  service_args = {
      dataset: 'skymapper',
      catalogue: 'ms',
  }

  save_query_fixture("skymapper_point_query_ms_filter_all", query_args, service_args, QueryGenerator.method(:generate_point_query))

end

def generate_rectangular_query_fixtures

  query_args = {
      dataset: 'skymapper',
      catalogue: 'fs',
      ra_min: '1.75',
      ra_max: '2.25',
      dec_min: '-2.25',
      dec_max: '-0.75'
  }

  service_args = {
      dataset: 'skymapper',
      catalogue: 'fs',
  }

  save_query_fixture('skymapper_rectangular_query_fs_1', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))

  query_args = {
      dataset: 'skymapper',
      catalogue: 'fs',
      ra_min: '1',
      ra_max: '1',
      dec_min: '1',
      dec_max: '1'
  }

  service_args = {
      dataset: 'skymapper',
      catalogue: 'fs',
  }

  save_query_fixture('skymapper_rectangular_query_fs_2', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))

  query_args = {
      dataset: 'skymapper',
      catalogue: 'fs',
      ra_min: '0',
      ra_max: '10',
      dec_min: '-2.25',
      dec_max: '-0.75'
  }

  service_args = {
      dataset: 'skymapper',
      catalogue: 'fs',
  }

  save_query_fixture('skymapper_rectangular_query_fs_3', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))

  query_args = {
      dataset: 'skymapper',
      catalogue: 'ms',
      ra_min: '1.975',
      ra_max: '2.025',
      dec_min: '-1.525',
      dec_max: '-1.475'
  }

  service_args = {
      dataset: 'skymapper',
      catalogue: 'ms',
  }

  save_query_fixture('skymapper_rectangular_query_ms_1', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))

  query_args = {
      dataset: 'skymapper',
      catalogue: 'ms',
      ra_min: '1',
      ra_max: '1',
      dec_min: '1',
      dec_max: '1'
  }

  service_args = {
      dataset: 'skymapper',
      catalogue: 'ms',
  }

  save_query_fixture('skymapper_rectangular_query_ms_2', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))

  query_args = {
      dataset: 'skymapper',
      catalogue: 'ms',
      ra_min: '1.75',
      ra_max: '2.25',
      dec_min: '-2.25',
      dec_max: '-0.75'
  }

  service_args = {
      dataset: 'skymapper',
      catalogue: 'ms',
  }

  save_query_fixture('skymapper_rectangular_query_ms_3', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))

end