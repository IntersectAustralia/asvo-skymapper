class ChangeParamsTypeInAsyncJobs < ActiveRecord::Migration
  def up
    change_column :async_jobs, :query_params, :text
  end
  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :async_jobs, :query_params, :string
  end
end
