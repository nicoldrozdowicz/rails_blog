class PostsController < ApplicationController
  def create
    post = Post.create!(_post_params)
    render :json => { :id => post.id } 
  end

  def show
    render :json => Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update!(_post_params) 
    render :json => Post.find(params[:id])
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    render :json => { :success => true }
  end

  private

  def _post_params
    params.require(:post).permit(:title, :content)
  end
end
