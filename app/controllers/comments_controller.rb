class CommentsController < ApplicationController
  before_filter :can_comment!

  def create
    @current_session = current_user || current_admin
    @comment = @current_session.comments.build(params[:comment]) 
    if @comment.save
      flash[:success] = "Tu comentario ha sido publicado"
      redirect_to @comment.report
    else
      flash[:error] = "Hubo un problema publicando tu comentario"
      redirect_to :back
    end
  end

  private

  def can_comment!
    deny_access unless user_signed_in? or admin_signed_in? 
  end
end
