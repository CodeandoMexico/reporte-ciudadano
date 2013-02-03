class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :username

      t.timestamps
    end
    add_index :users, :email
  end
end
