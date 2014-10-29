class CreateNotificationRules < ActiveRecord::Migration
  def change
    create_table :notification_rules do |t|
      t.string :name
      t.string :script
      t.string :args
      t.integer :test_case_id
      t.integer :test_suite_id

      t.timestamps
    end
  end
end
