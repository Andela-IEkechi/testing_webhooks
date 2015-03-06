require 'spec_helper'

describe OverviewsController, :type => :controller do
  before (:each) do
    login_user
    @overview = create(:overview, :user => @user)
  end

  describe "DELETE #destroy" do
    it "deletes a overview from the database" do
      expect {
        delete :destroy, :id => @overview.to_param, :user_id => @user.to_param
      }.to change(Overview, :count).by(-1)
    end

    it "does not delete the user account" do
        expect {
          delete :destroy, :id => @overview.to_param, :user_id => @user.to_param
        }.to_not change(User, :count)
    end
  end
end
