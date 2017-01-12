namespace :organisations do

  desc "Pupulate organisations and agencies tables"
  task migrate: :environment do

    file = File.read(Rails.root.join('app','services', 'organisations.json'))
    json_organisations = JSON.parse(file)

    Organisation.destroy_all
    Agency.destroy_all
    agency_id = 1
    json_organisations.each_with_index do |item, index|
      organisation = Organisation.new(name: item['name'])
      organisation.id = index + 1
      organisation.save!

      item['administrative_units'].each do |admin_unit|
        agency = Agency.new(name: admin_unit['name'])
        agency.id = agency_id
        agency.organisation_id = organisation.id
        agency.save!
        agency_id += 1
      end
    end
    p 'Organisation and agencies migration finished'

    p 'Updating Services'
    Service.all.each do |service|
      service.update_columns(
        organisation_id: Organisation.find_by(name: service[:dependency]),
        agency_id: Agency.find_by(name: service[:administrative_unit])
      )
    end

    p 'Updating admins'
    Admin.where('administrative_unit IS NOT NULL').each do |admin|
      admin.update_columns({
        agency_id: Agency.find_by(name: admin.administrative_unit),
        organisation_id: Organisation.find_by(name: admin.dependency),
      })
    end

    p 'Migrating offices'
    Office.delete_all
    Services.load_values(:cis).each do |cis|
      office = Office.new(cis)
      office.id = cis[:id]
      office.save!
    end

  end

end
