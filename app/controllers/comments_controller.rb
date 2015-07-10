class CommentsController < ApplicationController
  before_filter :can_comment!
  before_filter :authenticate_admin!, only: [:destroy]

  def create
    @current_session = current_user || current_admin
    @comment = @current_session.comments.build(comment_params)
    if @comment.save
      flash[:success] = "Tu comentario ha sido publicado"
      redirect_to after_comment_path
       unless user_signed_in?
        @service_request = ServiceRequest.find(@comment.service_request_id)
        user_id = User.find(@service_request.requester_id)
        UserMailer.notify_comment_request(user_id , @comment.id).deliver_later
      end
      
    else
      flash[:error] = @comment.errors.full_messages
      redirect_to :back
    end


  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to edit_admins_service_request_path(@comment.service_request)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :service_request_id, :image)
  end

  def can_comment!
    deny_access unless user_signed_in? or admin_signed_in?
  end

  def after_comment_path
    if current_admin
      edit_admins_service_request_path(@comment.service_request)
    else
      service_request_path(@comment.service_request)
    end
  end
end
