class Admins::AgenciesController < Admins::AdminController

  def index
    params[:q] ||= {}
    @q = Agency.ransack(params[:q])
    @agencies = @q.result.order(:name)
    render json: @agencies
  end
end
