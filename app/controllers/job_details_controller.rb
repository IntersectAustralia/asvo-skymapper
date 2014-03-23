class JobDetailsController < ApplicationController
  def view
    @job = AsyncJob.find_by_job_id(params[:id])
    @job.check_for_update unless @job.nil?
  end
  def cancel
    #HTTP POST http://example.com/tap/async/42/phase
    #PHASE=ABORT

    job = AsyncJob.find_by_job_id(params[:id])
    uri = URI("#{job.url}/phase")
    form = {
        PHASE: 'ABORT',
    }
    res = Net::HTTP.post_form(uri, form)
    render 'view'
  end
end
