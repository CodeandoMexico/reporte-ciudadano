class AddColumnStatusToServices < ActiveRecord::Migration
  def up
    add_column :services, :status, :text, :default => "activo"
  end

  def down
    remove_column :services, :status, :text
  end
end
