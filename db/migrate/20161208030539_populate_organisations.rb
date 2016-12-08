class PopulateOrganisations < ActiveRecord::Migration
  def change
    Organisation.delete_all
    Services.load_values(:dependencies).fetch('dependencies').each do |id, name|
      organisation = Organisation.new(name: name)
      organisation.id = id
      organisation.save!
    end
  end
end
