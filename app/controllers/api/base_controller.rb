class Api::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :restrict_access
  before_filter :skip_trackable

  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end

  private

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|  
        ApiKey.exists?(access_token: token)
      end
    end
end
