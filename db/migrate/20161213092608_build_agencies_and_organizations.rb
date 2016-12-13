class BuildAgenciesAndOrganizations < ActiveRecord::Migration
  def change
    Organisations.build_from_json
  end
end
