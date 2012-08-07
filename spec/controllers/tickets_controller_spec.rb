require 'spec_helper'

describe TicketsController do
  before (:each) do
    login_user
    #create a project we can assign tickets to
    @project = create(:project, :user => @user)
  end

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  shared_examples("access to tickets") do
    describe "GET #index" do
      before(:each) do
        if @feature
          get :index, :project_id => @project.id, :feature_id => @feature.id
        elsif @project
          get :index, :project_id => @project.id
        end
      end

      it "populates an array of tickets" do
        assigns(:tickets).should_not be_empty
      end

      it "uses only tickets for the current @project if it's assigned" do
        if @project
          assigns(:tickets).each do |ticket|
            ticket.project.should == @project
          end
        end
      end

      it "uses only tickets for the current @feature if it's assigned" do
        if @feature
          assigns(:tickets).each do |ticket|
            ticket.feature.should == @feature
          end
        end
      end

      it "renders the :index template" do
        response.should render_template(:index)
      end
    end

    describe "GET #show" do
      before(:each) do
        if @feature
          get :show, :project_id => @project.id, :feature_id => @feature.id, :id => @ticket
        elsif @project
          get :show, :project_id => @project.id, :id => @ticket
        end
      end

      it "redirect to the :edit action" do
        response.should be_redirect
        parent_path = project_feature_path(@ticket.project, @ticket.feature) if @ticket.feature
        parent_path = project_path(@ticket.project) if @ticket.project
        parent_path ||= tickets_path()
        response.should redirect_to(parent_path)
      end
    end

    describe "GET #new" do
      before(:each) do
        if @feature
          get :new, :project_id => @project.id, :feature_id => @feature.id
        elsif @project
          get :new, :project_id => @project.id
        end
      end

      it "assigns a new ticket to @ticket" do
        assigns(:ticket).should_not be_nil
        assigns(:ticket).should be_new_record
      end

      it "@ticket is scoped to the correct @project" do
        assigns(:ticket).project.should == @project
      end

      it "@ticket is scoped to the correct @feature" do
        assigns(:ticket).feature.should == @feature
      end

      it "renders the :new template" do
        response.should render_template(:new)
      end
    end

    describe "GET #edit" do
      before(:each) do
        if @feature
          get :edit, :project_id => @project.id, :feature_id => @feature.id, :id => @ticket.id
        elsif @project
          get :edit, :project_id => @project.id, :id => @ticket.id
        end
      end

      it "assigns the requested ticket to @ticket" do
        assigns(:ticket).should == @ticket
      end

      it "renders the :edit template" do
        response.should render_template(:edit)
      end
    end

    describe "POST #create", :focus => true do
      context "with valid attributes" do
        it "saves a new ticket to the database" do
          expect {
            if @feature
              post :create, :project_id => @project.id, :feature_id => @feature.id, :ticket => attributes_for(:ticket, :project_id => @project.id, :feature_id => @feature.id, :status_id => @project.ticket_statuses.first.id)
            else
              post :create, :project_id => @project.id, :ticket => attributes_for(:ticket, :project_id => @project.id, :status_id => @project.ticket_statuses.first.id)
            end
          }.to change(Ticket, :count).by(1)
        end

        it "redirects to show the ticket" do
          if @feature
            post :create, :project_id => @project.id, :feature_id => @feature.id, :ticket => attributes_for(:ticket, :project_id => @project.id, :feature_id => @feature.id, :status_id => @project.ticket_statuses.first.id)
            response.should be_redirect
            response.should redirect_to(project_feature_ticket_path(@project, @feature, assigns(:ticket).id))
          else
            post :create, :project_id => @project.id, :ticket => attributes_for(:ticket, :project_id => @project.id, :status_id => @project.ticket_statuses.first.id)
            response.should be_redirect
            response.should redirect_to(project_ticket_path(@project, assigns(:ticket).id))
          end
        end
      end
      context "with invalid attributes" do
        it "does not save a new ticket in the database" do
          expect {
            if @feature
              post :create, :project_id => @project.id, :feature_id => @feature.id, :ticket => attributes_for(:invalid_ticket, :project_id => @project.id, :feature_id => @feature.id, :status_id => @project.ticket_statuses.first.id)
            else
              post :create, :project_id => @project.id, :ticket => attributes_for(:invalid_ticket, :project_id => @project.id, :status_id => @project.ticket_statuses.first.id)
            end
          }.to_not change(Ticket, :count).by(1)
        end

        it "re-renders the :new template" do
          if @feature
            post :create, :project_id => @project.id, :feature_id => @feature.id, :ticket => attributes_for(:invalid_ticket, :project_id => @project.id, :feature_id => @feature.id, :status_id => @project.ticket_statuses.first.id)
          else
            post :create, :project_id => @project.id, :ticket => attributes_for(:invalid_ticket, :project_id => @project.id, :status_id => @project.ticket_statuses.first.id)
          end
          response.should render_template(:new)
        end
      end
    end

    describe "POST #update", :focus => true do
      context "with valid attributes" do
        before(:each) do
          @attrs = attributes_for(:ticket)
        end

        it "updates a ticket to the database" do
          expect {
            if @feature
              post :update, :project_id => @project.id, :feature_id => @feature.id, :id => @ticket, :ticket => @attrs
            else
              post :update, :project_id => @project.id, :id => @ticket, :ticket => @attrs
            end
          }.to change(Ticket, :count).by(1)
        end

        it "redirects to show the ticket" do
          if @feature
            post :update, :project_id => @project.id, :feature_id => @feature.id, :id => @ticket, :ticket => @attrs
            response.should be_redirect
            response.should redirect_to(project_feature_ticket_path(@project, @feature, assigns(:ticket).id))
          else
            post :update, :project_id => @project.id, :id => @ticket, :ticket => @attrs
            response.should be_redirect
            response.should redirect_to(project_ticket_path(@project, assigns(:ticket).id))
          end
        end
      end
      context "with invalid attributes" do
        it "does not update the ticket in the database"
        it "re-renders the :edit template"
      end
    end

    describe "DELETE #destroy" do
      it "deletes a ticket from the database"
      it "redirects to the ticket index"
      it "also deletes related comments"
    end
  end

  context "in the context of a project" do
    before(:each) do
      @ticket = create(:ticket, :project => @project)
      @another_ticket = create(:ticket, :project => @project)
    end
    it "assigns the current project to @project"
    it "does not assign the @feature"
    it_behaves_like "access to tickets"
  end

  context "in the context of a feature" do
    before(:each) do
      @feature = create(:feature, :project => @project)
      @ticket = create(:ticket, :project => @project, :feature => @feature)
      @another_ticket = create(:ticket, :project => @project, :feature => @feature)
    end
    it "assigns the current feature to @feature"
    it "assigns the current project to @project"
    it_behaves_like "access to tickets"
  end

end