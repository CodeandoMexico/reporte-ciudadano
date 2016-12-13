class AddAgencyIdAndOrganisationIdToServices < ActiveRecord::Migration
  def up
    add_column :services, :organisation_id, :integer
    add_column :services, :agency_id, :integer

    Service.all.each do |service|
      service.update_columns(
        organisation_id: Organisation.find_by(name: service[:dependency]),
        agency_id: Agency.find_by(name: service[:administrative_unit])
      )
    end
  end

  def down
    remove_column :services, :organisation_id
    remove_column :services, :agency_id
  end
end
