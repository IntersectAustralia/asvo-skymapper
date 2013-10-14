require 'spec_helper'

describe SyncQueryService do

  it 'Fetch results uses synchronous request' do
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue(:skymapper, :fs)

    service_args = {
        dataset: :skymapper,
        catalogue: :fs,
    }

    service = SyncQueryService.new(service_args)
    service.request == URI("#{catalogue[:service_end_point]}/sync")
  end

  it 'Fetch point query results for skymapper catalogue fs' do
    # mock network response
    mock_res = double('Net::HTTPResponse')
    mock_res.should_receive(:body).and_return(File.read(Rails.root.join('spec/fixtures/skymapper_point_query_1.xml')))

    # stub network post
    Net::HTTP.stub(:post_form).and_return(mock_res)

    service_args = {
        dataset: :skymapper,
        catalogue: :fs,
    }

    service = SyncQueryService.new(service_args)

    query_args = {
        dataset: :skymapper,
        catalogue: :fs,
        ra: 62.70968,
        dec: -1.18844,
        sr: 0.5
    }

    point_query = QueryGenerator.generate_point_query(query_args)

    mock_results_table = YAML.load(File.read(Rails.root.join('spec/fixtures/skymapper_point_query_results_1.vo')))

    results_table = service.fetch_results(point_query)
    results_table.eql?(mock_results_table).should be_true
  end

  it 'Fetch point query results for skymapper cataglogue fs returns no matches' do
    pending("getting proper test data")
  end

  it 'Fetch point query results for skymapper cataglogue fs returns maximum of 1000 matches' do
    pending("getting proper test data")
  end

  it 'Raises error if failed to get response' do
    # stub network post
    Net::HTTP.stub(:post_form).and_raise(Exception)

    service_args = {
        dataset: :skymapper,
        catalogue: :fs,
    }

    service = SyncQueryService.new(service_args)

    query_args = {
        dataset: :skymapper,
        catalogue: :fs,
        ra: 62.70968,
        dec: -1.18844,
        sr: 0.5
    }

    point_query = QueryGenerator.generate_point_query(query_args)

    service.fetch_results(point_query).should be_nil
  end

  it 'Raises error if response is garbage' do
    # mock network response
    mock_res = double('Net::HTTPResponse')
    mock_res.should_receive(:body).and_return(File.read(Rails.root.join('spec/fixtures/skymapper_point_query_results_1.vo')))

    # stub network post
    Net::HTTP.stub(:post_form).and_return(mock_res)

    service_args = {
        dataset: :skymapper,
        catalogue: :fs,
    }

    service = SyncQueryService.new(service_args)

    query_args = {
        dataset: :skymapper,
        catalogue: :fs,
        ra: 62.70968,
        dec: -1.18844,
        sr: 0.5
    }

    point_query = QueryGenerator.generate_point_query(query_args)

    service.fetch_results(point_query).should be_empty
  end

end