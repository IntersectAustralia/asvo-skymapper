class JobStatus
  attr_accessor :job_status, :job_id
  def initialize(url)
    res = Net::HTTP.get URI(url)
    doc = Nokogiri::HTML(res)
    self.job_status = doc.xpath('//phase').text
    self.job_id = url.split('/').last
  end
end