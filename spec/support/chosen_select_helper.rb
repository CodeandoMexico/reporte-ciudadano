#Soporte para los selectores con
# autocomplete de la Gema de chosen-rails.

module ChosenSelect
  def select_from_chosen_by_css(item_text, options)
    field = find(options[:from])
    option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
    page.execute_script("value = ['#{option_value}']\; if ($('##{field[:id]}').val()) {$.merge(value, $('##{field[:id]}').val())}")
    option_value = page.evaluate_script("value")
    page.execute_script("$('##{field[:id]}').val(#{option_value})")
    page.execute_script("$('##{field[:id]}').trigger('liszt:updated').trigger('change')")
  end

  def select_from_chosen_by_field(item_text, options)
    field = find_field(options[:from])
    option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
    page.execute_script("value = ['#{option_value}']\; if ($('##{field[:id]}').val()) {$.merge(value, $('##{field[:id]}').val())}")
    option_value = page.evaluate_script("value")
    page.execute_script("$('##{field[:id]}').val(#{option_value})")
    page.execute_script("$('##{field[:id]}').trigger('liszt:updated').trigger('change')")
  end

  def chosen_select(item_text, options)
    field_id = find_field(options[:from])[:id]
    option_value = page.evaluate_script("$(\"##{field_id} option:contains('#{item_text}')\").val()")
    page.execute_script("$('##{field_id}').val('#{option_value}')")
  end

end

RSpec.configure do |config|
  config.include ChosenSelect
end