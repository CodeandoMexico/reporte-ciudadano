class CreateServiceSurveys < ActiveRecord::Migration
  def change
    create_table :service_surveys do |t|
      t.string :title
      t.string :phase

      t.timestamps null: false
    end
  end
end
