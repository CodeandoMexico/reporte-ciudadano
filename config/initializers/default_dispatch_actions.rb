
#
# Adding X-Frame-Options
# Se agrega para que no permita
# cargar el sitio a traves de un Iframe
# por motivos de seguridad
#

Rails.application.config.action_dispatch.default_headers = {
    'X-Frame-Options' => 'SAMEORIGIN'
}