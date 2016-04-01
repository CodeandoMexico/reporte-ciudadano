# Destroy'em all
Admin.destroy_all
User.destroy_all
Service.destroy_all
ServiceRequest.destroy_all
Status.destroy_all

open_status = Status.create(name: "Atendido por la Dirección de atención de Quejas y Denuncias", is_default: true)
close_status = Status.create(name: "Cerrado")

super_admin = Admin.create(name: "Super admin", email: "admin@admin.com", password: "password", password_confirmation: "password", active: true)

service_admin_1 = Admin.create(name: "Admin servicio 1", email: "serviceadmin1@admin.com", password: "password", password_confirmation: "password", dependency: 'Dependencia 1', is_service_admin: true, active: true)
service_admin_2 = Admin.create(name: "Admin servicio 2", email: "serviceadmin2@admin.com", password: "password", password_confirmation: "password", dependency: 'Dependencia 2', is_service_admin: true, active: true)
service_admin_3 = Admin.create(name: "Admin servicio 3", email: "serviceadmin3@admin.com", password: "password", password_confirmation: "password", dependency: 'Dependencia 3', is_service_admin: true, active: true)

public_servant_1 = Admin.create(name: "Servidor público 1", email: "publicservant1@admin.com", password: "password", password_confirmation: "password", dependency: 'Dependencia 1', is_public_servant: true, active: true)
public_servant_2 = Admin.create(name: "Servidor público 2", email: "publicservant2@admin.com", password: "password", password_confirmation: "password", dependency: 'Dependencia 2', is_public_servant: true, active: true)
public_servant_3 = Admin.create(name: "Servidor público 3", email: "publicservant3@admin.com", password: "password", password_confirmation: "password", dependency: 'Dependencia 3', is_public_servant: true, active: true)

observer = Admin.create(name: "Observer juan", email: 'observer@observer.com', password: "password", password_confirmation: "password", is_observer: true)


user = User.create(name: "Juan Villanueva", email: 'juan@juan.com', password: "userpassword", password_confirmation: "userpassword")


status = Status.first

c = Service.create(
    name: "Acta de Nacimiento",
    service_admin_id: service_admin_1.id,
    dependency: Services.service_administrative_unit_options[10],
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
    dependency: Services.service_administrative_unit_options[10],
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
    dependency: Services.service_administrative_unit_options[10],
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
