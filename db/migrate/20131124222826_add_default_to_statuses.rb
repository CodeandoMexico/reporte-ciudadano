class AddDefaultToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :is_default, :boolean, default: false
  end
end
