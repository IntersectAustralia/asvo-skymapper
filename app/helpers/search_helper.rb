module SearchHelper

  def session_param(type, param, default = nil)
    return session[:search][:params][param] if session[:search] and session[:search][:type] == type
    default
  end

  def split_fields_by_group(fields)
    table_fields = {}
    fields.each do |field|
      group = field[:group] ? field[:group] : 'none'
      table_fields[group] ||= []
      table_fields[group] << field
    end
    table_fields
  end
  
  def get_tap_download_limit_msg
    result = ''
    begin
      limit = get_tap_download_limit
      result = "The upper limit for results downloaded via the TAP service is #{limit} results."
    rescue Exception => e
      result = "There is a larger upper limit for results downloaded via the TAP service."
    end
  end

  private

  def get_tap_download_limit
    # NOTE: 'catalogue' is not used, but is required to get the endpoint URL
    service_args = {dataset: SearchController::DEFAULT_DATASET, catalogue: 'fs'}
    service = SyncTapService.new(service_args)
    capabilities = service.get_capabilities
    doc = Nokogiri::XML(capabilities)
    result = doc.xpath '//outputLimit/hard/text()'
    raise "No capabilities returned from service" if result.empty?
    result
  end

end
