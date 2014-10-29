class CreateLoginResults < ActiveRecord::Migration
  def change
    create_table :login_results do |t|
      t.string :response
      t.integer :response_code
      t.datetime :datetime
      t.integer :test_suite_run_id
      t.boolean :pass
      t.string :reason

      t.timestamps
    end
  end
end
