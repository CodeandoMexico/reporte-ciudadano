class RemoveStatusFromReport < ActiveRecord::Migration
  def up
    remove_column :reports, :status
  end

  def down
    add_column :reports, :status, :string
  end
end
