class AddAgencyIdAndOrganisationIdToServices < ActiveRecord::Migration
  def up
    add_column :services, :organisation_id, :integer
    add_column :services, :agency_id, :integer
  end

  def down
    remove_column :services, :organisation_id
    remove_column :services, :agency_id
  end
end
