class AddIsObserverToAdmins < ActiveRecord::Migration
 def up
    add_column :admins, :is_observer, :boolean, :default => false
  end

  def down
    remove_column :admins, :is_observer, :boolean
  end
end