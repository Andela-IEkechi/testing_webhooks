require 'spec_helper'
require 'shared/account_status'

describe CommentsController, :type => :controller do
  before (:each) do
    login_user
    @project = create(:project, :user => @user)
  end

  describe "GET #index" do
    it "does nothing"
  end

  describe "GET #show" do
    it "does nothing"
  end

  describe "GET #new" do
    it "does nothing"
  end

  describe "GET #edit" do
    it "renders the :edit template"
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves a new comment to the database"
      context "for project administrators" do
        it "overrides the current sprint and feature"
      end
      context "for regular users" do
        it "does not override the current sprint and feature"
      end
      it "redirects to show the comment's ticket"
    end
    context "with invalid attributes" do
      it "does not save a new comment in the database"
      it "re-renders the :edit template"
    end
  end

  describe "POST #update" do
    context "with valid attributes" do
      it "updates a comment in the database"
      context "for project administrators" do
        it "overrides the current sprint and feature"
      end
      context "for regular users" do
        it "does not override the current sprint and feature"
      end

      it "redirects to show the comment's ticket"
    end

    context "with invalid attributes" do
      it "does not update the comment in the database"
      it "re-renders the :edit template"
    end
  end

  describe "DELETE #destroy" do
    it "deletes a comment from the database"
    it "redirects to show the ticket"
  end

  describe "blocked account" do
    before(:each) do
      @comment = create(:comment, :user => @user)
      @ticket = @comment.ticket
      @comment.project = @project
      @comment.save
      @params = {:project_id => @project, :ticket_id => @ticket, :id => @comment}
      @other_user = create(:user)
      @member = create(:membership, :user_id => @user.id)
      @user.account.block!
    end

    context "owner" do
      before(:each) do
        @project.user_id = @user.id
        @project.save
      end
      it "should return a flash message if the project is blocked" do
        get :destroy, :project_id => @project, :ticket_id => @ticket, :id => @comment
        flash[:alert].should =~ /Project can not be accessed due to outstanding payment./i
      end

      it "should redirect if the project is blocked" do
        @project.user_id = @user.id
        get :destroy, :project_id => @project, :ticket_id => @ticket, :id => @comment
        response.should be_redirect
      end

      it "should allow access if the project is not blocked" do
        @user.account.unblock!
        @project.user_id = @user.id
        get :destroy, :project_id => @project, :ticket_id => @ticket, :id => @comment
        flash[:alert] =~ /Cannot remove the only comment/i
      end
    end

    context "member" do
      before(:each) do
        @project.user_id = @other_user.id
        @project.memberships<< @member
        @project.save
      end
      it "should return a flash message if the project is blocked" do
        get :destroy, :project_id => @project, :ticket_id => @ticket, :id => @comment
        flash[:notice].should =~ /Project is currently unavailable./i
      end

      it "should redirect if the project is blocked" do
        get :destroy, :project_id => @project, :ticket_id => @ticket, :id => @comment
        response.should be_redirect
      end

      it "should allow access if the project is not blocked" do
        @project.user.account.unblock!
        get :destroy, :project_id => @project, :ticket_id => @ticket, :id => @comment
        flash[:alert] =~ /Cannot remove the only comment/i
      end
    end
  end
end
