class AddTelephoneToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :telephone_number, :text, default: ""
  end

  def self.down
    remove_column :users, :telephone_number
  end
end
