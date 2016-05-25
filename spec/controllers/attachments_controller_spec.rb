require 'rails_helper'
require "refile/file_double"

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in(user)
    @request.env["CONTENT_TYPE"] = "application/json"

    @project = create(:project)
    @ticket = create(:ticket, project: @project)
    @comment = create(:comment, ticket_id: @ticket.id)
  end

  describe "index" do
    before(:each) do
      create(:attachment, comment: @comment, file: Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png"))
      @params = { project_id: @project.id, ticket_id: @ticket.id, comment_id: @comment.id }
    end

    Member::ROLES.each do |role|
      context "as #{role}" do
        before(:each) do
          @project.memberships.clear
          @membership = create(:member, user: user, project: @project, role: role)
        end

        it "returns 200 when authorised" do
          get :index, params: @params
          byebug
          expect(response.status).to eq(200)
        end

        it "returns allowed attachments" do
          get :index, params: @params
          json = JSON.parse(response.body)
          expect(json.count).to eq(@comment.attachments.count)
        end

        it "fails to bring up comments if ticket ID is not provided" do
          @params[:comment_id] = nil
          expect{ get :index, params: @params }.to raise_error(ActionController::UrlGenerationError)
        end

      end
    end
  end
end