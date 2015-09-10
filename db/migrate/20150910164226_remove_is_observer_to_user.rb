class RemoveIsObserverToUser < ActiveRecord::Migration
 def up
    remove_column :users, :is_observer, :boolean
  end

  def down
    add_column :users, :is_observer, :boolean
  end
end