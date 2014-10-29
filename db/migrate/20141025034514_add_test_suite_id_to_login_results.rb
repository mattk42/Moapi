class AddTestSuiteIdToLoginResults < ActiveRecord::Migration
  def change
    add_column :login_results, :test_suite_id, :integer
  end
end
