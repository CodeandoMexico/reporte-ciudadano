class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.decimal :value
      t.string :criterion
      t.text :text
      t.string :answer_type

      t.timestamps null: false
    end
  end
end
