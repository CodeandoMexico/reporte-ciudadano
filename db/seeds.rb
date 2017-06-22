# Carga inicial de Base de datos
Admin.destroy_all
User.destroy_all
Service.destroy_all
ServiceRequest.destroy_all
Status.destroy_all

open_status = Status.create(name: "Atendido", is_default: true)
close_status = Status.create(name: "Cerrado")
erased_status = Status.create(name: "Eliminado")

Rake::Task['organisations:migrate'].invoke