class AddMoreDetailsToAsyncJob < ActiveRecord::Migration
  def change
    add_column :async_jobs, :query_type, :string
    add_column :async_jobs, :query_params, :string
    add_column :async_jobs, :start_time, :datetime
    add_column :async_jobs, :end_time, :datetime
  end
end
