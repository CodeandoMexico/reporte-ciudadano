# Destroy'em all
Admin.destroy_all
Category.destroy_all
Report.destroy_all
Status.destroy_all

open_status = Status.create(name: "Abierto")
verification_status = Status.create(name: "Verificación")
revision_status = Status.create(name: "Revisión")
close_status = Status.create(name: "Cerrado")

admin = Admin.new(email: "admin@admin.com", password: "oaxacker", password_confirmation: "oaxacker")
admin.save
admin.create_api_key
juan = User.create(name: "Juan Villanueva", email: 'juan@juan.com', password: "12345678", password_confirmation: "12345678")

status = Status.first

c = Category.create(name: "Toma tapada")
r = {
  category_id: c.id,
  description: "Parece que la toma esta tapada.",
  lat: "17.07610765289478",
  lng: "-96.71955585479736",
  status: status
}
juan.reports.build(r).save

c = Category.create(name: "Ruptura de tuberia")
r = {
  category_id: c.id,
  description: "Se necesita atender una tuberia que se acaba de romper.",
  lat: "17.05811444402115",
  lng: "-96.72695453226964",
  status: status
}
juan.reports.build(r).save

c = Category.create(name: "Fuga")
r = {
  category_id: c.id,
  description: "Acabo de ver una fuga en el Parque.",
  lat: "17.065020737526442",
  lng: "-96.72539234161377",
  status: status
}
juan.reports.build(r).save

c = Category.create(name: "Desperdicio de agua")
r = {
  anonymous: true,
  category_id: c.id,
  description: "Mi vecino dejo abierta una manguera.",
  lat: "17.065593",
  lng: "-96.724253",
  status: status
}
juan.reports.build(r).save

c = Category.create(name: "Robo de alcantarilla")
r = {
  category_id: c.id,
  description: "Parece ser que se robaron una alcantarilla.",
  lat: "17.068128422248872",
  lng: "-96.7195987701416",
  status: status
}
juan.reports.build(r).save

c = Category.create(name: "Alcantarilla en mal estado")
r = {
  category_id: c.id,
  description: "La alcantarilla tiene mal olor y fugas de agua.",
  lat: "17.07714402",
  lng: "-96.71353313",
  status: status
}
juan.reports.build(r).save

c = Category.create(name: "Falla en el drenaje")
r = {
  category_id: c.id,
  description: "El drenaje tiene fallas desde hace dos dias.",
  lat: "17.060477065746248",
  lng: "-96.72543525695801",
  status: status
}
juan.reports.build(r).save

special_categories = []
special_categories << Category.create(name: "Retraso del servicio")
special_categories << Category.create(name: "Robo de medidor")
special_categories.each do |c|
  c.category_fields.create(name: "Numero de cuenta")
  c.category_fields.create(name: "Nombre del titular")
end
r = {
  category_id: special_categories[0].id,
  description: "El dia de hoy no paso mi servicio!.",
  lat: "17.046243761147192",
  lng: "-96.76591701931939",
  category_fields: ["Juan Villanueva", "1502819992"],
  status: status
}
juan.reports.build(r).save

r = {
  category_id: special_categories[1].id,
  description: "Hoy en la manana note que mi medidor habia sido robado.",
  lat: "17.06185146120198",
  lng: "-96.72612190246582",
  category_fields: ["Jose del Bosque", "9981427729"],
  status: status
}
juan.reports.build(r).save

Category.all.each do |category|
  category.messages.create(status_id: open_status.id, content: 'Mensaje para status abierto')
  category.messages.create(status_id: verification_status.id, content: 'Mensaje para status verificado')
  category.messages.create(status_id: revision_status.id, content: 'Mensaje para status revisado')
  category.messages.create(status_id: close_status.id, content: 'Mensaje para status cerrado')
end

#Set address using Geocoder
Report.all.each do |r|
  geocoder = Geocoder.search("#{r.lat},#{r.lng}")
  r.update_attribute :address, geocoder[0].data["formatted_address"]
end



