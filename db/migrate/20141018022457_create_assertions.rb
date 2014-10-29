class CreateAssertions < ActiveRecord::Migration
  def change
    create_table :assertions do |t|
      t.string :field
      t.string :expected_value
      t.integer :test_case_id

      t.timestamps
    end
  end
end
