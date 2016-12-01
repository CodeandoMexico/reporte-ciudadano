class PagesController < ApplicationController
  layout 'landing'

  def index
    @services_count = Service.count
    @active_citizen_count =
        Rails.cache.fetch("active-citizens-count-landing-page-cache", :expires_in => 1.hours) do
          SurveyAnswer.pluck(:user_id).uniq.count
        end

    @public_servant_assessed_count =
        Rails.cache.fetch("public-servant-assessed-count-landing-page-cache", :expires_in => 1.hours) do
      Admin.public_servants_sorted_by_name.count
        end
    @url_video = ENV['VIMEO_VIDEO_KEY'] || '134171429'
  end

  def help
    render layout: 'application'
  end
end
