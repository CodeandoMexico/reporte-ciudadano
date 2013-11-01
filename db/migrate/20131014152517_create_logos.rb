class CreateLogos < ActiveRecord::Migration
  def change
    create_table :logos do |t|
      t.string :title
      t.string :image
      t.integer :position

      t.timestamps
    end

  end
end
