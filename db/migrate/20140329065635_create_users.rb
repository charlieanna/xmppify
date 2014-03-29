class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      add_column :users,:doorkeeper_uid,:integer
      add_column :users,:doorkeeper_access_token,:string
      add_column :users,:encrypted_data,:string
      t.timestamps
    end
  end
end
