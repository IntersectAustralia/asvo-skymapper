class SiapService

  def initialize(args)
    @dataset = args[:dataset]
    @catalogue = args[:catalogue]
  end

  def request
    registry = Rails.application.config.asvo_registry
    service = registry.find_service(@dataset, @catalogue, 'siap')

    uri = URI("#{service[:service_end_point]}")
    uri
  end

  def fetch_results(query)
    begin
      res = fetch_query_response(query)

      results_table = VOTableParser.parse_xml(res)
    rescue Exception
      puts $!.inspect, $@ unless Rails.env == 'test'
    end

    results_table
  end

  def fetch_query_response(query)
    form = {
        POS: "#{query.ra},#{query.dec}",
        SIZE: '0'
    }

    uri = request
    uri.query = URI.encode_www_form(form)

    res = Net::HTTP.get(uri)
    res
  end

end