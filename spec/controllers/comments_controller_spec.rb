require 'rails_helper'

describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:assignee) { create(:user) }

  before(:each) do
    sign_in(user)
    @request.env["CONTENT_TYPE"] = "application/json"

    @membership = create(:member, user: user)
    @project = @membership.project
    @ticket = create(:ticket, project: @project)
    @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee)
    @params = {project_id: @project.id, ticket_id: @ticket.id, id: @comment.id}
  end


  describe "index" do
    context "as any user who is a member" do
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

  describe "show" do
    context "as any user who is a member" do
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
    end
  end

end