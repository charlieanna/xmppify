class DeviseCreateUsers < ActiveRecord::Migration
  def change
   
      add_column :user,:encrypted_password, null: false, default: ""
      add_index :users, :email,unique: true
    
  end
end
