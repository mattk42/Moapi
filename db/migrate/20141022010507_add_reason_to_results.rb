class AddReasonToResults < ActiveRecord::Migration
  def change
	add_column :results, :pass, :boolean
	add_column :results, :reason, :string	
  end
end
