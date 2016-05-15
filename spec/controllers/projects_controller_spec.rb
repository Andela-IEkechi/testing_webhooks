require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) {create(:user)}

  before(:each) do
    sign_in(user)
    @request.env["CONTENT_TYPE"] = "application/json"
  end

  describe "index" do
    Member::ROLES.each do |role|
      context "as #{role}" do    
        it "returns 200 when authorised" do
          get :index 
          expect(response.status).to eq(200)
        end

        it "returns allowed projects" do
          5.times do
            #it's not important which role the user has, as long as they have a membership
            create(:member, user: user)
            create(:member)
          end

          get :index
          json = JSON.parse(response.body)
          expect(json.count).to eq(5)
        end
      end   
    end   
  end

  describe "show" do
    before(:each) do
      #set up a project to show
      @project = create(:project)
      @params = {:id => @project.id}
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

        it "can be found by it's slug" do
          @params[:id] = @project.slug
          get :show, params: @params 
          expect(response.status).to eq(200)
        end

        it "can be found by it's id" do
          get :show, params: @params 
          expect(response.status).to eq(200)
        end

        it "returns the project" do
          get :show, params: @params 
          json = JSON.parse(response.body)
          # Use this one clever trick to match timestamps. You won't believe what happe... oh fuckit.
          expect(json).to eq(JSON.parse(@project.attributes.to_json))
        end    
      end
    end
  end

  describe "create" do
    before(:each) do
      #set up a project to show
      @project = build(:project)
      @params = {project: @project.attributes}
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        it "returns 200 when authorised" do
          post :create, params: @params 
          expect(response.status).to eq(200)
        end    

        it "returns the new project when created" do
          post :create, params: @params 
          expect(Project.friendly.where(name: @project.name).any?).to eq(true)
        end   

        it "creates an associated membership for the user when the new project is created" do
          post :create, params: @params 
          project = Project.friendly.where(name: @project.name).first
          expect(project.members.where(user: user).any?).to eq(true)
        end    

        it "returns 422 when it failed to create" do
          @params[:project][:name] = nil #invalid
          post :create, params: @params 
          expect(response.status).to eq(422)
        end   

        it "returns error messages when it failed to create" do
          @params[:project][:name] = nil #invalid
          post :create, params: @params 
          json = JSON.parse(response.body)
          expect(json).to eq({"errors"=>["Name can't be blank"]})
        end       
      end       
    end       
  end

  describe "update" do
    before(:each) do
      #set up a project to show
      @project = create(:project)
      @params = {id: @project.id, project: {name: "updated project name"}}
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

        it "can be updated by slug" do
          @params[:id] = @project.slug
          put :update, params: @params 
          expect(response.status).to eq(200)
        end    

        it "returns the updated project" do
          put :update, params: @params 
          json = JSON.parse(response.body)
          @project.reload
          expect(json).to eq(JSON.parse(@project.attributes.to_json))
        end   

        it "returns 422 when it failed to update" do
          @params[:project][:name] = nil #invalid
          put :update, params: @params 
          expect(response.status).to eq(422)
        end 

        it "returns error messages when it failed to update" do
          @params[:project][:name] = nil #invalid
          put :update, params: @params 
          json = JSON.parse(response.body)
          expect(json).to eq({"errors"=>["Name can't be blank"]})
        end     
      end  
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
  end

  describe "delete" do
    before(:each) do
      @project = create(:project)
      @params = {id: @project.id}
    end

    (Member::ROLES - ["owner"]).each do |role|
      before(:each) do
        create(role.to_sym, user: user, project: @project)
      end

      context "as #{role}" do
        it "returns 302 when not authorised" do
          put :destroy, params: @params 
          expect(response.status).to eq(302)
        end  

        it "leaves the project unchanged" do
          put :destroy, params: @params 
          @project.reload
          expect(@project.created_at).to eq(@project.updated_at)
        end            
      end    
    end 

    ["owner"].each do |role|
      context "as #{role}" do
        before(:each) do
          create(role.to_sym, user: user, project: @project)
        end

        it "returns 200 when authorised" do
          delete :destroy, params: @params 
          expect(response.status).to eq(200)
        end    

        it "deletes the project" do
          expect {
            delete :destroy, params: @params 
          }.to change(Project, :count).by(-1)
        end   

        it "returns the deleted project" do
          delete :destroy, params: @params 
          json = JSON.parse(response.body)
          expect(json).to eq(JSON.parse(@project.attributes.to_json))
        end   

        it "returns 404 when it can't find the project" do
          @params[:id] = "000" #invalid project ID to delete
          delete :destroy, params: @params 
          expect(response.status).to eq(404)
        end 
      end  
    end   
  end

end
