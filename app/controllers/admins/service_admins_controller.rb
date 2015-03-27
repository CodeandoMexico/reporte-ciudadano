class Admins::ServiceAdminsController < ApplicationController
  def index
    @service_admins = Admin.service_admins_sorted_by_name.page(params[:page]).per(25)
  end
end
