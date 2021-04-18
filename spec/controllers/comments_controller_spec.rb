require 'rails_helper'

RSpec.describe CommentsController do
  let(:parsed_response_body) { JSON.parse(response.body) }
  let(:post_id) { @post.id }

  before { @post = Post.create!(:title => "please", :content => "hire me") }

  describe "#create" do
    let(:params) do
      { 
        :post_id => post_id,
        :comment => { :name => "nicol", :comment => "she's so smart!" } 
      } 
    end

    it "is successful" do
      post :create, :params => params
      expect(response).to have_http_status(:ok)
    end

    it "creates a comment" do
      expect { post :create, :params => params }
        .to change { Comment.count }
        .by(1)
    end

    it "returns the id of the new comment" do
      post :create, :params => params
      expect(parsed_response_body["id"]).to eq(Comment.order("created_at").last.id)
    end
  end

  describe "#read" do
    let(:id) { @comment.id }
    let(:params) { { :post_id => post_id, :id => id } }

    before { @comment = @post.comments.create!(:name => "nicol", :comment => "she's so smart!") }

    it "is successful" do
      get :show, :params => params
      expect(response).to have_http_status(:ok)
    end

    it "returns information about the comment with the given id", :aggregate_failures do
      get :show, :params => params
      expect(parsed_response_body["id"]).to eq(id)
      expect(parsed_response_body["name"]).to eq("nicol")
      expect(parsed_response_body["comment"]).to eq("she's so smart!")
    end
  end

  describe "#update" do
    let(:id) { @comment.id }
    let(:params) { { :post_id => post_id, :id => id, :comment => { :comment => "updated"} } }

    before { @comment = @post.comments.create!(:name => "nicol", :comment => "original") }

    it "is successful" do
      put :update, :params => params
      expect(response).to have_http_status(:ok)
    end

    it "updates the comment with the given id" do
      expect { put :update, :params => params }
        .to change { Comment.find(id).comment }
        .from("original")
        .to("updated")
    end

    it "returns information about the udpated comment", :aggregate_failures do
      put :update, :params => params
      expect(parsed_response_body["id"]).to eq(id)
      expect(parsed_response_body["name"]).to eq("nicol")
      expect(parsed_response_body["comment"]).to eq("updated")
    end
  end

  describe "#destroy" do
    let(:id) { @comment.id }
    let(:params) { { :post_id => post_id, :id => id } }

    before { @comment = @post.comments.create!(:name => "nicol", :comment => "she's so smart!") }

    it "is successful" do
      delete :destroy, :params => params
      expect(response).to have_http_status(:ok)
    end

    it "destroys the comment with the given id" do
      expect { delete :destroy, :params => params }
        .to change { Comment.exists?(:id => id) }
        .from(true)
        .to(false)
    end

    it "returns a json indicating that the comment was successfully destroyed" do
      delete :destroy, :params => params
      expect(parsed_response_body["success"]).to eq(true)
    end 
  end
end