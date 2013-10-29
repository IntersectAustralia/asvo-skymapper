require 'spec_helper'

describe SiapService do

  def mock_service_run(data)
    query_args = {
        dataset: data[:dataset],
        catalogue: data[:catalogue]
    }
    query_args.merge!(data[:params])

    service_args = {
        dataset: data[:dataset],
        catalogue: data[:catalogue]
    }

    # stub network post
    Net::HTTP.stub(:get).and_return(File.read(Rails.root.join("spec/fixtures/#{data[:filename]}.xml")))

    query = QueryGenerator.method(data[:method]).call(query_args)
    siap_service = SiapService.new(service_args)

    mock_results_table = YAML.load(File.read(Rails.root.join("spec/fixtures/#{data[:filename]}.vo")))

    results_table = siap_service.fetch_results(query)
    results_table.eql?(mock_results_table).should be_true
  end

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
    # stub network post
    Net::HTTP.stub(:get).and_return(File.read(Rails.root.join('spec/fixtures/skymapper_image_query_1.vo')))

    service_args = {
        dataset: 'skymapper',
        catalogue: 'image',
    }

    service = SiapService.new(service_args)

    query_args = {
        ra: '178.83871',
        dec: '-1.18844'
    }

    image_query = QueryGenerator.generate_image_query(query_args)

    service.fetch_results(image_query).should be_empty
  end

  describe 'Fetch results using' do

    query_data = [
        { type: 'image', message: 'some', dataset: 'skymapper', catalogue: 'image', params: { ra: '181.16129', dec: '-1.18844' }, filename: 'skymapper_image_query_1', method: :generate_image_query },
        { type: 'image', message: 'no', dataset: 'skymapper', catalogue: 'image', params: { ra: '178.83871', dec: '-1.18844' }, filename: 'skymapper_image_query_2', method: :generate_image_query }
    ]

    query_data.each do |data|

      it "#{data[:type]} query for dataset #{data[:dataset]} catalogue #{data[:catalogue]} returns #{data[:message]} objects" do
        mock_service_run(data)
      end

    end

  end

end