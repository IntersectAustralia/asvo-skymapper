class SearchController < ApplicationController
  respond_to :html, :json

  DEFAULT_DATASET = 'skymapper'

  class SearchError < StandardError

  end

  rescue_from SearchError, with: :handle_error

  def index

  end

  def radial_search
    @results_path = radial_search_results_path

    @parameters = [
      { name: 'Right ascension:', value: params[:ra] },
      { name: 'Declination:', value: params[:dec] },
      { name: 'Radius:', value: params[:sr] }
    ]

    catalogue_fields = query_fields(DEFAULT_DATASET, params[:catalogue])
    @fields = [
      { name: 'Object Id', field: catalogue_fields[:object_id_field] },
      { name: 'Right ascension', field: catalogue_fields[:ra_field] },
      { name: 'Declination', field: catalogue_fields[:dec_field] },
      { name: 'u', field: catalogue_fields[:u_field] },
      { name: 'v', field: catalogue_fields[:v_field] },
      { name: 'g', field: catalogue_fields[:g_field] },
      { name: 'r', field: catalogue_fields[:i_field] },
      { name: 'i', field: catalogue_fields[:r_field] },
      { name: 'z', field: catalogue_fields[:z_field] },
    ]

    render 'search_results'
  end

  def radial_search_results
    fetch_search_results(QueryGenerator.method(:generate_point_query))
  end

  def fetch_search_results(query_factory)
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
        dataset: DEFAULT_DATASET,
        catalogue: args[:catalogue],
        ra: args[:ra],
        dec: args[:dec],
        sr: args[:sr]
    }

    query = query_factory.call(query_args)
    raise SearchError.new 'Invalid search arguments' unless query and query.valid?

    service_args = {
        dataset: DEFAULT_DATASET,
        catalogue: query_args[:catalogue]
    }

    service = SyncQueryService.new(service_args)
    results_table = service.fetch_results(query)
    raise SearchError.new 'Search request failed' unless results_table

    respond_with do |format|
      format.html do
        render json: { objects: results_table.table_data }, status: 200
      end
      format.json do
        render json: { objects: results_table.table_data }, status: 200
      end
    end
  rescue StandardError => error
    raise error
  end

  protected

  def query_fields(dataset, catalogue)
    Rails.application.config.asvo_registry.find_catalogue(dataset, catalogue)[:fields]
  end

  def handle_error(error)
    respond_with do |format|
      format.html do
        raise error
      end
      format.json do
        render json: { error: error.message }, status: 422
      end
    end
  end

end