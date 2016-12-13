class Organisations
  def self.build_from_json
    Organisation.destroy_all
    Agency.destroy_all
    Services.load_organisations.each_with_index do |item, index|
      organisation = Organisation.new(name: item['name'])
      organisation.id = index + 1
      organisation.save!

      item['administrative_units'].each_with_index do |admin_unit, auindex|
        agency = Agency.new(name: admin_unit['name'])
        agency.organisation_id = organisation.id
        agency.save!
      end
    end
  end
end