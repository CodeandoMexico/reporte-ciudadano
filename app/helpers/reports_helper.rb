module ReportsHelper

  def status_name(status_id)
    Report::STATUS_LIST[status_id.to_sym]
  end

  def vote_link_for(report)
    if user_signed_in? && !current_user.voted_on?(report)
      link_to 'VOTA', vote_report_path(report), :remote => true, :method => :post, :class => "js-vote_report", class: "button blue rounded"
    elsif user_signed_in? && current_user.voted_on?(report)
      link_to 'VOTASTE', "javascript:void(0)", class: "button green"
    elsif admin_signed_in?
      link_to 'VOTA', "javascript:void(0)", { class: "button green blocked", data: { message: "Los administradores no pueden votar." } }
    else
      link_to 'VOTA', "javascript:void(0)", { class: "button green blocked", data: { message: "Para votar necesitas registrarte." } }
    end
  end


  def report_info_window(report)
    img = image_tag report.image_url(:info_window), class: 'info_window_image'
    description = content_tag :span, report.description, class: 'info_window_description'
    remove_link = (link_to 'Eliminar', admins_report_path(report), method: :delete, class: 'info_window_link') if admin_signed_in?
    img + description + remove_link
  end

end
