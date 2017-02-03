class AddOrganisationIdToAgencies < ActiveRecord::Migration
  def change
    add_reference :agencies, :organisation, index: true
    add_foreign_key :agencies, :organisations
  end
end
