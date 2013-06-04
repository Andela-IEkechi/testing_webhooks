require 'spec_helper'

describe TicketsController do
  before (:each) do
    login_user
    #create a project we can assign tickets to
    @project = create(:project, :user => @user)
  end

  shared_examples("access to tickets") do
    describe "GET #index" do
      before(:each) do
        if @sprint
          get :index, :project_id => @project.to_param, :sprint_id => @sprint.to_param
        elsif @feature
          get :index, :project_id => @project.to_param, :feature_id => @feature.to_param
        else
          get :index, :project_id => @project.to_param
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

      it "uses only tickets for the current @feature or @sprint if it's assigned" do
        if @feature
          assigns(:tickets).each do |ticket|
            ticket.feature.should == @feature
          end
        end
        if @sprint
          assigns(:tickets).each do |ticket|
            ticket.sprint.should == @sprint
          end
        end
      end

      it "redirects to the project path on an HTML call" do
        response.should redirect_to("/projects/#{@project.to_param}")
      end
    end

    describe "GET #show" do
      before(:each) do
        if @sprint
          get :show, :project_id => @project.to_param, :sprint_id => @sprint.to_param, :id => @ticket
        elsif @feature
          get :show, :project_id => @project.to_param, :feature_id => @feature.to_param, :id => @ticket
        else
          get :show, :project_id => @project.to_param, :id => @ticket
        end
      end

      it "renders the :show template" do
        response.should render_template(:show)
      end
    end

    describe "GET #new" do
      before(:each) do
        if @sprint
          get :new, :project_id => @project.to_param, :sprint_id => @sprint.to_param
        elsif @feature
          get :new, :project_id => @project.to_param, :feature_id => @feature.to_param
        else
          get :new, :project_id => @project.to_param
        end
      end

      it "assigns a new ticket to @ticket" do
        assigns(:ticket).should_not be_nil
        assigns(:ticket).should be_new_record
      end

      it "@ticket is scoped to the correct @project" do
        @ticket.project.id.should == @project.id
      end

      it "@ticket is scoped to the correct @feature or @feature" do
        @ticket.feature.id.should == @feature.id if @feature
        @ticket.sprint.id.should == @sprint.id if @sprint
      end

      it "renders the :new template" do
        response.should render_template(:new)
      end
    end

    describe "GET #edit" do
      before(:each) do
        if @sprint
          get :edit, :project_id => @project.to_param, :sprint_id => @sprint.to_param, :id => @ticket.scoped_id
        elsif @feature
          get :edit, :project_id => @project.to_param, :feature_id => @feature.to_param, :id => @ticket.scoped_id
        else
          get :edit, :project_id => @project.to_param, :id => @ticket.scoped_id
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
          status = create(:ticket_status, :project => @project)
          @attrs = attributes_for(:ticket, :project_id => @project.to_param)
          @attrs.merge!(:comments_attributes => { 0 => attributes_for(:comment, :status_id => status.id)})
          @attrs.merge!(:comments_attributes => { 0 => attributes_for(:comment, :status_id => status.id, :sprint_id => @sprint.to_param)}) if @sprint
          @attrs.merge!(:comments_attributes => { 0 => attributes_for(:comment, :status_id => status.id, :feature_id => @feature.to_param)}) if @feature
        end

        it "saves a new ticket to the database" do
          expect {
            post :create, :project_id => @project.to_param, :ticket => @attrs
          }.to change(Ticket, :count).by(1)
        end

        it "redirects to show the ticket" do
          post :create, :project_id => @project.to_param, :ticket => @attrs
          response.should be_redirect
          response.should redirect_to(project_ticket_path(@project, assigns(:ticket).to_param))
        end
      end
      context "with invalid attributes" do
        it "does not save a new ticket in the database" do
          expect {
            post :create, :project_id => @project.to_param, :ticket => attributes_for(:invalid_ticket, :project_id => @project.to_param)
          }.to_not change(Ticket, :count).by(1)
        end

        it "re-renders the :new template" do
          post :create, :project_id => @project.to_param, :ticket => attributes_for(:invalid_ticket, :project_id => @project.to_param)
          response.should render_template(:new)
        end
      end
    end

    describe "POST #update" do
      context "with valid attributes" do
        before(:each) do
          @attrs = @ticket.attributes.reject{|attr| ["id", "created_at", "updated_at", "slug", "last_comment_id", "scoped_id"].include?(attr) }
          #mess with the title
          @attrs[:title] = "updated ticket title"
        end

        it "updates a ticket in the database" do
          expect {
            post :update, :project_id => @project.to_param, :id => @ticket.to_param, :ticket => @attrs
            @ticket.reload
          }.to change(@ticket, :updated_at)
        end

        it "redirects to show the ticket" do
          post :update, :project_id => @project.to_param, :id => @ticket.to_param, :ticket => @attrs
          response.should be_redirect
          response.should redirect_to(project_ticket_path(@project, @ticket.to_param))
        end
      end
      context "with invalid attributes" do
        before(:each) do
          @attrs = @ticket.attributes.reject{|attr| ["id", "created_at", "updated_at", "slug", "last_comment_id", "scoped_id"].include?(attr) }
          #mess with the title to make it INVALID
          @attrs[:title] = "x" #too short
        end

        it "does not update the ticket in the database" do
          updated_before = @ticket.updated_at
          post :update, :project_id => @project.to_param, :id => @ticket.to_param, :ticket => @attrs
          @ticket.reload
          @ticket.updated_at.to_s.should == updated_before.to_s
        end

        it "re-renders the :edit template" do
          post :update, :project_id => @project.to_param, :id => @ticket.to_param, :ticket => @attrs
          response.should render_template(:edit)
        end
      end
    end

    describe "DELETE #destroy" do
      it "deletes a ticket from the database" do
        expect {
          delete :destroy, :id => @ticket.to_param, :project_id => @project.to_param
        }.to change(Ticket, :count).by(-1)
      end

      it "redirects to the ticket index" do
        delete :destroy, :id => @ticket.to_param, :project_id => @project.to_param
        response.should redirect_to(project_path(@project)) unless (@sprint || @feature)
        response.should redirect_to(project_sprint_path(@project, @sprint)) if @sprint
        response.should redirect_to(project_feature_path(@project, @feature)) if @feature
      end
    end
  end

  context "in the context of a project" do
    before(:each) do
      @ticket = create(:ticket, :project => @project)
      create(:comment, :ticket => @ticket, :user => @user)
      @ticket.reload
      @ticket.user.should_not be_nil
      @another_ticket = create(:ticket, :project => @project)
      create(:comment, :user => @user, :ticket => @another_ticket)
      @another_ticket.reload
    end
    it_behaves_like "access to tickets"
  end

  context "in the context of a feature" do
    before(:each) do
      @feature = create(:feature, :project => @project)
      @ticket = create(:ticket, :project => @project)
      create(:comment, :feature => @feature, :user => @user, :ticket => @ticket)
      @ticket.reload
      @another_ticket = create(:ticket, :project => @project)
      create(:comment, :feature => @feature, :user => @user, :ticket => @another_ticket)
      @another_ticket.reload
    end
    it_behaves_like "access to tickets"
  end

  context "in the context of a sprint" do
    before(:each) do
      @sprint = create(:sprint, :project => @project)
      @ticket = create(:ticket, :project => @project)
      create(:comment, :sprint => @sprint, :user => @user, :ticket => @ticket)
      @ticket.reload
      @another_ticket = create(:ticket, :project => @project)
      create(:comment, :sprint => @sprint, :user => @user, :ticket => @another_ticket)
      @another_ticket.reload
    end
    it_behaves_like "access to tickets"
  end

  context "when searching for a term" do
    before(:each) do
      @ticket = create(:ticket, :project => @project)
      create(:comment, :user => @user, :ticket => @ticket, :assignee => @user)
      @ticket.reload
      @another_ticket = create(:ticket, :project => @project)
      create(:comment, :user => @user, :ticket => @another_ticket, :assignee => @user)
      @another_ticket.reload
    end

    it "finds only tickets that match the search" do
      get :index, :project_id => @project.to_param, :q => {:title_cont => @ticket.title}
      assigns(:tickets).size.should eq(1)
      assigns(:tickets).first.title.should eq(@ticket.title)
    end

    it "orders tickets by id" do
      get :index, :project_id => @project.to_param, :q => {:title_cont => @user.email}
      assigns(:tickets).size.should eq(2)
      result_ids = assigns(:tickets).collect(&:scoped_id)
      result_ids.should == result_ids.sort
    end

  end

end
