class AddResponseTimeToResults < ActiveRecord::Migration
  def change
    add_column :results, :response_time, :decimal
    add_column :login_results, :response_time, :decimal
  end
end
