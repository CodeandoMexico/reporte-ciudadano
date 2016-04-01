class AddAdminIdToServiceSurveys < ActiveRecord::Migration
  def change
    add_reference :service_surveys, :admin, index: true
    add_foreign_key :service_surveys, :admins
  end
end
