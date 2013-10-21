class Admins::DashboardsController < Admins::AdminController

  def design
    @logos = Logo.by_position
  end

end
