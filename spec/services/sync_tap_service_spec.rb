require 'spec_helper'

describe SyncTapService do

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

    # mock network response
    mock_res = double('Net::HTTPResponse')
    mock_res.should_receive(:body).and_return(File.read(Rails.root.join("spec/fixtures/#{data[:filename]}.xml")))

    # stub network post
    Net::HTTP.stub(:post_form).and_return(mock_res)

    query = QueryGenerator.method(data[:method]).call(query_args)
    tap_service = SyncTapService.new(service_args)

    mock_results_table = YAML.load(File.read(Rails.root.join("spec/fixtures/#{data[:filename]}.vo")))

    results_table = tap_service.fetch_results(query)
    results_table.eql?(mock_results_table).should be_true
  end

  def mock_filter_run(data)
    service = Rails.application.config.asvo_registry.find_service(data[:dataset], data[:catalogue], 'tap')
    fields = service[:fields]

    filtered_results_table = YAML.load(File.read(Rails.root.join("spec/fixtures/#{data[:filename]}.vo")))
    filtered_results_table.table_data.each do |obj|

      data[:filters].each do |filter|

        obj[fields[filter.to_sym][:field]].should_not be_nil
        (data[:params]["#{filter}_min".to_sym] or data[:params]["#{filter}_max".to_sym]).should be_true

        obj[fields[filter.to_sym][:field]].to_f.should >= data[:params]["#{filter}_min".to_sym].to_f if data[:params]["#{filter}_min".to_sym]
        obj[fields[filter.to_sym][:field]].to_f.should <= data[:params]["#{filter}_max".to_sym].to_f if data[:params]["#{filter}_max".to_sym]

      end
    end
  end

  it 'Fetch request is valid' do
    registry = Rails.application.config.asvo_registry
    service = registry.find_service('skymapper', 'fs', 'tap')

    service_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
    }

    tap_service = SyncTapService.new(service_args)
    tap_service.request == URI("#{service[:service_end_point]}/sync")
  end

  it 'Raises error if failed to get response' do
    # stub network post
    Net::HTTP.stub(:post_form).and_raise(Exception)

    service_args = {
        dataset: 'skymapper',
        catalogue: 'fs',
    }

    tap_service = SyncTapService.new(service_args)

    query_args = {
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }

    point_query = QueryGenerator.generate_point_query(query_args)

    tap_service.fetch_results(point_query).should be_nil
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

    tap_service = SyncTapService.new(service_args)

    query_args = {
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
    }

    point_query = QueryGenerator.generate_point_query(query_args)

    tap_service.fetch_results(point_query).should be_empty
  end

  describe 'Fetch results using' do

    query_data = [
        { type: 'point', message: 'less than 1000', dataset: 'skymapper', catalogue: 'fs', params: { ra: '178.83871', dec: '-1.18844', sr: '0.5' }, filename: 'skymapper_point_query_fs_1', method: :generate_point_query },
        { type: 'point', message: 'no', dataset: 'skymapper', catalogue: 'fs', params: { ra: '1', dec: '1', sr: '1' }, filename: 'skymapper_point_query_fs_2', method: :generate_point_query },
        { type: 'point', message: 'exactly 1000', dataset: 'skymapper', catalogue: 'fs', params: { ra: '178.83871', dec: '-1.18844', sr: '2' }, filename: 'skymapper_point_query_fs_3', method: :generate_point_query },
        { type: 'point', message: 'less than 1000', dataset: 'skymapper', catalogue: 'ms', params: { ra: '178.83871', dec: '-1.18844', sr: '0.15' }, filename: 'skymapper_point_query_ms_1', method: :generate_point_query },
        { type: 'point', message: 'no', dataset: 'skymapper', catalogue: 'ms', params: { ra: '1', dec: '1', sr: '1' }, filename: 'skymapper_point_query_ms_2', method: :generate_point_query },
        { type: 'point', message: 'exactly 1000', dataset: 'skymapper', catalogue: 'ms', params: { ra: '178.83871', dec: '-1.18844', sr: '0.5' }, filename: 'skymapper_point_query_ms_3', method: :generate_point_query },

        { type: 'rectangular', message: 'less than 1000', dataset: 'skymapper', catalogue: 'fs', params: { ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75' }, filename: 'skymapper_rectangular_query_fs_1', method: :generate_rectangular_query },
        { type: 'rectangular', message: 'no', dataset: 'skymapper', catalogue: 'fs', params: { ra_min: '1', ra_max: '1.1', dec_min: '1', dec_max: '1.1' }, filename: 'skymapper_rectangular_query_fs_2', method: :generate_rectangular_query },
        { type: 'rectangular', message: 'exactly 1000', dataset: 'skymapper', catalogue: 'fs', params: { ra_min: '0', ra_max: '10', dec_min: '-2.25', dec_max: '-0.75' }, filename: 'skymapper_rectangular_query_fs_3', method: :generate_rectangular_query },
        { type: 'rectangular', message: 'less than 1000', dataset: 'skymapper', catalogue: 'ms', params: { ra_min: '1.975', ra_max: '2.025', dec_min: '-1.525', dec_max: '-1.475' }, filename: 'skymapper_rectangular_query_ms_1', method: :generate_rectangular_query },
        { type: 'rectangular', message: 'no', dataset: 'skymapper', catalogue: 'ms', params: { ra_min: '1', ra_max: '1.1', dec_min: '1', dec_max: '1.1' }, filename: 'skymapper_rectangular_query_ms_2', method: :generate_rectangular_query },
        { type: 'rectangular', message: 'exactly 1000', dataset: 'skymapper', catalogue: 'ms', params: { ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75' }, filename: 'skymapper_rectangular_query_ms_3', method: :generate_rectangular_query },

        { type: 'bulk catalogue', message: 'exactly 5', dataset: 'skymapper', catalogue: 'fs', params: {file: Rails.root.join('spec/fixtures/skymapper_bulk_valid_1.csv'), sr: 0.05 }, filename: 'skymapper_bulk_catalogue_query_fs_1', method: :generate_bulk_catalogue_query },
        { type: 'bulk catalogue', message: 'no', dataset: 'skymapper', catalogue: 'fs', params: {file: Rails.root.join('spec/fixtures/skymapper_bulk_valid_3.csv'), sr: 0.05 }, filename: 'skymapper_bulk_catalogue_query_fs_2', method: :generate_bulk_catalogue_query },
        { type: 'bulk catalogue', message: 'exactly 106', dataset: 'skymapper', catalogue: 'ms', params: {file: Rails.root.join('spec/fixtures/skymapper_bulk_valid_1.csv'), sr: 0.05 }, filename: 'skymapper_bulk_catalogue_query_ms_1', method: :generate_bulk_catalogue_query },
        { type: 'bulk catalogue', message: 'no', dataset: 'skymapper', catalogue: 'ms', params: {file: Rails.root.join('spec/fixtures/skymapper_bulk_valid_3.csv'), sr: 0.05 }, filename: 'skymapper_bulk_catalogue_query_ms_2', method: :generate_bulk_catalogue_query }
    ]

    query_data.each do |data|

      it "#{data[:type]} query for dataset #{data[:dataset]} catalogue #{data[:catalogue]} returns #{data[:message]} objects" do
        mock_service_run(data)
      end

    end

  end

  describe 'Fetch results using' do
    filter_query_data = []

    %w[u v g r i z].each do |filter|

      filter_query_data = filter_query_data.concat [
          { type: 'point', message: "min filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'fs', params: { ra: '178.83871', dec: '-1.18844', sr: '0.5', "#{filter}_min" => '50' }.symbolize_keys, filename: "skymapper_point_query_fs_#{filter}_filter_1", method: :generate_point_query },
          { type: 'point', message: "max filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'fs', params: { ra: '178.83871', dec: '-1.18844', sr: '0.5', "#{filter}_max" => '1000' }.symbolize_keys, filename: "skymapper_point_query_fs_#{filter}_filter_2", method: :generate_point_query },
          { type: 'point', message: "min and max filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'fs', params: { ra: '178.83871', dec: '-1.18844', sr: '0.5', "#{filter}_min" => '50', "#{filter}_max" => '1000' }.symbolize_keys, filename: "skymapper_point_query_fs_#{filter}_filter_3", method: :generate_point_query },
          { type: 'point', message: "min filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'ms', params: { ra: '178.83871', dec: '-1.18844', sr: '0.15', "#{filter}_min" => '0.1' }.symbolize_keys, filename: "skymapper_point_query_ms_#{filter}_filter_1", method: :generate_point_query },
          { type: 'point', message: "max filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'ms', params: { ra: '178.83871', dec: '-1.18844', sr: '0.15', "#{filter}_max" => '1' }.symbolize_keys, filename: "skymapper_point_query_ms_#{filter}_filter_2", method: :generate_point_query },
          { type: 'point', message: "min and max filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'ms', params: { ra: '178.83871', dec: '-1.18844', sr: '0.15', "#{filter}_min" => '0.1', "#{filter}_max" => '1' }.symbolize_keys, filename: "skymapper_point_query_ms_#{filter}_filter_3", method: :generate_point_query },

          { type: 'rectangular', message: "min filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'fs', params: { ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75', "#{filter}_min" => '50' }.symbolize_keys, filename: "skymapper_rectangular_query_fs_#{filter}_filter_1", method: :generate_rectangular_query },
          { type: 'rectangular', message: "max filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'fs', params: { ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75', "#{filter}_max" => '500' }.symbolize_keys, filename: "skymapper_rectangular_query_fs_#{filter}_filter_2", method: :generate_rectangular_query },
          { type: 'rectangular', message: "min and max filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'fs', params: { ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75', "#{filter}_min" => '50', "#{filter}_max" => '500' }.symbolize_keys, filename: "skymapper_rectangular_query_fs_#{filter}_filter_3", method: :generate_rectangular_query },
          { type: 'rectangular', message: "min filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'ms', params: { ra_min: '1.975', ra_max: '2.025', dec_min: '-1.525', dec_max: '-1.475', "#{filter}_min" => '0.1' }.symbolize_keys, filename: "skymapper_rectangular_query_ms_#{filter}_filter_1", method: :generate_rectangular_query },
          { type: 'rectangular', message: "max filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'ms', params: { ra_min: '1.975', ra_max: '2.025', dec_min: '-1.525', dec_max: '-1.475', "#{filter}_max" => '1' }.symbolize_keys, filename: "skymapper_rectangular_query_ms_#{filter}_filter_2", method: :generate_rectangular_query },
          { type: 'rectangular', message: "min and max filter #{filter}", filters: [filter], dataset: 'skymapper', catalogue: 'ms', params: { ra_min: '1.975', ra_max: '2.025', dec_min: '-1.525', dec_max: '-1.475', "#{filter}_min" => '0.1', "#{filter}_max" => '1' }.symbolize_keys, filename: "skymapper_rectangular_query_ms_#{filter}_filter_3", method: :generate_rectangular_query }
      ]

    end

    filter_query_data.each do |data|

      it "#{data[:type]} query for dataset #{data[:dataset]} catalogue #{data[:catalogue]} with #{data[:message]}" do
        mock_service_run(data)
        mock_filter_run(data)
      end

    end

  end

  describe 'Fetch query results for skymapper catalogue using all filters' do

    filter_all_query_data = [
        { type: 'point', filters: %w[u v g r i z], dataset: 'skymapper', catalogue: 'fs', params: { ra: '178.83871', dec: '-1.18844', sr: '0.5' }, filename: 'skymapper_point_query_fs_filter_all', method: :generate_point_query },
        { type: 'point', filters: %w[u v g r i z], dataset: 'skymapper', catalogue: 'ms', params: { ra: '178.83871', dec: '-1.18844', sr: '0.15' }, filename: 'skymapper_point_query_ms_filter_all', method: :generate_point_query },
        { type: 'rectangular', filters: %w[u v g r i z], dataset: 'skymapper', catalogue: 'fs', params: { ra_min: '1.75', ra_max: '2.25', dec_min: '-2.25', dec_max: '-0.75' }, filename: 'skymapper_rectangular_query_fs_filter_all', method: :generate_rectangular_query },
        { type: 'rectangular', filters: %w[u v g r i z], dataset: 'skymapper', catalogue: 'ms', params: { ra_min: '1.975', ra_max: '2.025', dec_min: '-1.525', dec_max: '-1.475' }, filename: 'skymapper_rectangular_query_ms_filter_all', method: :generate_rectangular_query }
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

    filter_all_query_data.each do |data|

      it "#{data[:type]} query for dataset #{data[:dataset]} catalogue #{data[:catalogue]} with all filters" do
        mock_service_run(data)
        mock_filter_run(data)
      end

    end

  end

end