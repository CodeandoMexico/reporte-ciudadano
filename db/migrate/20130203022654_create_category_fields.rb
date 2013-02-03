class CreateCategoryFields < ActiveRecord::Migration
  def change
    create_table :category_fields do |t|
      t.string :name
      t.integer :category_id

      t.timestamps
    end
  end
end
