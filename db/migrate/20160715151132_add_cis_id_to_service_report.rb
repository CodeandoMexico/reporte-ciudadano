class AddCisIdToServiceReport < ActiveRecord::Migration
  def up
    add_column :service_reports, :cis_id, :integer
  end

  def down
    remove_column :service_reports, :cis_id
  end
end
