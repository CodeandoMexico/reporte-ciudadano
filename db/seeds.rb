# Carga inicial de Base de datos
Admin.destroy_all
User.destroy_all
Service.destroy_all
ServiceRequest.destroy_all
Status.destroy_all

open_status = Status.create(name: "Abierto", is_default: true)
verification_status = Status.create(name: "Verificación")
revision_status = Status.create(name: "Revisión")
close_status = Status.create(name: "Cerrado")

super_admin = Admin.create(name: "Super admin", email: "admin@admin.com", password: "password", password_confirmation: "password", active: true)
user = Admin.create(name: "Observer juan", email: 'observer@observer.com', password: "password", password_confirmation: "password", is_observer: true)

status = Status.first

c = Service.create(
  name: "Acta de Nacimiento",
  service_admin_id: service_admin_1.id,
  cis: ['1', '2'],
  administrative_unit: "Unidad administrativa 1",
  service_type: :step,
  admins: [public_servant_1],
  status: 'activo'
)
r = {
  service_id: c.id,
  description: "Descripción reporte acta de nacimiento.",
  address: "Calle Benito Juarez",
  status_id: status.id
}
user.service_requests.build(r).save

c = Service.create(
  name: "Cambio de placas",
  service_admin_id: service_admin_2.id,
  cis: ['3'],
  administrative_unit: "Unidad administrativa 2",
  service_type: :service,
  admins: [public_servant_2],
  status: 'activo'
)

r = {
  service_id: c.id,
  description: "Descripción reporte cambio de placas.",
  address: "Calle Benito Juarez",
  status_id: status.id
}
user.service_requests.build(r).save

c = Service.create(
  name: "Pago de predial",
  service_admin_id: service_admin_3.id,
  cis: ['2', '3'],
  administrative_unit: "Unidad administrativa 3",
  service_type: :support_program,
  admins: [public_servant_3],
  status: 'activo'
)

r = {
  service_id: c.id,
  description: "Descripción reporte pago de predial.",
  address: "Calle Benito Juarez",
  status_id: status.id
}
user.service_requests.build(r).save

Service.all.each do |service|
  service.messages.create(status_id: open_status.id, content: 'Mensaje para status abierto')
  service.messages.create(status_id: verification_status.id, content: 'Mensaje para status verificado')
  service.messages.create(status_id: revision_status.id, content: 'Mensaje para status revisado')
  service.messages.create(status_id: close_status.id, content: 'Mensaje para status cerrado')
end
