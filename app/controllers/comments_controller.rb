class CommentsController < ApplicationController
  before_filter :can_comment!
  before_filter :authenticate_admin!, only: [:destroy]

  def create
    @current_session = current_user || current_admin
    @comment = @current_session.comments.build(params[:comment]) 
    if @comment.save
      flash[:success] = "Tu comentario ha sido publicado"
      redirect_to @comment.report
    else
      flash[:error] = @comment.errors.full_messages
      redirect_to :back
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to @comment.report  
  end

  private

  def can_comment!
    deny_access unless user_signed_in? or admin_signed_in? 
  end
end
