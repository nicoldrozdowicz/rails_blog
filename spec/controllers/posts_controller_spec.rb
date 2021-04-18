require 'rails_helper'

RSpec.describe PostsController  do
  let(:parsed_response_body) { JSON.parse(response.body) }

  describe "#create" do
    let(:params) { {:post => { :title => "title", :content => "content" } } }

    it "is successful" do
      post :create, :params => params
      expect(response).to have_http_status(:ok)
    end

    it "creates a post" do
      expect { post :create, :params => params }
        .to change { Post.count }
        .by(1)
    end

    it "returns the id of the new post" do
      post :create, :params => params
      expect(parsed_response_body["id"]).to eq(Post.order("created_at").last.id)
    end
  end

  describe "#read" do
    let(:id) { @post.id }
    let(:params) { { :id => id } }

    before { @post = Post.create!(:title => "please", :content => "hire me") }

    it "is successful" do
      get :show, :params => params
      expect(response).to have_http_status(:ok)
    end

    it "returns information about the post with the given id", :aggregate_failures do
      get :show, :params => params
      expect(parsed_response_body["id"]).to eq(id)
      expect(parsed_response_body["title"]).to eq("please")
      expect(parsed_response_body["content"]).to eq("hire me")
    end
  end

  describe "#update" do
    let(:id) { @post.id }
    let(:params) { { :id => id, :post => { :content => "updated" } } }

    before { @post = Post.create!(:title => "hire me", :content => "original") }

    it "is successful" do
      put :update, :params => params
      expect(response).to have_http_status(:ok)
    end

    it "updates the post with the given id" do
      expect { put :update, :params => params }
        .to change { Post.find(id).content }
        .from("original")
        .to("updated")
    end

    it "returns information about the udpated post", :aggregate_failures do
      put :update, :params => params
      expect(parsed_response_body["id"]).to eq(id)
      expect(parsed_response_body["title"]).to eq("hire me")
      expect(parsed_response_body["content"]).to eq("updated")
    end
  end

  describe "#destroy" do
    let(:id) { @post.id }
    let(:params) { { :id => id } }

    before { @post = Post.create!(:title => "please", :content => "hire me") }

    it "is successful" do
      delete :destroy, :params => params
      expect(response).to have_http_status(:ok)
    end

    it "destroys the post with the given id" do
      expect { delete :destroy, :params => params }
        .to change { Post.exists?(:id => id) }
        .from(true)
        .to(false)
    end

    it "returns a json indicating that the post was successfully destroyed" do
      delete :destroy, :params => params
      expect(parsed_response_body["success"]).to eq(true)
    end 
  end
end