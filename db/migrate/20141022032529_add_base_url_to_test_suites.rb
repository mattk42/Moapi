class AddBaseUrlToTestSuites < ActiveRecord::Migration
  def change
    add_column :test_suites, :base_url, :string
  end
end
