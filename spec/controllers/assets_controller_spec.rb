require 'spec_helper'
require 'shared/account_status'

describe AssetsController do
  before (:each) do
    login_user
    @project = create(:project, :user => @user)
  end

  describe "blocked account" do
    before(:each) do
      @comment = create(:comment, :user => @user)
      @ticket = @comment.ticket
      @comment.project = @project
      @comment.save

      @asset = create(:comment_asset, :comment_id => @comment.id)
      filename = "#{Rails.root}/spec/data/dummy.txt"
      @asset.payload = FileUploader.new
      @asset.payload.store!(File.open(filename))
      @asset.save

      @other_user = create(:user)
      @member = create(:membership, :user_id => @user.id)
      @user.account.block!
    end

    after(:each) do
      @asset.payload.remove!
    end

    context "owner" do
      before(:each) do
        @project.user_id = @user.id
        @project.save
      end
      it "should return a flash message if the project is blocked" do
        get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset
        flash[:alert].should =~ /Project can not be accessed due to outstanding payment./i
      end

      it "should redirect if the project is blocked" do
        @project.user_id = @user.id
        get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset
      end

      it "should allow access if the project is not blocked" do
        @user.account.unblock!
        @project.user_id = @user.id
        get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset
        response.should_not be_redirect
      end
    end

    context "member" do
      before(:each) do
        @project.user_id = @other_user.id
        @project.memberships<< @member
        @project.save
      end
      it "should return a flash message if the project is blocked" do      
        get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset
        flash[:notice].should =~ /Project is currently unavailable./i
      end

      it "should redirect if the project is blocked" do
        get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset
        response.should be_redirect
      end

      it "should allow access if the project is not blocked" do
        @project.user.account.unblock!
        get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset
        response.should_not be_redirect
      end
    end
  end
end
