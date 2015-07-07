class CreateCisReports < ActiveRecord::Migration
  def change
    create_table :cis_reports do |t|
      t.integer :cis_id
      t.decimal :positive_overall_perception
      t.decimal :negative_overall_perception
      t.integer :respondents_count

      t.timestamps null: false
    end
  end
end
