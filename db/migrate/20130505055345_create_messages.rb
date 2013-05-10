class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :category_id
      t.integer :status

      t.timestamps
    end
    add_index :messages, :category_id
  end
end
