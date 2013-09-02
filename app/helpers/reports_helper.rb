module ReportsHelper

  def status_name(status_id)
    Report::STATUS_LIST[status_id.to_sym]
  end

  def vote_link_for(report)
    if user_signed_in? && !current_user.voted_on?(report)
      link_to 'VOTA', vote_report_path(report), :remote => true, :method => :post, :class => "js-vote_report", class: "btn btn-primary btn-block"
    elsif user_signed_in? && current_user.voted_on?(report)
      link_to 'VOTASTE', "javascript:void(0)", class: "btn btn-success btn-block"
    elsif admin_signed_in?
      link_to 'VOTA', "javascript:void(0)", { class: "btn btn-primary blocked btn-block", data: { message: "Los administradores no pueden votar." } }
    else
      link_to 'VOTA', "javascript:void(0)", { class: "btn btn-primary blocked btn-block", data: { message: "Para votar necesitas registrarte." } }
    end
  end


  def report_info_window(report)
    img = image_tag report.image_url(:info_window), class: 'info_window_image' if report.image_url.present?
    description = content_tag :span, report.description, class: 'info_window_description'
    remove_link = (link_to 'Eliminar', admins_report_path(report), method: :delete, class: 'info_window_link') if admin_signed_in?
    img.to_s + description + remove_link.to_s
  end

end
