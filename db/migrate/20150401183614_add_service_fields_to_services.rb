class AddServiceFieldsToServices < ActiveRecord::Migration
  def change
    add_column :services, :service_type, :string
    add_column :services, :dependency, :string
    add_column :services, :administrative_unit, :string
    add_column :services, :cis, :string
  end
end
