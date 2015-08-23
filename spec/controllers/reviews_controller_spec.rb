require 'rails_helper'
require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:product) {Fabricate(:product)}

    context "with authenticated users" do
      let(:current_user) {Fabricate(:user)}
      before {set_current_user(current_user)}

      context "with valid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review), product_id: product.id
        end

        it "redirects to the product show page" do
          expect(response).to redirect_to product
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do
          expect(Review.first.product).to eq(product)
        end

        it "creates a review associated with the signed in user" do
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid inputs" do
        it "does not create a review" do
          post :create, review: {rating: 4}, product_id: product.id
          expect(Review.count).to eq(0)
        end

        it "renders the product/show template" do
          post :create, review: {rating: 4}, product_id: product.id
          expect(response).to render_template "products/show"
        end

        it "sets @product" do
          post :create, review: {rating: 4}, product_id: product.id
          expect(assigns(:product)).to eq(product)
        end

        it "sets @reviews" do
          review = Fabricate(:review, product: product)
          post :create, review: {rating: 4}, product_id: product.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    it_behaves_like "require sign in" do
      let(:action) {post :create, id: 3, product_id: 4}
    end
  end

  describe "DELETE destroy" do
    let(:product) {Fabricate(:product)}
    let(:review){Fabricate(:review, user_id: alice.id, product_id: product.id)}
    let(:alice) {Fabricate(:user)}
    let(:bob) {Fabricate(:user)}
    before {set_current_user(alice)}

    it "redirects to the product show page" do
      delete :destroy, id: review.id, product_id: product.id
      expect(response).to redirect_to product
    end

    it "deletes the review" do
      delete :destroy, id: review.id, product_id: product.id
      expect(Review.count).to eq(0)
    end

    it "does not delete another user's review" do
      bob_review = Fabricate(:review, user_id: bob.id, product_id: product.id)
      delete :destroy, id: bob_review.id, product_id: product.id
      expect(Review.count).to eq(1)
    end
  end

  it_behaves_like "require sign in" do
    let(:action) {delete :destroy, id: 3, product_id: 4}
  end
end