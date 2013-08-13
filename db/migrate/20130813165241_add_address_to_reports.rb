class AddAddressToReports < ActiveRecord::Migration
  def change
    add_column :reports, :address, :text
  end
end
