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
        if @sprint
          get :index, :project_id => @project.id, :sprint_id => @sprint.id
        elsif @feature
          get :index, :project_id => @project.id, :feature_id => @feature.id
        else
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
        if @sprint
          assigns(:tickets).each do |ticket|
            ticket.feature.should == @sprint
          end
        end
      end

      it "renders the :index template" do
        response.should render_template(:index)
      end
    end

    describe "GET #show" do
      before(:each) do
        if @sprint
          get :show, :project_id => @project.id, :sprint_id => @sprint.id, :id => @ticket
        elsif @feature
          get :show, :project_id => @project.id, :feature_id => @feature.id, :id => @ticket
        else
          get :show, :project_id => @project.id, :id => @ticket
        end
      end

      it "renders the :show template" do
        response.should render_template(:show)
      end
    end

    describe "GET #new" do
      before(:each) do
        if @sprint
          get :new, :project_id => @project.id, :sprint_id => @sprint.id
        elsif @feature
          get :new, :project_id => @project.id, :feature_id => @feature.id
        else
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

      it "@ticket is scoped to the correct @sprint" do
        assigns(:ticket).sprint.should == @sprint
      end

      it "renders the :new template" do
        response.should render_template(:new)
      end
    end

    describe "GET #edit" do
      before(:each) do
        if @sprint
          get :edit, :project_id => @project.id, :sprint_id => @sprint.id, :id => @ticket.scoped_id
        elsif @feature
          get :edit, :project_id => @project.id, :feature_id => @feature.id, :id => @ticket.scoped_id
        else
          get :edit, :project_id => @project.id, :id => @ticket.scoped_id
        end
      end

      it "assigns the requested ticket to @ticket" do
        assigns(:ticket).should == @ticket
      end

      it "renders the :edit template" do
        response.should render_template(:edit)
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        before(:each) do
          @attrs = attributes_for(:ticket, :project_id => @project.id)
          @attrs.merge!(:comments_attributes => { 0 => attributes_for(:comment, :status_id => @project.ticket_statuses.first.id)})
        end

        it "saves a new ticket to the database" do
          expect {
            if @sprint
              @attrs.merge!(:project_id => @project.id, :sprint_id => @sprint.id)
              post :create, :project_id => @project.id, :sprint_id => @sprint.id, :ticket => @attrs
            elsif @feature
              @attrs.merge!(:project_id => @project.id, :feature_id => @feature.id)
              post :create, :project_id => @project.id, :feature_id => @feature.id, :ticket => @attrs
            else
              post :create, :project_id => @project.id, :ticket => @attrs
            end
          }.to change(Ticket, :count).by(1)
        end

        it "redirects to show the ticket" do
          if @sprint
            @attrs.merge!(:project_id => @project.id, :sprint_id => @sprint.id)
            post :create, :project_id => @project.id, :sprint_id => @sprint.id, :ticket => @attrs
            response.should be_redirect
            response.should redirect_to(project_ticket_path(@project, assigns(:ticket).id, :sprint_id => @sprint))
          elsif @feature
            @attrs.merge!(:project_id => @project.id, :feature_id => @feature.id)
            post :create, :project_id => @project.id, :feature_id => @feature.id, :ticket => @attrs
            response.should be_redirect
            response.should redirect_to(project_ticket_path(@project, assigns(:ticket).id, :feature_id => @feature))
          else
            post :create, :project_id => @project.id, :ticket => @attrs
            response.should be_redirect
            response.should redirect_to(project_ticket_path(@project, assigns(:ticket).id))
          end
        end
      end
      context "with invalid attributes" do
        it "does not save a new ticket in the database" do
          expect {
            if @sprint
              post :create, :project_id => @project.id, :feature_id => @sprint.id, :ticket => attributes_for(:invalid_ticket, :project_id => @project.id, :sprint_id => @sprint.id)
            elsif @feature
              post :create, :project_id => @project.id, :feature_id => @feature.id, :ticket => attributes_for(:invalid_ticket, :project_id => @project.id, :feature_id => @feature.id)
            else
              post :create, :project_id => @project.id, :ticket => attributes_for(:invalid_ticket, :project_id => @project.id)
            end
          }.to_not change(Ticket, :count).by(1)
        end

        it "re-renders the :new template" do
          if @sprint
            post :create, :project_id => @project.id, :sprint_id => @sprint.id, :ticket => attributes_for(:invalid_ticket, :project_id => @project.id, :sprint_id => @sprint.id)
          elsif @feature
            post :create, :project_id => @project.id, :feature_id => @feature.id, :ticket => attributes_for(:invalid_ticket, :project_id => @project.id, :feature_id => @feature.id)
          else
            post :create, :project_id => @project.id, :ticket => attributes_for(:invalid_ticket, :project_id => @project.id)
          end
          response.should render_template(:new)
        end
      end
    end

    describe "POST #update" do
      context "with valid attributes" do
        before(:each) do
          @attrs = attributes_for(:ticket)
        end

        it "updates a ticket in the database" do
          expect {
            if @sprint
              post :update, :project_id => @project.id, :sprint_id => @sprint.id, :id => @ticket, :ticket => @attrs
            elsif @feature
              post :update, :project_id => @project.id, :feature_id => @feature.id, :id => @ticket, :ticket => @attrs
            else
              post :update, :project_id => @project.id, :id => @ticket, :ticket => @attrs
            end
            @ticket.reload
          }.to change(@ticket, :updated_at)
        end

        it "redirects to show the ticket" do
          if @sprint
            post :update, :project_id => @project.id, :sprint_id => @sprint.id, :id => @ticket, :ticket => @attrs
            response.should be_redirect
            response.should redirect_to(project_ticket_path(@project, assigns(:ticket).id, :feature_id => @feature))
          elsif @feature
            post :update, :project_id => @project.id, :feature_id => @feature.id, :id => @ticket, :ticket => @attrs
            response.should be_redirect
            response.should redirect_to(project_ticket_path(@project, assigns(:ticket).id, :feature_id => @feature))
          else
            post :update, :project_id => @project.id, :id => @ticket, :ticket => @attrs
            response.should be_redirect
            response.should redirect_to(project_ticket_path(@project, assigns(:ticket).id))
          end
        end
      end
      context "with invalid attributes" do
        before(:each) do
          @attrs = attributes_for(:invalid_ticket)
          @attrs.merge!(:comments_attributes => { 0 => attributes_for(:comment, :status_id => @project.ticket_statuses.first.id)})
        end

        it "does not update the ticket in the database" do
          updated_before = @ticket.updated_at
          if @sprint
            post :update, :project_id => @project.id, :sprint_id => @sprint.id, :id => @ticket, :ticket => @attrs
          elsif @feature
            post :update, :project_id => @project.id, :feature_id => @feature.id, :id => @ticket, :ticket => @attrs
          else
            post :update, :project_id => @project.id, :id => @ticket, :ticket => @attrs
          end
          @ticket.reload
          @ticket.updated_at.to_s.should == updated_before.to_s
        end

        it "re-renders the :edit template" do
          if @sprint
            post :update, :project_id => @project.id, :sprint_id => @sprint.id, :id => @ticket, :ticket => @attrs
          elsif @feature
            post :update, :project_id => @project.id, :feature_id => @feature.id, :id => @ticket, :ticket => @attrs
          else
            post :update, :project_id => @project.id, :id => @ticket, :ticket => @attrs
          end
          response.should render_template(:edit)
        end
      end
    end

    describe "DELETE #destroy" do
      it "deletes a ticket from the database" do
        expect {
          if @sprint
            delete :destroy, :id => @ticket, :project_id => @project, :sprint_id => @sprint.id
          elsif @feature
            delete :destroy, :id => @ticket, :project_id => @project, :feature_id => @feature.id
          else
            delete :destroy, :id => @ticket, :project_id => @project
          end
        }.to change(Ticket, :count).by(-1)
      end

      it "redirects to the ticket index" do
        if @sprint
          delete :destroy, :id => @ticket, :project_id => @project, :sprint_id => @sprint.id
          response.should redirect_to(project_feature_path(@project, @sprint))
        elsif @feature
          delete :destroy, :id => @ticket, :project_id => @project, :feature_id => @feature.id
          response.should redirect_to(project_feature_path(@project, @feature))
        else
          delete :destroy, :id => @ticket, :project_id => @project
          response.should redirect_to(project_path(@project))
        end
      end
    end
  end

  it "should open URL slugs correctly" do
    @ticket = create(:ticket, :project => @project, :title => 'alpha beta gamma')
    @ticket.reload
    get :show, :project_id => @project.id, :id => "#{@ticket.id}-alpha-beta-gamma"

    response.should render_template(:show)
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
      @ticket = create(:ticket, :project => @project)
      @ticket.comments << create(:comment, :feature => @feature)
      @ticket.save
      @another_ticket = create(:ticket, :project => @project)
      @another_ticket.comments << create(:comment, :feature => @feature)
      @another_ticket.save
    end
    it "assigns the current feature to @feature"
    it "assigns the current project to @project"
    it_behaves_like "access to tickets"
  end

  context "in the context of a sprint" do
    before(:each) do
      @sprint = create(:sprint, :project => @project)
      @ticket = create(:ticket, :project => @project)
      @ticket.comments << create(:comment, :sprint => @sprint)
      @ticket.save
      @another_ticket = create(:ticket, :project => @project)
      @another_ticket.comments << create(:comment, :sprint => @sprint)
      @another_ticket.save
    end
    it "assigns the current sprint to @sprint"
    it "assigns the current project to @project"
    it_behaves_like "access to tickets"
  end

end
