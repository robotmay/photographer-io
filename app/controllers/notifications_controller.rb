class NotificationsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  def index
    @notifications = current_user.notifications.order("created_at DESC").page(params[:page])
    authorize! :read, current_user.notifications.new
    respond_with @notifications
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    authorize! :read, @notification

    path = case @notification.notifiable.class.to_s
    when "Comment"
      photograph_path(@notification.notifiable.comment_thread.threadable)
    else
      root_path
    end

    @notification.mark_as_read

    respond_with @notification do |f|
      f.html { redirect_to path }
    end
  end

  def mark_all_as_read
    @notifications = current_user.notifications.unread
    @notifications.find_each do |n|
      n.mark_as_read
    end

    respond_with @notifications do |f|
      f.html { redirect_to :back }
    end
  end
end
