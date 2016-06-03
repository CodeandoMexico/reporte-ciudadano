# Carga inicial de Base de datos
Admin.destroy_all
User.destroy_all
Service.destroy_all
ServiceRequest.destroy_all
Status.destroy_all

open_status = Status.create(name: "Atendido por la Dirección de atención de Quejas y Denuncias", is_default: true)
close_status = Status.create(name: "Cerrado")

super_admin = Admin.create(name: "Super admin", email: "admin@admin.com", password: "password", password_confirmation: "password", active: true)
observer = Admin.create(name: "Observer juan", email: 'observer@observer.com', password: "password", password_confirmation: "password", is_observer: true)
