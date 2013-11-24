# Destroy'em all
Admin.destroy_all
Service.destroy_all
ServiceRequest.destroy_all
Status.destroy_all

open_status = Status.create(name: "Abierto", default: true)
verification_status = Status.create(name: "Verificación")
revision_status = Status.create(name: "Revisión")
close_status = Status.create(name: "Cerrado")

admin = Admin.create(email: "admin@admin.com", password: "password", password_confirmation: "password")
user = User.create(name: "Juan Villanueva", email: 'juan@juan.com', password: "userpassword", password_confirmation: "userpassword")

status = Status.first

c = Service.create(name: "Toma tapada")
r = {
  service_id: c.id,
  description: "Parece que la toma esta tapada.",
  lat: "17.07610765289478",
  lng: "-96.71955585479736",
  status_id: status.id
}
user.service_requests.build(r).save

c = Service.create(name: "Ruptura de tuberia")
r = {
  service_id: c.id,
  description: "Se necesita atender una tuberia que se acaba de romper.",
  lat: "17.05811444402115",
  lng: "-96.72695453226964",
  status_id: status.id
}
user.service_requests.build(r).save

c = Service.create(name: "Fuga")
r = {
  service_id: c.id,
  description: "Acabo de ver una fuga en el Parque.",
  lat: "17.065020737526442",
  lng: "-96.72539234161377",
  status_id: status.id
}
user.service_requests.build(r).save

c = Service.create(name: "Desperdicio de agua")
r = {
  anonymous: true,
  service_id: c.id,
  description: "Mi vecino dejo abierta una manguera.",
  lat: "17.065593",
  lng: "-96.724253",
  status_id: status.id
}
user.service_requests.build(r).save

c = Service.create(name: "Robo de alcantarilla")
r = {
  service_id: c.id,
  description: "Parece ser que se robaron una alcantarilla.",
  lat: "17.068128422248872",
  lng: "-96.7195987701416",
  status_id: status.id
}
user.service_requests.build(r).save

c = Service.create(name: "Alcantarilla en mal estado")
r = {
  service_id: c.id,
  description: "La alcantarilla tiene mal olor y fugas de agua.",
  lat: "17.07714402",
  lng: "-96.71353313",
  status_id: status.id
}
user.service_requests.build(r).save

c = Service.create(name: "Falla en el drenaje")
r = {
  service_id: c.id,
  description: "El drenaje tiene fallas desde hace dos dias.",
  lat: "17.060477065746248",
  lng: "-96.72543525695801",
  status_id: status.id
}
user.service_requests.build(r).save

special_services = []
special_services << Service.create(name: "Retraso del servicio")
special_services << Service.create(name: "Robo de medidor")
special_services.each do |c|
  c.service_fields.create(name: "Numero de cuenta")
  c.service_fields.create(name: "Nombre del titular")
end
r = {
  service_id: special_services[0].id,
  description: "El dia de hoy no paso mi servicio!.",
  lat: "17.046243761147192",
  lng: "-96.76591701931939",
  service_fields: ["Juan Villanueva", "1502819992"],
  status_id: status.id
}
user.service_requests.build(r).save

r = {
  service_id: special_services[1].id,
  description: "Hoy en la manana note que mi medidor habia sido robado.",
  lat: "17.06185146120198",
  lng: "-96.72612190246582",
  service_fields: ["Jose del Bosque", "9981427729"],
  status_id: status.id
}
user.service_requests.build(r).save

Service.all.each do |service|
  service.messages.create(status_id: open_status.id, content: 'Mensaje para status abierto')
  service.messages.create(status_id: verification_status.id, content: 'Mensaje para status verificado')
  service.messages.create(status_id: revision_status.id, content: 'Mensaje para status revisado')
  service.messages.create(status_id: close_status.id, content: 'Mensaje para status cerrado')
end

#Set address using Geocoder
ServiceRequest.all.each do |r|
  geocoder = Geocoder.search("#{r.lat},#{r.lng}")
  r.update_attribute :address, geocoder[0].data["formatted_address"]
end
