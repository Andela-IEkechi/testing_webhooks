require 'spec_helper'

describe ProjectsController do
  before (:each) do
    login_user
    #create a project we can assign tickets to
    @project = create(:project, :user => @user)
  end

  describe "GET #index" do
    before(:each) do
      get :index
    end

    it "populates an array of projects" do
      assigns(:projects).should have(1).item
    end

    it "renders the :index template" do
      response.should render_template("index")
    end

    it "renders the projects we are members of" do
      assigns(:projects).should have(1).item

      new_project = create(:project)
      new_project.memberships << create(:membership, :project => new_project, :user => @user)
      get :index
      assigns(:projects).should have(2).items
    end

    it "does not render projects we are not members of" do
      assigns(:projects).should have(1).item

      new_project = create(:project)
      get :index
      assigns(:projects).should have(1).items
    end

    it "renders each project only once" do
      new_project = create(:project)
      new_project.memberships << create(:membership, :project => new_project, :user => @user)

      new_project.memberships << create(:membership, :project => new_project)
      new_project.memberships << create(:membership, :project => new_project)
      new_project.memberships << create(:membership, :project => new_project)

      get :index
      titles = assigns(:projects).collect(&:title)
      titles.count.should eq(titles.uniq.count)
    end
  end

  describe "GET #show" do
    before(:each) do
      get :show, :id => @project
    end

    it "assigns the requested project to @project" do
      assigns(:project).should == @project
    end

    it "renders the :show template" do
      response.should render_template("show")
    end
  end

  describe "GET #new" do
    before(:each) do
      get :new
    end

    it "assigns a new project to @project" do
      assigns(:project).should be_new_record
    end

    it "renders the :new template" do
      response.should render_template(:new)
    end
  end

  describe "GET #edit" do
    before(:each) do
      get :edit, :id => @project
    end

    it "assigns the requested project to @project" do
      assigns(:project).should == @project
    end

    it "renders the :edit template" do
      response.should render_template(:edit)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves a new project to the database" do
        expect {
          post :create, :project => attributes_for(:project, :user_id => @user.id)
        }.to change(Project, :count).by(1)
      end

      it "redirects to show the project" do
        post :create, :project => attributes_for(:project)
        response.should be_redirect
      end

      it "assigns the new project to @project" do
        post :create, :project => attributes_for(:project, :title => 'something we know')
        assigns(:project).title.should eq('something we know')
      end
    end
    context "with invalid attributes" do
      it "does not save a new project in the database" do
        expect {
          post :create, :project => attributes_for(:invalid_project)
        }.to change(Project, :count).by(0)
      end

      it "re-renders the :new template" do
        post :create, :project => attributes_for(:invalid_project)
        response.should render_template(:new)
      end
    end
  end

  describe "POST #update" do
    context "with valid attributes" do
      before(:each) do
        @attrs = attributes_for(:project)
      end
      it "updates a project to the database" do
        expect {
          post :update, :id => @project, :project => @attrs
          @project.reload
        }.to change(@project, :updated_at)
      end

      it "redirects to show the project" do
        post :update, :id => @project, :project => @attrs
        response.should be_redirect
      end

      it "should set @project the updated project" do
        post :update, :id => @project, :project => @attrs
        assigns(:project).should == @project
      end
    end
    context "with invalid attributes" do
      before(:each) do
        create(:project, :title => 'duplicate', :user => @user)
        @attrs = attributes_for(:invalid_project, :title => 'duplicate')
      end

      it "does not update the project in the database" do
        expect {
          post :update, :id => @project, :project => @attrs
          @project.reload
        }.to_not change(@project, :title)
      end

      it "re-renders the :edit template" do
        post :update, :id => @project, :project => @attrs
        response.should render_template(:edit)
      end

      it "should set @project to the project we are trying to update" do
        post :update, :id => @project, :project => @attrs
        assigns(:project).should == @project
      end
    end
    context "when transferring ownership" do
      before(:each) do
        #create a user to transfer to
        @new_owner = create(:user)
        @project.memberships.create(user_id: @new_owner.id)
      end

      it "should transfer the project to a new user" do
        attrs = {user_id: @new_owner.id, remove_me: '0'}
        post :update, :id => @project, :project => attrs
        @project.reload
        @project.user_id.should eq(@new_owner.id)

        #we should redirect to the project
        response.should be_redirect
        assigns(:project)
      end

      it "should remove the previous owner from the project" do
        attrs = {user_id: @new_owner.id, remove_me: '1'}
        post :update, :id => @project, :project => attrs
        @project.reload
        @project.user_id.should eq(@new_owner.id)

        #we should redirect to the project
        response.should be_redirect
        assigns(:projects)
      end

      it "should not transfer the project if no user is specified" do
        attrs = {user_id: '', remove_me: '0'}
        post :update, :id => @project, :project => attrs
        @project.reload
        @project.user_id.should_not eq(@new_owner.id)

        #we should redirect to the project
        response.should be_redirect
        assigns(:project)
      end

    end
  end

  describe "DELETE #destroy" do
    it "deletes a project from the database" do
      expect {
        delete :destroy, :id => @project
      }.to change(Project, :count).by(-1)
    end

    it "does not delete a project if the owner is not the current user" do
      new_owner = create(:user)
      some_project = create(:project, :user => new_owner)
      expect {
        delete :destroy, :id => some_project
      }.to raise_error(CanCan::AccessDenied)
    end

    it "redirects to the project index" do
      delete :destroy, :id => @project
      response.should be_redirect
    end

    it "should redirect to show the project if delete fails" do
      create(:sprint, :project => @project)
      delete :destroy, :id => @project
      response.should be_redirect
    end
  end
end
