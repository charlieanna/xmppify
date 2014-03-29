# This migration comes from xmppify_engine (originally 20140329065635)
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :doorkeeper_uid
      t.string :doorkeeper_access_token
      t.string :encrypted_data
      t.timestamps
    end
  end
end
