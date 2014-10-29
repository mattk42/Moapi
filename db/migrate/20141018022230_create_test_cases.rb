class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.string :endpoint
      t.string :method
      t.string :params
      t.integer :timeout
      t.integer :test_suite_id

      t.timestamps
    end
  end
end
