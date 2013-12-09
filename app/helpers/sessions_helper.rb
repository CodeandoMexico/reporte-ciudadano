module SessionsHelper

  def failure
    redirect_to root_path, notice: "No pudimos terminar el proceso, intenta de nuevo."
  end

end
