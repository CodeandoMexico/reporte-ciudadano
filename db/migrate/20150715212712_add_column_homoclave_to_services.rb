class AddColumnHomoclaveToServices < ActiveRecord::Migration
  def up
    add_column :services, :homoclave, :text
  end

  def down
    remove_column :services, :homoclave, :text
  end
end
