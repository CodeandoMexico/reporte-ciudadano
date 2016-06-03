class AddServiceToAnswers < ActiveRecord::Migration
  def up
    add_column :survey_answers, :service_id, :integer
  end

  def down
    remove_column :survey_answers, :service_id
  end
end
