module ServiceRequestsHelper

  def status_name(status_id)
    ServiceRequest::STATUS_LIST[status_id.to_sym]
  end

  def vote_link_for(service_request)
    if user_signed_in? && !current_user.voted_on?(service_request)
      link_to 'VOTA', vote_service_request_path(service_request), :remote => true, :method => :post, :class => "js-vote_service_request", class: "btn btn-primary btn-block"
    elsif user_signed_in? && current_user.voted_on?(service_request)
      link_to 'VOTASTE', "javascript:void(0)", class: "btn btn-success btn-block"
    elsif admin_signed_in?
      link_to 'VOTA', "javascript:void(0)", { class: "btn btn-primary blocked btn-block", data: { message: "Los administradores no pueden votar." } }
    else
      link_to 'VOTA', "javascript:void(0)", { class: "btn btn-primary blocked btn-block", data: { message: "Para votar necesitas registrarte." } }
    end
  end


  def service_request_info_window(service_request)
    img = image_tag service_request.image_url(:info_window), class: 'info_window_image' if service_request.image_url.present?
    description = content_tag :span, service_request.description, class: 'info_window_description'
    remove_link = (link_to 'Eliminar', admins_service_request_path(service_request), method: :delete, class: 'info_window_link') if admin_signed_in?
    img.to_s + description + remove_link.to_s
  end

end
