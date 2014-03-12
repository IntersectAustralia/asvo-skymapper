require 'net/http'

class SyncTapService

  def initialize(args)
    @dataset = args[:dataset]
    @catalogue = args[:catalogue]
  end

  def request
    registry = Rails.application.config.asvo_registry
    service = registry.find_service(@dataset, @catalogue, 'tap')

    uri = URI("#{service[:service_end_point]}/sync")
    uri
  end

  def fetch_results(query)
    begin
      res = fetch_query_response(query)
      p "###########"
      p res.body
      p "###########"
      results_table = VOTableParser.parse_xml(res.body)
    rescue Exception
      puts $!.inspect, $@ unless Rails.env == 'test'
    end

    results_table
  end

  def fetch_query_response(query)
    registry = Rails.application.config.asvo_registry
    service = registry.find_service(@dataset, @catalogue, 'tap')

    form = {
        request: 'doQuery',
        lang: 'ADQL',
        query: query.to_adql(service)
    }

    res = Net::HTTP.post_form(request, form)
    res
  end

  def get_raw_query(query)
    registry = Rails.application.config.asvo_registry
    service = registry.find_service(@dataset, @catalogue, 'tap')
    query.to_adql(service)
  end

  def get_capabilities
    registry = Rails.application.config.asvo_registry
    service = registry.find_service(@dataset, @catalogue, 'tap')
    uri = URI("#{service[:service_end_point]}/capabilities")
    response = Net::HTTP.get_response(uri)
    response.body
  end

end