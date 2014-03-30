# This migration comes from xmppify_engine (originally 20140330183230)
class DeviseCreateUsers < ActiveRecord::Migration
  def change
   
      add_column :users,:encrypted_password,:string, null: false, default: ""
      add_index :users, :email,unique: true
    
  end
end
