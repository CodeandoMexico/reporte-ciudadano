module EvaluationsHelper
  def overall_progress_by_criterion(overall)
    content_tag :div, "#{sprintf '%.f', overall[1]}%", class: "progress-bar progress-bar-#{class_range_for(overall[1])}", style: "width: #{overall[1]}%; color: black"
  end

  def label_for(overall)
    content_tag(:span, t("question_criterion_options.#{overall[0]}"))
  end

  def overall_progress(overall)
    content_tag :div, "#{sprintf '%.f', overall}%", class: "progress-bar progress-bar-#{class_range_for(overall)}", style: "width: #{overall}%; color: black"
  end

  def sorted_icon(direction, criterion, sorted_by)
    if direction == :asc && criterion.to_s == sorted_by
      content_tag :span, "", class: "glyphicon glyphicon-chevron-up"
    elsif direction == :desc && criterion.to_s == sorted_by
      content_tag :span, "", class: "glyphicon glyphicon-chevron-down"
    end
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