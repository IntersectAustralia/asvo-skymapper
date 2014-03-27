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

    @fields = search_fields(params[:catalogue], 'tap')
    @async = params[:async] == "true"
    @query_path = radial_query_path
  rescue StandardError
    flash.now[:error] = 'The search parameters contain some errors.'
  ensure
    render 'search_results_and_details' unless @async
    async_job_start :generate_point_query if @async
  end

  def async_job_start (method)
    params[:limit] = 'unlimited'
    query = QueryGenerator.method(method).call(params)
    raise SearchError.new 'Invalid search arguments' unless query and query.valid?

    service_args = {
        dataset: DEFAULT_DATASET,
        catalogue: params[:catalogue]
    }
    service = AsyncTapService.new(service_args)
    job = service.start_async_job(query, params[:format], params[:email])

    if !job.nil?
      Notifier.job_scheduled_notification("#{request.base_url}#{job_details_view_path}?id=#{job.job_id}", "#{job.email}").deliver
      redirect_to :controller => 'job_details', :action => 'view', :id => job.job_id
    end

    render 'index' if job.nil?
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

    @fields = search_fields(params[:catalogue], 'tap')
    @async = params[:async] == "true"
    @query_path = rectangular_query_path
  rescue StandardError
    flash.now[:error] = 'The search parameters contain some errors.'
  ensure
    render 'search_results_and_details' unless @async
    async_job_start :generate_rectangular_query if @async
  end

  def raw_image_search
    session[:search] = { type: 'raw-image', params: params }

    @results_path = raw_image_search_results_path

    @parameters = [
        { name: 'Right ascension:', value: params[:ra] },
        { name: 'Declination:', value: params[:dec] }
    ]
    clean_parameters(@parameters)

    @fields = search_fields('image', 'siap')

    @filters = ["rawImageOrder:[#{@fields.map { |x| "'#{x[:field]}',"}.join[0..-2]}]"]
  rescue StandardError
    flash.now[:error] = 'The search parameters contain some errors.'
  ensure
    render 'search_results_and_details'
  end

  def bulk_catalogue_validate
    clone_params = params.clone
    clone_params.delete(:file)
    session[:search] = { type: 'bulk-catalogue', params: clone_params }

    query_args = {
        file: params[:file].tempfile.path,
        sr: params[:sr]
    }
    query = QueryGenerator.generate_bulk_catalogue_query(query_args)
    raise SearchError.new 'Invalid search arguments' unless query

    if query.valid?
      create_temp_file(params[:file].tempfile)

      args = {
          catalogue: params[:catalogue],
          type: params[:type],
          sr: params[:sr],
          async: params[:async] == "on",
          file: params[:file].tempfile.path,
          email: params[:email],
          format: params[:type]

      }

      redirect_to bulk_catalogue_search_path(args)
    else
      raise SearchError.new 'Invalid search arguments' if query.errors.messages[:sr]

      @bulk_catalogue_errors = query.errors.messages[:file] # print file errors to page

      render 'index'
    end
  rescue StandardError
    flash.now[:error] = 'The search parameters contain some errors.'

    render 'download_results'
  end

  def bulk_catalogue_search
    @query_path = bulk_catalogue_query_path


  rescue StandardError
    flash.now[:error] = 'The search parameters contain some errors.'
  ensure
    render 'download_results' unless params[:async]=="true"
    async_job_start :generate_bulk_catalogue_query if params[:async] == "true"

  end

  def bulk_image_validate
    clone_params = params.clone
    clone_params.delete(:file)
    session[:search] = { type: 'bulk-image', params: clone_params }

    query_args = {
        file: params[:file].tempfile.path
    }

    query = QueryGenerator.generate_bulk_image_query(query_args)
    raise SearchError.new 'Invalid search arguments' unless query

    if query.valid?
      create_temp_file(params[:file].tempfile)

      redirect_to bulk_image_search_path
    else
      @bulk_image_errors = query.errors.messages[:file]

      render 'index'
    end
  rescue StandardError
    flash.now[:error] = 'The search parameters contain some errors.'

    render 'search_results_and_details'
  end

  def bulk_image_search
    session[:search][:progress_file] = generate_filepath # generate temp path to store search progress

    @results_path = bulk_image_search_results_path
    @progress_path = bulk_image_search_progress_path

    @fields = search_fields('image', 'siap')

    @filters = ["rawImageOrder:[#{@fields.map { |x| "'#{x[:field]}',"}.join[0..-2]}]"]
  rescue StandardError
    flash.now[:error] = 'The search parameters contain some errors.'
  ensure
    render 'search_results_and_details'
  end

  def radial_query
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
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
        z_max: args[:z_max],
        limit: false
    }

    query = QueryGenerator.method(:generate_point_query).call(query_args)
    raise SearchError.new 'Invalid search arguments' unless query and query.valid?

    service_args = {
        dataset: DEFAULT_DATASET,
        catalogue: args[:catalogue]
    }

    service = SyncTapService.new(service_args)
    request = {
        url: service.request.to_s,
        query: service.get_raw_query(query)
    }

    render json: request
  end

  def rectangular_query
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
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
        z_max: args[:z_max],
        limit: false
    }

    query = QueryGenerator.method(:generate_rectangular_query).call(query_args)
    raise SearchError.new 'Invalid search arguments' unless query and query.valid?

    service_args = {
        dataset: DEFAULT_DATASET,
        catalogue: args[:catalogue]
    }

    service = SyncTapService.new(service_args)
    request = {
        url: service.request.to_s,
        query: service.get_raw_query(query)
    }

    render json: request
  end

  def bulk_catalogue_query
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
        file: get_temp_file,
        sr: args[:sr]
    }

    query = QueryGenerator.method(:generate_bulk_catalogue_query).call(query_args)
    raise SearchError.new 'Invalid search arguments' unless query and query.valid?

    service_args = {
        dataset: DEFAULT_DATASET,
        catalogue: args[:catalogue]
    }

    service = SyncTapService.new(service_args)
    request = {
        url: service.request.to_s,
        query: service.get_raw_query(query),
        type: args[:type]
    }

    render json: request
  end

  def radial_search_results
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
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

    fetch_search_results(SyncTapService, query_args, QueryGenerator.method(:generate_point_query), params[:query][:catalogue])
  end

  def rectangular_search_results
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
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

    fetch_search_results(SyncTapService, query_args, QueryGenerator.method(:generate_rectangular_query), params[:query][:catalogue])
  end

  def raw_image_search_results
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
        ra: args[:ra],
        dec: args[:dec]
    }

    fetch_search_results(SiapService, query_args, QueryGenerator.method(:generate_image_query), 'image')
  end

  def bulk_image_search_results
    args = params[:query]
    raise SearchError.new 'Invalid search arguments' unless args

    query_args = {
        file: get_temp_file
    }

    query = QueryGenerator.generate_bulk_image_query(query_args)
    raise SearchError.new 'Invalid search arguments' unless query and query.valid?

    # repeat raw image search using point in csv file

    total_table_data = []

    points = query.to_points
    points.each_with_index do |point, index|
      progress = { 'current' => index + 1, 'total' => points.size }
      write_progress(session[:search][:progress_file], progress)

      query_args = {
          ra: point[:ra],
          dec: point[:dec]
      }

      query = QueryGenerator.generate_image_query(query_args)
      raise SearchError.new 'Invalid search arguments' unless query and query.valid?

      service_args = {
          dataset: DEFAULT_DATASET,
          catalogue: 'image'
      }

      service = SiapService.new(service_args)
      results_table = service.fetch_results(query)
      raise SearchError.new 'Search request failed' unless results_table

      results_table.table_data.each do |data|
        total_table_data << data unless total_table_data.include? data
      end
    end

    respond_with do |format|
      format.html do
        render json: { objects: total_table_data }, status: 200
      end
      format.json do
        render json: { objects: total_table_data }, status: 200
      end
    end
  rescue StandardError => error
    raise error
  end

  def bulk_image_search_progress
    progress = read_progress(session[:search][:progress_file])

    return render json: { message: "Fetching results..." } unless progress

    render json: { message: "Fetching results... completed #{progress['current']} of #{progress['total']} points" }
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

  def fetch_search_results(service, query_args, query_factory, catalogue)
    query = query_factory.call(query_args)
    raise SearchError.new 'Invalid search arguments' unless query and query.valid?

    service_args = {
        dataset: DEFAULT_DATASET,
        catalogue: catalogue
    }

    service = service.new(service_args)
    results_table = service.fetch_results(query)
    if !results_table.nil? and !results_table.query_status.nil? and results_table.query_status != 'OK'
      raise SearchError.new "There was an error while running query: '#{results_table.query_status_description}'. Please try again later"
    end

    raise SearchError.new 'There was an error fetching the results.' unless results_table
    #raise error if there was error in search
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

  def search_fields(catalogue, service)
    Rails.application.config.asvo_registry.find_service(DEFAULT_DATASET, catalogue, service)[:fields].to_a.map { |field| field.second }
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
      p[:value] = p[:value].gsub(/^\+/, '') if p[:value]
      p[:value] = p[:value].gsub(/^(-)?0+(0|\d+)(\.)/, '\1\2\3') if p[:value]
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
        render json: { error: error.message }, status: 422
      end
      format.json do
        render json: { error: error.message }, status: 422
      end
    end
  end

  def create_temp_file(file)
    FileUtils.rm session[:temp_file] if session[:temp_file] and File.file? session[:temp_file]
    path = generate_filepath
    File.write(path, file.read)
    session[:temp_file] = path
  end

  def get_temp_file
    session[:temp_file]
  end

  def generate_filepath
    temp_file = Tempfile.new('temp')
    path = temp_file.path
    temp_file.close
    temp_file.unlink

    path
  end

  def write_progress(file, progress)
    File.write(file, progress.to_json) if file
  end

  def read_progress(file)
    JSON.parse(File.read(file)) if File.file? file
  end

end