class SyncQueryService

  def initialize(args)
    @dataset = args[:dataset]
    @catalogue = args[:catalogue]
  end

  def request
    registry = Rails.application.config.asvo_registry
    catalogue = registry.find_catalogue(@dataset, @catalogue)

    uri = URI("#{catalogue[:service_end_point]}/sync")
    uri
  end

  def fetch_results(query)
    begin
      form = {
          request: 'doQuery',
          lang: 'ADQL',
          query: query.to_adql
      }

      res = Net::HTTP.post_form(request, form)

      results_table = VOTableParser.parse_xml(res.body)
    rescue Exception
      #puts $!.inspect, $@
    end

    results_table
  end

end