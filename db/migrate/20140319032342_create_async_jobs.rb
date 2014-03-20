class CreateAsyncJobs < ActiveRecord::Migration
  def change
    create_table :async_jobs do |t|
      t.string :email
      t.string :job_id
      t.string :status
      t.string :url

      t.timestamps
    end
  end
end
