class AddOrganisationIdToAgencies < ActiveRecord::Migration
  def change
    add_reference :agencies, :organisation, index: true
  end
end
