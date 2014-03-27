class AddFileTypeToAsyncJobs < ActiveRecord::Migration
  def change
    add_column :async_jobs, :format, :string
  end
end
