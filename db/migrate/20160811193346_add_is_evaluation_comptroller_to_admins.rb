class AddIsEvaluationComptrollerToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :is_evaluation_comptroller, :boolean, default: false
  end
end
