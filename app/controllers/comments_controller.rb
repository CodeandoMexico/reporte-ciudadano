class CommentsController < ApplicationController
  before_filter :can_comment!
  before_filter :authenticate_admin!, only: [:destroy]

  def create
    @current_session = current_user || current_admin
    @comment = @current_session.comments.build(comment_params)
    if @comment.save
      flash[:success] = "Tu comentario ha sido publicado"
      notify_admins
      redirect_to after_comment_path
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

  def approve
    @comment = Comment.find(params[:id])
    if @comment.update_attribute(:approved, true)
      notify_user(@comment)
      flash[:success] = "El comentario ha sido aprobado"
    end
    redirect_to after_comment_path
  end

  private

  def notify_admins
    pending_comments = Comment.includes(:service_request).pending
    Admin.super_admins.each do |admin|
      AdminMailer.comments_with_pending_moderation_notification(
        admin: admin,
        pending_comments: pending_comments
      ).deliver_now
    end
  end

  def notify_user(comment)
    service_request = ServiceRequest.find(comment.service_request_id)
    user_id = User.find(service_request.requester_id)
    UserMailer.notify_comment_request(user_id , comment.id).deliver_later
  end

  def comment_params
    approved = false
    if user_signed_in?
      approved = true
    end
    params.require(:comment).permit(:content, :service_request_id, :image).merge(approved: approved)
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
