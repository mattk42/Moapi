class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :response
      t.integer :response_code
      t.datetime :datetime
      t.integer :test_suite_run_id
      t.integer :test_case_id

      t.timestamps
    end
  end
end
