class AddOpenToServiceSurveys < ActiveRecord::Migration
  def change
    add_column :service_surveys, :open, :boolean
  end
end
