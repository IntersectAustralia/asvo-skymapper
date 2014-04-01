class JobDetailsController < ApplicationController
  def view
    @job = AsyncJob.find_by_job_id(params[:id])
    @job.check_for_update unless @job.nil?
  end
  def cancel
    #HTTP POST http://example.com/tap/async/42/phase
    #PHASE=ABORT

    @job = AsyncJob.find_by_job_id(params[:id])
    job_status = JobStatus.new(@job.url)
    if job_status.job_status == 'QUEUED'  || job_status.job_status == 'EXECUTING'
      uri = URI("#{@job.url}/phase")
      form = {
        PHASE: 'ABORT',
      }
      res = Net::HTTP.post_form(uri, form)
    else
      flash[:error] = 'Only job in state QUEUED or EXECUTING can be canceled.'
    end
    redirect_to :controller => 'job_details', :action => 'view', :id =>  params[:id]
  end

  def download
    job = AsyncJob.find_by_job_id(params[:id])
    res = Net::HTTP.get URI("#{job.url}/results/result")
    if job.format == "CSV"
      type = 'text/csv; charset=utf-16 header=present'
      extension = "csv"
    else
      type = 'application/xml; charset=utf-16'
      extension ="votable"
    end

    send_data res, :type => type, :disposition => "attachment", :filename => "#{job.job_id}.#{extension}"
  end
end
