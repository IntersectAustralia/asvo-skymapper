class AsyncJob < ActiveRecord::Base
  attr_accessible :email, :job_id, :status, :url

  def can_be_canceled?
    return true if self.status == 'QUEUED' or self.status == 'EXECUTING'
  end

  def results_ready?
    return true if self.status == 'COMPLETED'
  end
end
