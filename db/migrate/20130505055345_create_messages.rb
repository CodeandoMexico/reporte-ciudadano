class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :service_id

      t.timestamps
    end

    add_index :messages, :service_id
  end
end
