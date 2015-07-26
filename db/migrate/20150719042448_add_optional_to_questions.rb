class AddOptionalToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :optional, :boolean, default: :false
  end
end
