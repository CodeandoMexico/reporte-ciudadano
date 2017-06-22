class AddAgencyIdAndOrganizationIdToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :agency_id, :integer
    add_column :admins, :organisation_id, :integer
  end
end
