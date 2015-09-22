class DynamicReports
  include Datagrid

  scope do
    SurveyAnswer.rating_and_binary
  end

  # filter(:id, :integer, :multiple => true))
  # filter(:text)
  # filter(:score)
  # filter(:user_id)
  # filter(:ignored)
  # filter(:cis_id)
  filter(:id, :integer)
  filter(:created_at, :date, :range => true)

  column(:id)
  column(:text)
  column(:score)
  column(:user_id)
  column(:ignored)
  column(:cis_id)
  column(:created_at) do |model|
    model.created_at.to_date
  end

end
