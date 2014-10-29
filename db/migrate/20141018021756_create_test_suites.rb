class CreateTestSuites < ActiveRecord::Migration
  def change
    create_table :test_suites do |t|
      t.string :oauth_url
      t.string :client_id
      t.string :username
      t.string :password
      t.integer :interval
      t.string :name

      t.timestamps
    end
  end
end
