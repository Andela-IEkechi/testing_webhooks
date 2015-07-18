require 'spec_helper'
require 'shared/account_status'

describe AssetsController, :type => :controller do
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

      @asset = create(:asset, :comment => @comment, :project => @project)
      filename = "#{Rails.root}/spec/data/dummy.txt"
      @asset.payload = FileUploader.new
      @asset.payload.store!(File.open(filename))
      @asset.save

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
      it "returns a flash message if the project is blocked" do
        get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset
        expect(flash[:alert]).to match(/#{@project.to_s} can not be accessed due to outstanding payment./i)
      end

      it "redirects if the project is blocked" do
        @project.user_id = @user.id
        expect(get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset).to redirect_to(projects_path)
      end

      it "allows access if the project is not blocked" do
        @user.account.unblock!
        @project.user_id = @user.id
        expect(get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset).to_not be_redirect
      end
    end

    context "member" do
      before(:each) do
        @other_user = create(:user)
        @other_user.account.block!
        @project.user_id = @other_user.id

        @member = create(:membership, :user_id => @user.id)
        @project.memberships << @member
        @project.save
        @user.account.unblock!
      end

      it "returns a flash message if the project is blocked" do
        get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset
        expect(flash[:notice]).to match(/#{@project.to_s} is currently unavailable./i)
      end

      it "redirects if the project is blocked" do
        expect(get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset).to redirect_to(projects_path)
      end

      it "allows access if the project is not blocked" do
        @project.user.account.unblock!
        expect(get :download, :project_id => @project, :ticket_id => @ticket, :asset_id => @asset).to_not be_redirect
      end
    end
  end
end
