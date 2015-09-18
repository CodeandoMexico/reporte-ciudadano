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
user = User.create(name: "Observer juan", email: 'observer@observer.com', password: "password", password_confirmation: "password")

Service.all.each do |service|
  service.messages.create(status_id: open_status.id, content: 'Mensaje para status abierto')
  service.messages.create(status_id: verification_status.id, content: 'Mensaje para status verificado')
  service.messages.create(status_id: revision_status.id, content: 'Mensaje para status revisado')
  service.messages.create(status_id: close_status.id, content: 'Mensaje para status cerrado')
end
