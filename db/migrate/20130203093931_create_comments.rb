class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content,               default: ''
      t.integer :service_request_id
      t.references :commentable,      polymorphic: true, null: false
      t.string :ancestry
      t.string :image

      t.timestamps
    end

    add_index :comments, :service_request_id
    add_index :comments, :ancestry
    add_index :comments, [:commentable_id, :commentable_type]

  end
end
