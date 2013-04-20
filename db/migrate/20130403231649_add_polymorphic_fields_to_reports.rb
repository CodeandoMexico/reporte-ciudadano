class AddPolymorphicFieldsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :reportable_type, :string
    add_column :reports, :reportable_id, :integer
    add_index :reports, [:reportable_id, :reportable_type]
  end
end
