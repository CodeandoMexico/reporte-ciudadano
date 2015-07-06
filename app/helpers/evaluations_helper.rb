module EvaluationsHelper
  def overall_progress_by_criterion(overall)
    content_tag :div, "#{sprintf '%.2f', overall[1]}%", class: "progress-bar progress-bar-info", style: "width: #{overall[1]}"
  end

  def label_for(overall)
    content_tag(:span, t("question_criterion_options.#{overall[0]}"))
  end
end