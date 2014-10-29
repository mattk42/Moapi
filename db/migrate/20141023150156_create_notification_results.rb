class CreateNotificationResults < ActiveRecord::Migration
  def change
    create_table :notification_results do |t|
      t.string :output
      t.integer :return_code
      t.datetime :datetime
      t.integer :notification_rule_id

      t.timestamps
    end
  end
end
