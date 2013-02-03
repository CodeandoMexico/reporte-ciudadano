class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :description, default: ''
      t.integer :category_id
      t.string :lat, default: ''
      t.string :lng, default: ''
      t.boolean :anonymous, default: false
      t.text :category_fields, default: '{}'

      t.timestamps
    end
    add_index :reports, :category_id
  end
end
