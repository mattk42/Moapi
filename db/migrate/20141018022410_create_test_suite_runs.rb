class CreateTestSuiteRuns < ActiveRecord::Migration
  def change
    create_table :test_suite_runs do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :test_suite_id

      t.timestamps
    end
  end
end
