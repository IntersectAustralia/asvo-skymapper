class JobStatus
  attr_accessor :job_status, :job_id, :destruction_time, :error
  def initialize(url)
    res = Net::HTTP.get URI(url)
    doc = Nokogiri::XML(res)
    self.job_status = doc.xpath('.//uws:phase').text
    self.job_id = url.split('/').last
    self.destruction_time = doc.xpath('.//uws:destruction').text
    self.error =  doc.xpath('.//uws:message').text if doc.xpath(".//uws:message")
  end
end