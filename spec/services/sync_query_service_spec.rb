require 'spec_helper'

describe SyncQueryService do

  def mock_service_run(filename, query_args, service_args, factory)
    # mock network response
    mock_res = double('Net::HTTPResponse')
    mock_res.should_receive(:body).and_return(File.read(Rails.root.join("spec/fixtures/#{filename}.xml")))

    # stub network post
    Net::HTTP.stub(:post_form).and_return(mock_res)

    point_query = factory.call(query_args)
    service = SyncQueryService.new(service_args)

    mock_results_table = YAML.load(File.read(Rails.root.join("spec/fixtures/#{filename}.vo")))

    results_table = service.fetch_results(point_query)
    results_table.eql?(mock_results_table).should be_true
  end

  it 'Fetch results uses synchronous request' do
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue('skymapper', 'fs')

    service_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
    }

    service = SyncQueryService.new(service_args)
    service.request == URI("#{catalogue[:service_end_point]}/sync")
  end

  it 'Fetch point query results for skymapper catalogue fs' do
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

    mock_service_run('skymapper_point_query_fs_1', query_args, service_args, QueryGenerator.method(:generate_point_query))
  end

  it 'Fetch point query results for skymapper cataglogue fs returns no matches' do
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

    mock_service_run('skymapper_point_query_fs_2', query_args, service_args, QueryGenerator.method(:generate_point_query))
  end

  it 'Fetch point query results for skymapper cataglogue fs returns maximum of 1000 matches' do
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

    mock_service_run('skymapper_point_query_fs_3', query_args, service_args, QueryGenerator.method(:generate_point_query))
  end

  it 'Fetch point query results for skymapper catalogue ms' do
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

    mock_service_run('skymapper_point_query_ms_1', query_args, service_args, QueryGenerator.method(:generate_point_query))
  end

  it 'Fetch point query results for skymapper cataglogue ms returns no matches' do
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

    mock_service_run('skymapper_point_query_ms_2', query_args, service_args, QueryGenerator.method(:generate_point_query))
  end

  it 'Fetch point query results for skymapper cataglogue ms returns maximum of 1000 matches' do
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

    mock_service_run('skymapper_point_query_ms_3', query_args, service_args, QueryGenerator.method(:generate_point_query))
  end

  it 'Fetch rectangular query results for skymapper catalogue fs' do
    query_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra_min: '178.83871',
        ra_max: '-1.18844',
        dec_min: '0.5',
        dec_max: '0.5'
    }

    service_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
    }

    mock_service_run('skymapper_rectangular_query_fs_1', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))
  end

  it 'Fetch rectangular query results for skymapper cataglogue fs returns no matches' do
    query_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra_min: '11',
        ra_max: '1',
        dec_min: '1',
        dec_max: '1'
    }

    service_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
    }

    mock_service_run('skymapper_rectangular_query_fs_2', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))
  end

  it 'Fetch rectangular query results for skymapper cataglogue fs returns maximum of 1000 matches' do
    query_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra_min: '178.83871',
        ra_max: '-1.18844',
        dec_min: '0.5',
        dec_max: '0.5'
    }

    service_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
    }

    mock_service_run('skymapper_rectangular_query_fs_3', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))
  end

  it 'Fetch rectangular query results for skymapper catalogue ms' do
    query_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra_min: '178.83871',
        ra_max: '-1.18844',
        dec_min: '0.5',
        dec_max: '0.5'
    }

    service_args = {
        dataset: 'skymapper',
        catalogue: 'ms',
    }

    mock_service_run('skymapper_rectangular_query_ms_1', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))
  end

  it 'Fetch rectangular query results for skymapper cataglogue ms returns no matches' do
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
        catalogue: 'ms',
    }

    mock_service_run('skymapper_rectangular_query_ms_2', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))
  end

  it 'Fetch rectangular query results for skymapper cataglogue ms returns maximum of 1000 matches' do
    query_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra_min: '178.83871',
        ra_max: '-1.18844',
        dec_min: '0.5',
        dec_max: '0.5'
    }

    service_args = {
        dataset: 'skymapper',
        catalogue: 'ms',
    }

    mock_service_run('skymapper_rectangular_query_ms_3', query_args, service_args, QueryGenerator.method(:generate_rectangular_query))
  end

  it 'Raises error if failed to get response' do
    # stub network post
    Net::HTTP.stub(:post_form).and_raise(Exception)

    service_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
    }

    service = SyncQueryService.new(service_args)

    query_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }

    point_query = QueryGenerator.generate_point_query(query_args)

    service.fetch_results(point_query).should be_nil
  end

  it 'Raises error if response is garbage' do
    # mock network response
    mock_res = double('Net::HTTPResponse')
    mock_res.should_receive(:body).and_return(File.read(Rails.root.join('spec/fixtures/skymapper_point_query_fs_1.vo')))

    # stub network post
    Net::HTTP.stub(:post_form).and_return(mock_res)

    service_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
    }

    service = SyncQueryService.new(service_args)

    query_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }

    point_query = QueryGenerator.generate_point_query(query_args)

    service.fetch_results(point_query).should be_empty
  end

end