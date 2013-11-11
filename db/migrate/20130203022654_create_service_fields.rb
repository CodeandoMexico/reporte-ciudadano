class CreateServiceFields < ActiveRecord::Migration
  def change
    create_table :service_fields do |t|
      t.string :name
      t.integer :service_id

      t.timestamps
    end
  end
end
