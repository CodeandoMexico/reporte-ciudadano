class CreateServicesServiceSurveys < ActiveRecord::Migration
  def change
    create_table :services_service_surveys do |t|
      t.integer :service_id, null: false
      t.integer :service_survey_id, null: false
    end
  end
end
