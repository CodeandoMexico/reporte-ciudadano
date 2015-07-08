class AddIsObserverToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_observer, :boolean
  end
end
