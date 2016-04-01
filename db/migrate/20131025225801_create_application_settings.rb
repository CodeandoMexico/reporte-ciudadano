class CreateApplicationSettings < ActiveRecord::Migration
  def change
    create_table :application_settings do |t|
      t.string :type
      t.string :value

      t.timestamps
    end

    add_index :application_settings, :type
  end
end
