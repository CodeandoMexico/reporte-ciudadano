class AddStatusIdToMessages < ActiveRecord::Migration

  def change
    add_column :messages, :status_id, :integer
    add_index :messages, :status_id
  end

end
