require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:assignee) { create(:user) }

  before(:each) do
    sign_in(user)
    @request.env["CONTENT_TYPE"] = "application/json"

    @membership = create(:member, user: user)
    @project = @membership.project
    @ticket = create(:ticket, project: @project)
  end

  describe "index" do
    before(:each) do
      @status = create(:status, project: @project)
      @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee, status: @status)
      @params = {project_id: @project.id, ticket_id: @ticket.id, id: @comment.id}
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        it "returns 200 when authorised" do
          get :index, params: @params
          expect(response.status).to eq(200)
        end

        it "returns created comments" do
          5.times do
            create(:comment, ticket: @ticket, commenter: user, assignee: assignee)
            create(:comment)
          end

          get :index, params: @params
          json = JSON.parse(response.body)
          expect(json.count).to eq(6)
        end
      end
    end
  end

  describe "show" do
    before(:each) do
      @status = create(:status, project: @project)
      @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee, status: @status)
      @params = { project_id: @project.id, ticket_id: @ticket.id, id: @comment.id }
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
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
          expect(json).to eq(JSON.parse(@comment.attributes.to_json))
        end

        it "returns diff from previous comment" do
          @status_2 = create(:status, project: @project, name: "Status2")
          @assignee_2 = create(:user)

          comment_2 = create(:comment,
                             ticket: @ticket,
                             commenter: user,
                             assignee: @assignee_2,
                             status: @status_2)

          @params[:id] = comment_2.id
          get :show, params: @params
          json = JSON.parse(response.body)

          expect(json['previous']).to eq(JSON.parse(@comment.attributes.to_json))
          expect(json['previous']['status_id']).to eq(@status.id)
          expect(json['previous']['assignee_id']).to eq(assignee.id)
        end
      end
    end
  end

  describe "create" do
    before(:each) do
      @comment = build(:comment)
      @params = { project_id: @project.id, ticket_id: @ticket.id, comment: attributes_for(:comment) }
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        it "returns 200 when authorised" do
          post :create, params: @params
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "update" do
    before(:each) do
      @status = create(:status, project: @project)
      @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee, status: @status)
      @params = { project_id: @project.id, ticket_id: @ticket.id,
                 id: @comment.id, comment: attributes_for(:comment) }
    end
    Member::ROLES.each do |role|
      context "as #{role}" do
        it "returns 200 when authorised" do
          put :update, params: @params
          expect(response.status).to eq(200)
        end

        it "returns the updated comment" do
          put :update, params: @params
          json = JSON.parse(response.body)
          @comment.reload
          expect(json).to eq(JSON.parse(@comment.attributes.to_json))
        end

        it "does not update without ticket id" do
          @params[:comment][:ticket_id] = nil
          expect { put :update, params: @params }.to raise_error(ActiveRecord::StatementInvalid)
        end
      end
    end
  end

  describe "delete" do
    before(:each) do
      @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee)
      @params = { project_id: @project.id, ticket_id: @ticket.id, id: @comment.id }
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        it "deletes the comment for a member" do
          delete :destroy, params: @params
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
