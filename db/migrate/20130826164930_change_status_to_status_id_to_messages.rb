class ChangeStatusToStatusIdToMessages < ActiveRecord::Migration
  def up
    add_column :messages, :status_id, :integer
    add_index :messages, :status_id
    remove_column :messages, :status
  end

  def down
    remove_column :messages, :status_id
    add_column :messages, :status, :string
  end
end
