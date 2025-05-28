class CommentsController < ApplicationController
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  include CommentsHelper

  before_action :logged_in_user, only: [:create, :destroy, :edit, :update]
  before_action :correct_user, only: [:destroy, :edit, :update, :show]

  def show; end

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.user = current_user
    @comment.current_user = current_user

    respond_to do |format|
      if @comment.save
        comment = Comment.new
        flash[:success] = 'Comment created!'

        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(dom_id_for_records(@micropost, comment ), partial: 'comments/form', locals: { comment: comment, micropost: @micropost })
        }

        format.html { redirect_back(fallback_location: root_url) }
      else
        flash[:danger] = 'Comment did not create!'

        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(dom_id_for_records(@micropost, @comment ), partial: 'comments/form', locals: { comment: @comment, micropost: @micropost })
        }

        format.html { redirect_back(fallback_location: root_url) }
      end
    end
  end

  def edit; end

  def update
    @comment.current_user = current_user
    
    if @comment.update(comment_params)
      redirect_to @comment
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = 'Comment deleted'

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.remove(dom_id_for_records(@micropost, @comment ), partial: 'comments/comment', locals: { comment: @comment, micropost: @micropost })
      }

      format.html { redirect_back(fallback_location: root_url) }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])

    if @comment.nil?
      flash[:danger] = 'You can only delete/edit your own comments!'

      redirect_back(fallback_location: root_url)
    end
  end
end
