class CommentsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  before_filter do
    @comment_thread = CommentThread.find(params[:comment_thread_id])
    authorize! :read, @comment_thread
  end

  def create
    parent_id = comment_params.delete(:parent_id)
    @comment = @comment_thread.comments.new(comment_params)
    @comment.user = current_user

    if parent_id.present?
      @parent = @comment_thread.comments.find(parent_id)
      @parent.children << @comment
    end

    authorize! :create, @comment
    
    if @comment.save
      respond_with @comment do |f|
        f.html { render partial: "comments/comment", layout: false, locals: { comment: @comment } }
      end
    else
      respond_with @comment do |f|
        f.html { render partial: "comments/form", layout: false, locals: { comment: @comment }, status: :unprocessable_entity }
      end
    end
  end

  def update
    @comment = @comment_thread.comments.find(params[:id])
    authorize! :update, @comment

    if @comment.update_attributes(comment_params)
      respond_with @comment do |f|
        f.html { render partial: "comments/comment", layout: false, locals: { comment: @comment } }
      end
    else
      respond_with @comment do |f|
        f.html { render partial: "comments/form", layout: false, locals: { comment: @comment }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = @comment_thread.comments.find(params[:id])
    authorize! :destroy, @comment

    if @comment.destroy
      respond_with @comment do |f|
        f.html { redirect_to :back }
      end
    else
      respond_with @comment, status: :bad_request do |f|
        f.html { redirect_to :back }
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
