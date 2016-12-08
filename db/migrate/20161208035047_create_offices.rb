class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.string :name
      t.text :address
      t.string :phone
      t.text :schedule

      t.timestamps null: false
    end
  end
end
