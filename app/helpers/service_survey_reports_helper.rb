module ServiceSurveyReportsHelper
  def progress_bar (percentage, html_options = {})
    html_options[:class] ||= ""
    html_options[:bar_type] ||= ""
    content_tag(:div,
                content_tag( :div, "#{sprintf '%.2f', percentage}%",
                             class: "progress-bar #{html_options[:bar_type]} progress-bar-#{class_range_for(percentage.to_f)}", style: "width: #{percentage}%"),
                class: "progress #{html_options[:class]}")
  end

  def class_range_for(percentage)
    if percentage.between?(0.0, 69.0)
      "danger"
    elsif percentage.between?(70.0, 84.0)
      "warning"
    elsif percentage.between?(85.0, 100.0)
      "success"
    end
  end
end
