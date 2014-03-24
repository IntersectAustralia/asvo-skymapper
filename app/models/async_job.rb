class AsyncJob < ActiveRecord::Base
  attr_accessible :email, :job_id, :status, :url

  def can_be_canceled?
    return true if self.status == 'QUEUED' or self.status == 'EXECUTING'
  end

  def results_ready?
    return true if self.status == 'COMPLETED'
  end

  def check_for_update
    job_status = JobStatus.new(self.url)
    if job_status && job_status.job_status == 'COMPLETED'
      Notifier.job_finished_notification(self).deliver
    end
    if job_status && job_status.job_status == 'ERROR'
      Notifier.job_error_notification(self, job_status).deliver
    end
    if job_status && job_status.job_status != self.status
      self.update_attribute(:status, job_status.job_status)
    end
  end
  def self.check_jobs_status
    AsyncJob.where("status in ('PENDING', 'EXECUTING', 'QUEUED')").each {|job| job.check_for_update}
  end
end
