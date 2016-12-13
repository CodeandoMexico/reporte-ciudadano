class AddAgencyIdAndOrganizationIdToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :agency_id, :integer
    add_column :admins, :organisation_id, :integer

    Admin.where('administrative_unit IS NOT NULL').each do |admin|
      admin.update_columns({
        agency_id: Agency.find_by(name: admin.administrative_unit),
        organisation_id: Organisation.find_by(name: admin.dependency),
      })
    end
  end
end
