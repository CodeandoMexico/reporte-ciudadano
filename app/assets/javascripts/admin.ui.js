
$(document).on('change', '.autocomplete-organisation_id', function(e){
  var params = {
    q: {
      organisation_id_eq: $(this).val()
    }
  };
  populateAgencySelect(params, $('.autocomplete-agency_id'));
  populateAdminServiceAdminSelect(params, $('#service_service_admin_id'));
});

$(document).on('change', '#q_organisation_id', function(e){
  var params = {
    q: {
      organisation_id_eq: $(this).val()
    }
  };
  populateAgencySelect(params, $('#q_agency_id'));
  populateAdminServiceAdminSelect(params, $('#service_service_admin_id'));
});



$(document).on('change', '.autocomplete-agency_id', function(e) {
  var params = {
    q: {
      organisation_id_eq: $('.autocomplete-agency_id:first').val(),
      agency_id_eq:  $(this).val()
    }
  };
  populateAdminServiceAdminSelect(params, $('#service_service_admin_id'));
});


var populateAgencySelect = function(params, field) {
  field.html('<option>Cargando...</option>');
  var options = ['<option>Unidad administrativa</option>'];
  $.getJSON('/administradores/agencies.json', params, function(agencies, textStatus) {
    for (var i = agencies.length - 1; i >= 0; i--) {
      options.push('<option value="'+agencies[i].id+'">'+agencies[i].name+'</option>');
    }
    field.html(options.join(''));
    field.trigger("chosen:updated")
  });
};

var populateAdminServiceAdminSelect = function(params, field) {
  if (field.length > 0) {
    var options = ['<option>Administrador de servicio</option>'];
    $.getJSON('/administradores/administrador_de_tramites.json', params, function(admins, textStatus) {
      for (var i = admins.length - 1; i >= 0; i--) {
        options.push('<option value="'+admins[i].id+'">'+admins[i].name+'</option>');
      }
      field.html(options.join(''));
      field.trigger("chosen:updated")
    });
  };
};
