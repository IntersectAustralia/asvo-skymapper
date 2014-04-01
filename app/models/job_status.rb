class JobStatus
  attr_accessor :job_status, :job_id, :destruction_time, :error, :start_time, :finish_time
  def initialize(url)
    res = Net::HTTP.get URI(url)
    doc = Nokogiri::XML(res)
    self.job_status = doc.xpath('.//uws:phase').text
    self.job_id = url.split('/').last
    self.destruction_time = doc.xpath('.//uws:destruction').text
    self.error = doc.xpath('.//uws:message').text if doc.xpath('.//uws:message')
    self.start_time = doc.xpath('.//uws:startTime').text if doc.xpath('.//uws:startTime')
    self.finish_time = doc.xpath('.//uws:endTime').text if doc.xpath('.//uws:endTime')
  end
end