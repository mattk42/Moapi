class AddNameToTestCases < ActiveRecord::Migration
  def change
    add_column :test_cases, :name, :string
  end
end
