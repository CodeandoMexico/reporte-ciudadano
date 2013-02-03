class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content, default: ''
      t.integer :report_id
      t.integer :commentable_id
      t.string :commentable_type
      t.string :ancestry

      t.timestamps
    end
    add_index :comments, :report_id
    add_index :comments, :ancestry
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type
  end
end
