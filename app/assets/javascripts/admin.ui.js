$(function(){
  $('#q_organisation_id').on('change', function(){
    $('#q_agency_id').html('<option>Cargando...</option>');
    var params = {
      q: {
        organisation_id_eq: $(this).val()
      }
    },
    options = [];

    $.getJSON('/administradores/agencies.json', params, function(agencies, textStatus) {
      for (var i = agencies.length - 1; i >= 0; i--) {
        options.push('<option value="'+agencies[i].id+'">'+agencies[i].name+'</option>');
      }
      $('#q_agency_id').html(options.join(''));
      $('#q_agency_id').trigger("chosen:updated")
    });
  });


  $('.autocomplete-organisation_id').on('change', function(){
    $('.autocomplete-agency_id').html('<option>Cargando...</option>');
    var params = {
      q: {
        organisation_id_eq: $(this).val()
      }
    },
    options = [];

    $.getJSON('/administradores/agencies.json', params, function(agencies, textStatus) {
      for (var i = agencies.length - 1; i >= 0; i--) {
        options.push('<option value="'+agencies[i].id+'">'+agencies[i].name+'</option>');
      }
      $('.autocomplete-agency_id').html(options.join(''));
      $('.autocomplete-agency_id').trigger("chosen:updated")
    });
  });

});