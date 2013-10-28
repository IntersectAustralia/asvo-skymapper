require 'spec_helper'

describe SiapService do

  it 'Fetch request is valid' do
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue('skymapper', 'image')

    service_args = {
        dataset: 'skymapper',
        catalogue: 'image',
    }

    service = SiapService.new(service_args)
    service.request == URI("#{catalogue[:service_end_point]}")
  end

  it 'Raises error if failed to get response' do
    # stub network post
    Net::HTTP.stub(:get).and_raise(Exception)

    service_args = {
        dataset: 'skymapper',
        catalogue: 'image',
    }

    siap_service = SiapService.new(service_args)

    query_args = {
        ra: '178.83871',
        dec: '-1.18844'
    }

    image_query = QueryGenerator.generate_image_query(query_args)

    siap_service.fetch_results(image_query).should be_nil
  end

  it 'Raises error if response is garbage' do
    # mock network response
    mock_res = double('Net::HTTPResponse')
    mock_res.should_receive(:body).and_return(File.read(Rails.root.join('spec/fixtures/skymapper_point_query_fs_1.vo')))

    # stub network post
    Net::HTTP.stub(:get).and_return(mock_res)

    service_args = {
        dataset: 'skymapper',
        catalogue: 'image',
    }

    service = SiapService.new(service_args)

    query_args = {
        ra: '178.83871',
        dec: '-1.18844'
    }

    point_query = QueryGenerator.generate_image_query(query_args)

    service.fetch_results(point_query).should be_empty
  end

end