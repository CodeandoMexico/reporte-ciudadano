function changeLine(){
    var e = document.getElementById("service_request_service_id");
    if (typeof(e) != 'undefined' && e != null)
    {
      window.service = e.value;
      $.ajax({
             type:'GET', 
             url: '#{service_public_servants_service_requests_path}',
             success: function(){
             },
            error: function(){
            }, 
             data: $.param({ pagetime: {service: window.service}})
        });
      validate_requirements();
    }
  }

  function changeWho(){
    var e = document.getElementById("service_request_public_servant_id");
    if (typeof(e) != 'undefined' && e != null)
    {
      window.public_server = e.value;
      $.ajax({
             type:'GET', 
             url: '#{service_public_servants_service_requests_path}',
             success: function(){
             },
            error: function(){
            }, 
             data: $.param({ pagetime: {who: window.public_server}})
        });
        validate_requirements();
    }
  }
  $(document).ready(validate_requirements);

  function validate_requirements(){  
    var e = document.getElementById("service_request_service_id");
    var f = document.getElementById("service_request_cis");
    var d = document.getElementById("service_request_description");
    if (typeof(e) != 'undefined' && e != null && typeof(d) != 'undefined' && d != null  && typeof(f) != 'undefined' && f != null)
    {
      if(d.value!= "" && e.value != "" && f.value != ""){
        document.getElementById("save_form").disabled = false;
      }else{
        document.getElementById("save_form").disabled = true;
      }
    }
  }