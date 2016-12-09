class CreateServiceReports < ActiveRecord::Migration
  def change
    create_table :service_reports do |t|
      t.decimal :positive_overall_perception
      t.decimal :negative_overall_perception
      t.integer :respondents_count
      t.text :overall_areas
      t.references :service, index: true

      t.timestamps null: false
    end
    add_foreign_key :service_reports, :services
  end
end
