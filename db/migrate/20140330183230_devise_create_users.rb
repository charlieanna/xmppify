class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

    


      t.timestamps
    end

    add_index :users, :email,                unique: true
    
  end
end
