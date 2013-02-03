module ReportsHelper

  def status_name(status_id)
    Report::STATUS_LIST[status_id]
  end

  def vote_link_for(report)
    if user_signed_in? && !current_user.voted_on?(report)
      link_to 'Vota', vote_report_path(report), :remote => true, :method => :post, :class => "js-vote_report"
    elsif user_signed_in? && current_user.voted_on?(report)
      'Votado'
    else
      link_to 'Vota', login_path
    end
  end

end
