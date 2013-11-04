class SearchController < ApplicationController
  respond_to :html, :json

  DEFAULT_DATASET = 'skymapper'

  class SearchError < StandardError

  end

  rescue_from SearchError, with: :handle_error

  def index
  end

  def radial_search
    session[:search] = { type: 'radial', params: params }

    @results_path = radial_search_results_path

    @parameters = [
      { name: 'Right ascension:', value: params[:ra] },
      { name: 'Declination:', value: params[:dec] },
      { name: 'Radius:', value: params[:sr] }
    ]
    add_filter_parameters(@parameters, params)
    clean_parameters(@parameters)

    @fields = search_fields(params[:catalogue])

  rescue StandardError
    flash.now[:error] = 'The search parameters contain some errors.'
  ensure
    render 'search_results_and_details'
  end

  def rectangular_search
    session[:search] = { type: 'rectangular', params: params }

    @results_path = rectangular_search_results_path

    @parameters = [
        { name: 'Right ascension min:', value: params[:ra_min] },
        { name: 'Right ascension max:', value: params[:ra_max] },
        { name: 'Declination min:', value: params[:dec_min] },
        { name: 'Declination max:', value: params[:dec_max] }
    ]
    add_filter_parameters(@parameters, params)
    clean_parameters(@parameters)

    @fields = search_fields(params[:catalogue])

  rescue StandardError
    flash.now[:error] = 'The search parameters contain some errors.'
  ensure
    render 'search_results_and_details'
  end

  def raw_image_search
    session[:search] = { type: 'raw-image', params: params }

    @results_path = raw_image_search_results_path

    @parameters = [
        { name: 'Right ascension:', value: params[:ra] },
        { name: 'Declination:', value: params[:dec] }
    ]
    clean_parameters(@parameters)

    @fields = image_search_fields('image')

    @filters = ["rawImageOrder:[#{@fields.map { |x| "'#{x[:field]}',"}.join[0..-2]}]"]
  rescue StandardError
    flash.now[:error] = 'The search parameters contain some errors.'
  ensure
    render 'search_results_and_details'
  end

  def radial_search_results
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
        dataset: DEFAULT_DATASET,
        catalogue: args[:catalogue],
        ra: args[:ra],
        dec: args[:dec],
        sr: args[:sr],
        u_min: args[:u_min],
        u_max: args[:u_max],
        v_min: args[:v_min],
        v_max: args[:v_max],
        g_min: args[:g_min],
        g_max: args[:g_max],
        r_min: args[:r_min],
        r_max: args[:r_max],
        i_min: args[:i_min],
        i_max: args[:i_max],
        z_min: args[:z_min],
        z_max: args[:z_max]
    }

    fetch_search_results(SyncTapService, query_args, QueryGenerator.method(:generate_point_query))
  end

  def rectangular_search_results
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
        dataset: DEFAULT_DATASET,
        catalogue: args[:catalogue],
        ra_min: args[:ra_min],
        ra_max: args[:ra_max],
        dec_min: args[:dec_min],
        dec_max: args[:dec_max],
        u_min: args[:u_min],
        u_max: args[:u_max],
        v_min: args[:v_min],
        v_max: args[:v_max],
        g_min: args[:g_min],
        g_max: args[:g_max],
        r_min: args[:r_min],
        r_max: args[:r_max],
        i_min: args[:i_min],
        i_max: args[:i_max],
        z_min: args[:z_min],
        z_max: args[:z_max]
    }

    fetch_search_results(SyncTapService, query_args, QueryGenerator.method(:generate_rectangular_query))
  end

  def raw_image_search_results
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
        dataset: DEFAULT_DATASET,
        catalogue: 'image',
        ra: args[:ra],
        dec: args[:dec]
    }

    fetch_search_results(SiapService, query_args, QueryGenerator.method(:generate_image_query))
  end

  def radial_search_details
    [:action, :id].each { |p| params.delete(p) }
    redirect_to radial_search_path(params)
  end

  def rectangular_search_details
    [:action, :id].each { |p| params.delete(p) }
    redirect_to rectangular_search_path(params)
  end

  def raw_image_search_details
    [:action, :id].each { |p| params.delete(p) }
    redirect_to raw_image_search_path(params)
  end

  # HELPERS

  def fetch_search_results(service, query_args, query_factory)
    query = query_factory.call(query_args)
    raise SearchError.new 'Invalid search arguments' unless query and query.valid?

    service_args = {
        dataset: DEFAULT_DATASET,
        catalogue: query_args[:catalogue]
    }

    service = service.new(service_args)
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

  def search_fields(catalogue)
    catalogue_fields = query_fields(DEFAULT_DATASET, catalogue, 'tap')
    [
        { name: catalogue_fields[:object_id_field][:name], field: catalogue_fields[:object_id_field][:field], type: :show_detail, class: 'detail-link' },
        { name: catalogue_fields[:ra_field][:name], field: catalogue_fields[:ra_field][:field] },
        { name: catalogue_fields[:dec_field][:name], field: catalogue_fields[:dec_field][:field] },
        { name: catalogue_fields[:u_field][:name], field: catalogue_fields[:u_field][:field] },
        { name: catalogue_fields[:v_field][:name], field: catalogue_fields[:v_field][:field] },
        { name: catalogue_fields[:g_field][:name], field: catalogue_fields[:g_field][:field] },
        { name: catalogue_fields[:r_field][:name], field: catalogue_fields[:r_field][:field] },
        { name: catalogue_fields[:i_field][:name], field: catalogue_fields[:i_field][:field] },
        { name: catalogue_fields[:z_field][:name], field: catalogue_fields[:z_field][:field] }
    ]
  end

  def image_search_fields(catalogue)
    catalogue_fields = query_fields(DEFAULT_DATASET, catalogue, 'siap')
    [
        { name: catalogue_fields[:ra_field][:name], field: catalogue_fields[:ra_field][:field] },
        { name: catalogue_fields[:dec_field][:name], field: catalogue_fields[:dec_field][:field] },
        { name: catalogue_fields[:filter_field][:name], field: catalogue_fields[:filter_field][:field] },
        { name: catalogue_fields[:survey_field][:name], field: catalogue_fields[:survey_field][:field] },
        { name: catalogue_fields[:observation_date_field][:name], field: catalogue_fields[:observation_date_field][:field] },
        { name: catalogue_fields[:image_url][:name], field: catalogue_fields[:image_url][:field], type: :download_image, class: 'image-link' }
    ]
  end

  def add_filter_parameters(parameters, params)
    add_parameter(parameters, params, 'U min:', :u_min)
    add_parameter(parameters, params, 'U max:', :u_max)
    add_parameter(parameters, params, 'V min:', :v_min)
    add_parameter(parameters, params, 'V max:', :v_max)
    add_parameter(parameters, params, 'G min:', :g_min)
    add_parameter(parameters, params, 'G max:', :g_max)
    add_parameter(parameters, params, 'R min:', :r_min)
    add_parameter(parameters, params, 'R max:', :r_max)
    add_parameter(parameters, params, 'I min:', :i_min)
    add_parameter(parameters, params, 'I max:', :i_max)
    add_parameter(parameters, params, 'Z min:', :z_min)
    add_parameter(parameters, params, 'Z max:', :z_max)
  end

  def clean_parameters(parameters)
    parameters.each do |p|
      p[:value] = p[:value].gsub(/\s/, '') if p[:value]
    end
  end

  protected

  def add_parameter(parameters, params, name, field)
    parameters.push({ name: name, value: params[field] }) if params[field]
  end

  def query_fields(dataset, catalogue, service)
    Rails.application.config.asvo_registry.find_service(dataset, catalogue, service)[:fields]
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