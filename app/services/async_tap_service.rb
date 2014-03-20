require 'net/http'

class AsyncTapService

  def initialize(args)
    @dataset = args[:dataset]
    @catalogue = args[:catalogue]
  end

  def request
    registry = Rails.application.config.asvo_registry
    service = registry.find_service(@dataset, @catalogue, 'tap')
    uri = URI("#{service[:service_end_point]}/async")
    uri
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
    registry = Rails.application.config.asvo_registry
    service = registry.find_service(@dataset, @catalogue, 'tap')

    form = {
        request: 'doQuery',
        lang: 'adql',
        query: query.to_adql(service)
    }
    res = Net::HTTP.post_form(request, form)
    if res.code == "303" and res.key? 'Location'
      job_status = JobStatus.new(res['Location'])
      job = AsyncJob.create
      job.email = "test@test.com"
      job.status = job_status.job_status
      job.url = res['Location']
      job.job_id = job_status.job_id
      job.save!
      start_job(job)
      return job.job_id
    else
      #render index wit some errors
    end
  end

  def start_job job
    #HTTP POST http://example.com/tap /async/42/phase
    #PHASE=RUN
    uri = URI("#{job.url}/phase")
    form = {
        PHASE: 'RUN',
    }
    res = Net::HTTP.post_form(uri, form)
    if res.code == "303" and res.key? 'Location'
      job_status = JobStatus.new(res['Location'])
      job.update_attribute(:status, job_status.job_status)
    end
  end

end