class AddIsContraloriaToAdmin < ActiveRecord::Migration
  def up
    add_column :admins, :is_comptroller, :boolean, :default => false
  end

  def down
    remove_column :admins, :is_comptroller, :boolean
  end
end
