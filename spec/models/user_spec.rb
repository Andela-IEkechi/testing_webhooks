require 'spec_helper'

describe User,:focus => true do

  context "when confirmed" do
    before(:each) do
      @user = create(:user)
    end
    it "should be able to have many projects" do
      create(:project, :user => @user)
      create(:project, :user => @user)
      @user.reload
      @user.should have(2).projects
    end
  end
end
