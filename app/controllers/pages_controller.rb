class PagesController < ApplicationController
    layout 'landing'
  def index
    @services_count = Service.count
    @active_citizen_count = SurveyAnswer.pluck(:user_id).uniq.count
    @public_servant_assessed_count = Question.with_public_servant_type.map(&:services).flatten.map(&:admins).flatten.uniq.count
    @url_video = 'https://www.youtube.com/watch?v=uFLWkxsUFr8'
  end
end
