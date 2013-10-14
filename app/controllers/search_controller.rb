class SearchController < ApplicationController
  respond_to :html, :json

  DEFAULT_DATASET = :skymapper

  class SearchError < StandardError

  end

  rescue_from SearchError, with: :handle_error

  def index

  end

  def radial_search
    do_search(QueryGenerator.method(:generate_point_query))
  end

  def do_search(query_factory)
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
        dataset: DEFAULT_DATASET,
        catalogue: args[:catalogue].to_sym,
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
    results = service.fetch_results(query)
    raise SearchError.new 'Search request failed' unless results

    respond_with do |format|
      format.html do
        render json: { objects: results.table_data }, status: 200
      end
      format.json do
        render json: { objects: results.table_data }, status: 200
      end
    end
  rescue StandardError => error
    raise error
  end

  protected

  def handle_error(error)
    respond_with do |format|
      format.html do
        render json: { error: error.message }, status: 422
      end
      format.json do
        render json: { error: error.message }, status: 422
      end
    end
    #raise error
  end

end