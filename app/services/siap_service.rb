class SiapService

  def initialize(args)
    @dataset = args[:dataset]
  end

  def request
    registry = Rails.application.config.asvo_registry
  end

  def fetch_results(query)
    begin
      res = fetch_query_response(query)

      results_table = VOTableParser.parse_xml(res.body)
    rescue Exception
      puts $!.inspect, $@ unless Rails.env == 'test'
    end

    results_table
  end

  def fetch_query_response(query)
    form = {
        request: 'doQuery',
        lang: 'ADQL',
        query: query.to_adql
    }

    res = Net::HTTP.post_form(request, form)
    res
  end

end