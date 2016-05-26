require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  let(:user) {create(:user)}

  before(:each) do
    sign_in(user)
    @request.env["CONTENT_TYPE"] = "application/json"

    @membership = create(:member, user: user)
    @project = @membership.project
    @params = {project_id: @project.id}
  end

  describe "index" do
    Member::ROLES.each do |role|
      context "as #{role}" do    
        it "returns 200 when authorised" do
          get :index, params: @params
          expect(response.status).to eq(200)
        end

        it "returns allowed tickets" do
          5.times do
            create(:ticket, project: @project)
            create(:ticket)
          end

          get :index, params: @params
          json = JSON.parse(response.body)
          expect(json.count).to eq(5)
        end
      end   
    end   
  end

  describe "show" do
    before(:each) do
      #set up a ticket to show
      @ticket = create(:ticket, project: @project)
      @params.merge!({id: @ticket.sequential_id})

      #strip away the project membership
      @project.members.delete_all
    end
    
    Member::ROLES.each do |role|
      context "as #{role}" do 
        before(:each) do
          create(role.to_sym, user: user, project: @project)
        end

        it "returns 200 when authorised" do
          get :show, params: @params 
          expect(response.status).to eq(200)
        end

        it "returns 404 when not found" do
          @params[:id] = "not valid"
          get :show, params: @params 
          expect(response.status).to eq(404)
        end

        it "can be found by it's sequential id" do
          @params[:id] = @ticket.sequential_id
          get :show, params: @params 
          expect(response.status).to eq(200)
        end

        it "can not be found by it's id" do
          @params[:id] = @ticket.id
          get :show, params: @params 
          expect(response.status).to eq(404)
        end

        it "returns the ticket" do
          get :show, params: @params 
          json = JSON.parse(response.body)
          # Use this one clever trick to match timestamps. You won't believe what happe... oh fuckit.
          expect(json).to eq(JSON.parse(@ticket.to_json))
        end    
      end
    end
  end

  describe "new" do
    before(:each) do
      ticket = create(:ticket, project: @project)
      @comment = create(:comment, ticket: ticket)
      @ticket = build(:ticket, project: @project)
      @params.merge!(comment_id: @comment.id)

      #strip away the project membership
      @project.members.delete_all
    end

    (Member::ROLES - ["restricted"]).each do |role|
      context "as #{role}" do
        before(:each) do
          create(role.to_sym, user: user, project: @project)
        end

        it "splits ticket when authorised" do
          get :new, params: @params
          expect(response.status).to eq(200)
        end

        it "returns the split ticket" do
          @controller = TicketsController.new

          get :new, params: @params
          json = JSON.parse(response.body)
          expect(json['comments']).not_to be_empty
          expect(json['comments'][0]['message']).to eq(@controller.send(:parent_comment_message, @comment))
        end
      end
    end
  end

  describe "create" do
    before(:each) do
      #set up a ticket to show
      @ticket = build(:ticket, project: @project)
      @params.merge!(ticket: {title: @ticket.title})

      #strip away the project membership
      @project.members.delete_all      
    end

    ["restricted"].each do |role|
      context "as #{role}" do
        before(:each) do
          create(role.to_sym, user: user, project: @project)
        end

        it "returns 302 when not authorised" do
          post :create, params: @params 
          expect(response.status).to eq(302)
        end    

        it "redirects when not authorised"  do
          post :create, params: @params 
          expect(response).to redirect_to(root_path)
        end   

        it "does not create a new ticket" do
          expect {
            post :create, params: @params 
          }.not_to change{Ticket.count}
        end          
      end       
    end       

    (Member::ROLES - ["restricted"]).each do |role|
      context "as #{role}" do
        before(:each) do
          create(role.to_sym, user: user, project: @project)
          assert Ticket.none?, "no tickets expected"
        end

        it "returns 200 when authorised" do
          post :create, params: @params 
          expect(response.status).to eq(200)
        end    

        it "returns the new ticket when created" do
          post :create, params: @params 
          json = JSON.parse(response.body)
          expect(json).to eq(JSON.parse(@project.tickets.first.to_json))
        end   

        it "creates a new ticket with the title provided" do
          post :create, params: @params 
          json = JSON.parse(response.body)
          expect(json["title"]).to eq(@ticket.title)
        end 

        it "associates the newly created ticket with the project" do
          post :create, params: @params 
          json = JSON.parse(response.body)
          expect(@project.tickets.first.project_id).to eq(@project.id)
        end    

        it "creates an associated comment" do
          post :create, params: @params 
          ticket = @project.tickets.first
          expect(ticket.comments.any?).to eq(true)
        end    

        it "associated comment belongs to the user" do
          post :create, params: @params 
          ticket = @project.tickets.first
          expect(ticket.comments.where(commenter_id: user.id).any?).to eq(true)
        end    

        it "returns 422 when it failed to create" do
          @params[:ticket] = {title: nil} #invalid
          post :create, params: @params 
          expect(response.status).to eq(422)
        end   

        it "returns error messages when it failed to create" do
          @params[:ticket] = {title: nil} #invalid
          post :create, params: @params 
          json = JSON.parse(response.body)
          expect(json).to eq({"errors"=>["Title can't be blank"]})
        end       
      end       
    end       
  end

  describe "update" do
    before(:each) do
      #set up a ticket to show
      @ticket = create(:ticket, project: @project)
      #NOTE: @ticket.to_param will return the sequential_id 
      @params.merge!(id: @ticket.to_param, ticket: {title: "updated ticket title"})

      #strip away the project membership
      @project.members.delete_all      
    end    

    (Member::ROLES - ["owner", "administrator"]).each do |role|
      before(:each) do
        create(role.to_sym, user: user, project: @project)
      end

      context "as #{role}" do
        it "returns 302 when not authorised" do
          put :update, params: @params 
          expect(response.status).to eq(302)
        end  

        it "leaves the project unchanged" do
          put :update, params: @params 
          @project.reload
          expect(@project.created_at).to eq(@project.updated_at)
        end            
      end    
    end  

    ["owner", "administrator"].each do |role|
      context "as #{role}" do
        before(:each) do
          create(role.to_sym, user: user, project: @project)
        end

        it "returns 200 when authorised" do
          put :update, params: @params 
          expect(response.status).to eq(200)
        end   

        it "cannot be updated by id (as opposed to sequential_id)" do
          @params[:id] = @ticket.id
          put :update, params: @params 
          expect(response.status).to eq(404)
        end    

        it "returns the updated ticket" do
          put :update, params: @params 
          json = JSON.parse(response.body)
          @ticket.reload
          expect(json).to eq(JSON.parse(@ticket.to_json))
        end   

        it "returns 422 when it failed to update" do
          @params[:ticket][:title] = nil #invalid
          put :update, params: @params 
          expect(response.status).to eq(422)
        end 

        it "returns error messages when it failed to update" do
          @params[:ticket][:title] = nil #invalid
          put :update, params: @params 
          json = JSON.parse(response.body)
          expect(json).to eq({"errors"=>["Title can't be blank"]})
        end     
      end  
    end   
  end

  describe "delete" do
    before(:each) do
      #set up a ticket to show
      @ticket = create(:ticket, project: @project)
      #NOTE: @ticket.to_param will return the sequential_id 
      @params.merge!(id: @ticket.to_param)

      #strip away the project membership
      @project.members.delete_all 
    end

    (Member::ROLES - ["owner", "administrator"]).each do |role|
      before(:each) do
        create(role.to_sym, user: user, project: @project)
      end

      context "as #{role}" do
        it "returns 302 when not authorised" do
          put :destroy, params: @params 
          expect(response.status).to eq(302)
        end  

        it "leaves the ticket unchanged" do
          put :destroy, params: @params 
          @ticket.reload
          expect(@ticket.created_at).to eq(@ticket.updated_at)
        end            
      end    
    end 

    ["owner", "administrator"].each do |role|
      context "as #{role}" do
        before(:each) do
          create(role.to_sym, user: user, project: @project)
        end

        it "returns 200 when authorised" do
          delete :destroy, params: @params 
          expect(response.status).to eq(200)
        end    

        it "deletes the ticket" do
          expect {
            delete :destroy, params: @params 
          }.to change(Ticket, :count).by(-1)
        end   

        it "returns the deleted ticket" do
          delete :destroy, params: @params 
          json = JSON.parse(response.body)
          expect(json).to eq(JSON.parse(@ticket.to_json))
        end    
      end  
    end   
  end

end
