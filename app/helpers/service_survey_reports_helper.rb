module ServiceSurveyReportsHelper
  def progress_bar (percentage, html_options = {})
    html_options[:class] ||= ""
    html_options[:bar_type] ||= "progress-bar-success"
    content_tag(:div,
                content_tag( :div, "#{sprintf '%.2f', percentage}%",
                             class: "progress-bar #{html_options[:bar_type]}", style: "width: #{percentage}%"),
                class: "progress #{html_options[:class]} ")
  end
end
