# Carga inicial de Base de datos
Admin.destroy_all
User.destroy_all
Service.destroy_all
ServiceRequest.destroy_all
Status.destroy_all

open_status = Status.create(name: "Atendido por la Dirección de atención a Quejas y Denuncias", is_default: true)
close_status = Status.create(name: "Cerrado")
erased_status = Status.create(name: "Eliminado")

super_admin = Admin.create(name: "Super admin", email: "admin@admin.com", password: "password", password_confirmation: "password", active: true)
observer = Admin.create(name: "Observer juan", email: 'observer@observer.com', password: "password", password_confirmation: "password", is_observer: true)

# Populate agencies with administrative units
Agency.delete_all
Services.load_values(:administrative_units).fetch('administrative_units').each do |id, name|
  agency = Agency.new(name: name)
  agency.id = id
  agency.save!
end

# populate organisations with dependencies
Organisation.delete_all
Services.load_values(:dependencies).fetch('dependencies').each do |id, name|
  organisation = Organisation.new(name: name)
  organisation.id = id
  organisation.save!
end

# populate offices with cis
Office.delete_all
Services.load_values(:cis).each do |cis|
  office = Office.new(cis)
  office.id = cis[:id]
  office.save!
end
