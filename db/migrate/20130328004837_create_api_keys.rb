class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token, unique: true
      t.integer :admin_id

      t.timestamps
    end

    add_index :api_keys, :access_token
    add_index :api_keys, :admin_id
  end
end
