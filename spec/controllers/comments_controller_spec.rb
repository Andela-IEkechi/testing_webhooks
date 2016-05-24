require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:assignee) { create(:user) }

  before do
    sign_in(user)
    @request.env["CONTENT_TYPE"] = "application/json"

    @project = create(:project)
    @ticket = create(:ticket, project: @project)
  end

  describe "index" do
    before(:each) do
      @params = {project_id: @project.id, ticket_id: @ticket.id}
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          get :index, params: @params
          expect(response.status).to eq(200)
        end

        it "returns allowed comments" do
          3.times do
            create(:comment, ticket: @ticket)
            create(:comment)
          end

          get :index, params: @params
          json = JSON.parse(response.body)
          expect(json.count).to eq(@ticket.comments.count)
        end

        it "fails to bring up comments if ticket ID is not provided" do
          @params[:ticket_id] = nil
          expect{ get :index, params: @params }.to raise_error(ActionController::UrlGenerationError)
        end

        it "fails to bring up comments if project ID is not provided" do
          @params[:project_id] = nil
          expect{ get :index, params: @params }.to raise_error(ActionController::UrlGenerationError)
        end

        it "it fails to bring up comments if the ticket and project IDs do not match" do
          ticket = create(:ticket, project: @project)
          @params[:ticket_id] = ticket.id

          3.times do
            create(:comment, ticket: @ticket)
          end

          get :index, params: @params
          json = JSON.parse(response.body)
          expect(json.count).to eq(0)
        end
      end
    end
  end

  describe "show" do
    before(:each) do
      @comment = create(:comment, ticket: @ticket, assignee: assignee)
      @params = { project_id: @project.id, ticket_id: @ticket.id, id: @comment.id }
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          get :show, params: @params
          expect(response.status).to eq(200)
        end

        it "returns 404 when not found" do
          @params[:id] = "invalid"
          get :show, params: @params
          expect(response.status).to eq(404)
        end

        it "can be found by it's id" do
          get :show, params: @params
          expect(response.status).to eq(200)
        end

        it "returns the comment" do
          get :show, params: @params
          json = JSON.parse(response.body)
          expect(json).to eq(JSON.parse(@comment.to_json))
        end
      end
    end
  end

  describe "create" do
    before(:each) do
      @comment = build(:comment, ticket_id: @ticket.id)
      @params = { project_id: @project.id, ticket_id: @ticket.id, comment: attributes_for(:comment) }
      @comment.commenter = user
    end

    (Member::ROLES - ["restricted"]).each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          post :create, params: @params
          expect(response.status).to eq(200)
        end
      end
    end

    ["restricted"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 302 when unauthorised" do
          post :create, params: @params
          expect(response.status).to eq(302)
        end
      end
    end
  end

  describe "update" do
    before(:each) do
      @comment = create(:comment, ticket: @ticket, assignee: assignee, commenter: user)
      @params = { project_id: @project.id, ticket_id: @ticket.id,
                 id: @comment.id, comment: attributes_for(:comment) }
      @comment.commenter = user
    end

    (Member::ROLES - ["restricted", "regular"]).each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          put :update, params: @params
          expect(response.status).to eq(200)
        end

        it "returns the updated comment" do
          put :update, params: @params
          json = JSON.parse(response.body)
          @comment.reload
          expect(json).to eq(JSON.parse(@comment.to_json))
        end

        it "does not update without ticket id" do
          @params[:ticket_id] = nil
          expect { put :update, params: @params }.to raise_error(ActionController::UrlGenerationError)
        end

        it "does not update without project id" do
          @params[:project_id] = nil
          expect { put :update, params: @params }.to raise_error(ActionController::UrlGenerationError)
        end
      end
    end

    ["regular"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when the user is the commenter" do
          put :update, params: @params
          expect(response.status).to eq(200)
        end

        it "returns 302 when not the commenter" do
          @comment.commenter = create(:user)
          @comment.save
          put :update, params: @params
          expect(response.status).to eq(302)
        end
      end
    end

    ["restricted"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 302 when unauthorised" do
          put :update, params: @params
          expect(response.status).to eq(302)
        end
      end
    end
  end

  describe "delete" do
    before(:each) do
      @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee)
      @params = { project_id: @project.id, ticket_id: @ticket.id, id: @comment.id }
    end

    (Member::ROLES - ["restricted", "regular"]).each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "deletes the comment for a member" do
          delete :destroy, params: @params
          expect(response.status).to eq(200)
        end
      end
    end

    ["regular"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 if user is commenter" do
          delete :destroy, params: @params
          expect(response.status).to eq(200)
        end

        it "returns 302 when not the commenter" do
          @comment.commenter = create(:user)
          @comment.save
          delete :destroy, params: @params
          expect(response.status).to eq(302)
        end
      end
    end

    ["restricted"].each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 302 for restricted users" do
          delete :destroy, params: @params
          expect(response.status).to eq(302)
        end
      end
    end
  end
end
