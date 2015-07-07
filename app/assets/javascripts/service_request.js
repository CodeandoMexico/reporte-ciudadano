function changeLine(){
    var e = document.getElementById("service_request_service_id");
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

  function changeWho(){
    var e = document.getElementById("service_request_public_servant_id");
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
  $(document).ready(validate_requirements);

  function validate_requirements(){  
    var e = document.getElementById("service_request_service_id");
    if(document.getElementById("service_request_description").value!= "" && e.value != ""){
     document.getElementById("save_form").disabled = false;
    }else{
    document.getElementById("save_form").disabled = true;
    }
  }