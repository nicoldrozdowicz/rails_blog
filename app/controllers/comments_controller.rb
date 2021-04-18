class CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    comment = post.comments.create!(_comment_params)
    render :json => { :id => comment.id } 
  end

  def show
    post = Post.find(params[:post_id])
    render :json => post.comments.find(params[:id])
  end

  def update
    post = Post.find(params[:post_id])
    comment = post.comments.find(params[:id])
    comment.update!(_comment_params)
    render :json => post.comments.find(params[:id])
  end

  def destroy
    post = Post.find(params[:post_id])
    comment = post.comments.find(params[:id])
    comment.destroy
    render :json => { :success => true }
  end

  private

  def _comment_params
    params.require(:comment).permit(:name, :comment)
  end
end