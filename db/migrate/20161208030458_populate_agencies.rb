class PopulateAgencies < ActiveRecord::Migration
  def change
    Agency.delete_all
    Services.load_values(:administrative_units).fetch('administrative_units').each do |id, name|
      agency = Agency.new(name: name)
      agency.id = id
      agency.save!
    end
  end
end
