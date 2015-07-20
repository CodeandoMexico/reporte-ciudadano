module EvaluationsHelper
  def overall_progress_by_criterion(overall)
    content_tag :div, "#{sprintf '%.2f', overall[1]}%", class: "progress-bar progress-bar-info", style: "width: #{overall[1]}"
  end

  def label_for(overall)
    content_tag(:span, t("question_criterion_options.#{overall[0]}"))
  end

  def overall_progress(overall)
    content_tag :div, "#{sprintf '%.2f', overall}%", class: "progress-bar progress-bar-success", style: "width: #{overall}"
  end

  def sorted_icon(direction, criterion, sorted_by)
    if direction == :asc && criterion.to_s == sorted_by
      content_tag :span, "", class: "glyphicon glyphicon-chevron-up"
    elsif direction == :desc && criterion.to_s == sorted_by
      content_tag :span, "", class: "glyphicon glyphicon-chevron-down"
    end
  end
end