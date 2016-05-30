require 'rails_helper'

RSpec.describe ApiKeysController, type: :controller do
  let(:user) { create(:user) }

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

        it "returns allowed api keys" do
          5.times do
            create(:api_key, project: @project)
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
      @api_key = create(:api_key, project: @project)
      @params.merge!({id: @api_key.id})

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

        it "can be found by it's id" do
          @params[:id] = @api_key.id
          get :show, params: @params
          expect(response.status).to eq(200)
        end

        it "returns the api key" do
          get :show, params: @params
          json = JSON.parse(response.body)
          expect(json).to eq(JSON.parse(@api_key.to_json))
        end
      end
    end
  end


  describe "create" do
    before(:each) do
      @params.merge!(api_key: attributes_for(:api_key))

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

        it "does not create a new api key" do
          expect {
            post :create, params: @params
          }.not_to change{ApiKey.count}
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

        it "returns the new api key when created" do
          post :create, params: @params
          json = JSON.parse(response.body)
          expect(json).to eq(JSON.parse(@project.api_keys.first.to_json))
        end

        it "creates a new ticket with the parameters provided" do
          post :create, params: @params
          json = JSON.parse(response.body)
          expect(json["name"]).to eq(@project.api_keys.first.name)
          expect(json["access_key"]).to eq(@project.api_keys.first.access_key)
        end

        it "associates the newly created api key with the project" do
          post :create, params: @params
          expect(ApiKey.last.project_id).to eq(@project.id)
        end

        it "generates access key for the record" do
          @params[:api_key][:access_key] = nil
          post :create, params: @params
          json = JSON.parse(response.body)
          expect(json["access_key"]).not_to be_nil
        end

        it "returns 422 when it failed to create" do
          @params[:api_key] = { name: nil }
          post :create, params: @params
          expect(response.status).to eq(422)
        end

        it "returns error messages when it failed to create" do
          @params[:api_key] = { name: nil }
          post :create, params: @params
          json = JSON.parse(response.body)
          expect(json).to eq({"errors"=>["Name is too short (minimum is 5 characters)"]})
        end
      end
    end
  end

  describe "delete" do
    before(:each) do
      @api_key = create(:api_key, project: @project)
      @params.merge!(id: @api_key.to_param)

      @project.members.delete_all
    end

    (Member::ROLES - ["owner", "administrator"]).each do |role|
      before(:each) do
        create(role.to_sym, user: user, project: @project)
      end

      context "as #{role}" do
        it "returns 302 when not authorised" do
          delete :destroy, params: @params
          expect(response.status).to eq(302)
        end

        it "leaves the api key unchanged" do
          delete :destroy, params: @params
          @api_key.reload
          expect(@api_key.created_at).to eq(@api_key.updated_at)
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

        it "deletes the api key" do
          expect {
            delete :destroy, params: @params
          }.to change(ApiKey, :count).by(-1)
        end

        it "returns the deleted api key" do
          delete :destroy, params: @params
          json = JSON.parse(response.body)
          expect(json).to eq(JSON.parse(@api_key.to_json))
        end
      end
    end
  end

end
