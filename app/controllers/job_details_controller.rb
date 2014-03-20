class JobDetailsController < ApplicationController
  def view
    @job = AsyncJob.find_by_job_id(params[:id])
  end
end
