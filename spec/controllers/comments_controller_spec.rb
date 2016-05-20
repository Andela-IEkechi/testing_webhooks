require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }

#dont create anything you dont have to up front.
  # let(:assignee) { create(:user) }
  # let(:assignee_2) { create(:user) }

  before(:each) do
    sign_in(user)
    @request.env["CONTENT_TYPE"] = "application/json"

#creating these here is ok since we cant test comments without a ticket
    @membership = create(:member, user: user)
    @project = @membership.project
    @ticket = create(:ticket, project: @project)

#dont create these here, create them in the specs where they are needed
    @status = create(:status, project: @project)
    @status_2 = create(:status, project: @project)
    @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee, status: @status)
    
#this one can stay here, we need it all the time
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

  describe "create" do
    before(:each) do
      @comment = build(:comment)
      @params = { project_id: @project.id, ticket_id: @ticket.id, comment: attributes_for(:comment) }
    end

    context "as member" do
      it "returns 200 when authorised" do
        post :create, params: @params
        expect(response.status).to eq(200)
      end
    end
  end

  describe "update" do
    before(:each) do
      @params = {project_id: @project.id, ticket_id: @ticket.id,
                 id: @comment.id, comment: {message: "Updating previous comment"}}
    end
    context "as a member" do
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
        expect {put :update, params: @params}.to raise_error(ActiveRecord::StatementInvalid)
      end

      it "records the changes to the comment" do
        @comment.update_attributes(assignee: assignee_2, status: @status_2)
        expect(@comment.tracked_changes["status_id"]).to eq("[#{@status.id}, #{@status_2.id}]")
        expect(@comment.tracked_changes["assignee_id"]).to eq("[#{assignee.id}, #{assignee_2.id}]")
      end
    end
  end

  describe "delete" do
    before(:each) do
      @comment = create(:comment, ticket: @ticket, commenter: user, assignee: assignee)
    end

    context "as a member" do
      it "deletes the comment for a member" do
        delete :destroy, params: @params
        expect(response.status).to eq(200)
      end
    end
  end
end
